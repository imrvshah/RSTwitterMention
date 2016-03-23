//
//  ViewController.m
//  TwitterMention
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import "RSViewController.h"
#import "RSUITableViewLoadingFooter.h"
#import "RSWebStore.h"
#import "RSTweet.h"
#import "RSTweetViewCell.h"
@interface ViewController ()<UIScrollViewDelegate,TweetViewCellDelegate>
{
    NSMutableArray *tweets;
    BOOL loadingTweets;
    BOOL isRefreshing;
    BOOL noMoreTweets;
    BOOL initialLoadDone;
    int tweetsLimit;
    int tweetOffset;
    UITableViewLoadingFooter *tableViewLoadingFooter;
    CGFloat previousScrollViewYOffset;
}
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tweetsLimit=15;
    isRefreshing = YES;
    NSString* query =[self URLEncodeStringFromString:@"@peek"];
    NSString *q= [NSString stringWithFormat:@"%@", query];
    self.strTemp=[NSString stringWithFormat:@"?q=%@&count=%d&result_type=mixed",q,tweetsLimit ];
    self.strNextURL= [NSString stringWithFormat:@"?q=%@&count=%d&result_type=mixed",q,tweetsLimit ];
    tableViewLoadingFooter = (UITableViewLoadingFooter*)self.tableView.tableFooterView;
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"]){
        [self beginRefresh];
    }
    else{
        [RSWebStore authenticateApp:^(BOOL isAuth, NSString *error) {
            if(isAuth==YES){
                [self beginRefresh];
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"TwitterMention" message:error preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:NSLocalizedString(@"OK", @"OK action")style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               NSLog(@"OK action");
                                           }];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
            }
        }];
    }
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshClicked) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    // Do any additional setup after loading the view, typically from a nib.
}
- (NSString *)URLEncodeStringFromString:(NSString *)string
{
    
    return    [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLUserAllowedCharacterSet]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)beginRefresh
{
    [tableViewLoadingFooter stopLoading];
    [self refreshHomePosts];
}

- (void)reloadHomePage
{
    
    [self refreshHomePosts];
}

- (void)refreshHomePosts
{
    noMoreTweets = NO;
    loadingTweets = NO;
    //    postsOffset = 0;
    isRefreshing = YES;
    [tableViewLoadingFooter stopLoading];
    [self.refreshControl beginRefreshing];
    [self getHomeContents];
}

-(void)refreshClicked{
    tweetOffset=0;
    self.strNextURL=self.strTemp;
    [self beginRefresh];
}

- (void)getHomeContents
{
    
    //self.currenFilterLabel.text = currentFilter;
    if (!loadingTweets && !noMoreTweets) {
        loadingTweets = YES;
        //self.currenFilterButton.enabled = NO;
        [RSWebStore searchTweet:self.strNextURL block:^(NSDictionary *arrTweets1, NSString *error) {
            NSArray *arrTweets=[arrTweets1 valueForKey:@"result"];
            self.strNextURL=[[arrTweets1 valueForKey:@"url"] valueForKey:@"next_results"];
            self.strRefreshURL=[[arrTweets1 valueForKey:@"url"] valueForKey:@"refresh_url"];
            [tableViewLoadingFooter stopLoading];
            [self.refreshControl endRefreshing];
            loadingTweets = NO;
            isRefreshing = NO;
            //self.currenFilterButton.enabled = YES;
            if (!error) {
                if ([arrTweets count] == 0) {
                    noMoreTweets = YES;
                } else {
                    if (tweetOffset == 0) {
                        initialLoadDone = YES;
                        tweets = [arrTweets mutableCopy];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                        
                        
                    } else
                    {
                        NSMutableArray *rowsToInsert = [NSMutableArray new];
                        
                        [arrTweets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            [rowsToInsert addObject:[NSIndexPath indexPathForItem:tweets.count + idx inSection:0]];
                        }];
                        
                        [tweets addObjectsFromArray:arrTweets];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView insertRowsAtIndexPaths:rowsToInsert withRowAnimation:UITableViewRowAnimationFade];
                        });
                        
                    }
                }
            } else {
                // prevents repeated requests from scrolling
                noMoreTweets = YES;
            }
        }];
    }
}

- (void)onLoadMorePosts
{
    if (!loadingTweets && !noMoreTweets && !isRefreshing) {
        tweetOffset = tweetOffset+tweetsLimit;
        [tableViewLoadingFooter startLoading];
        [self getHomeContents];
    }
}
#pragma mark -
#pragma mark UITableView Delegates

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tweets count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSTweet *tweet = [tweets objectAtIndex:indexPath.row];
    CGFloat height = [RSTweetViewCell heightOfCellWithTweet:tweet];
    return height;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 500.0f;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TweetViewCell";
    RSTweetViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        [self.tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    RSTweet *tweet = [tweets objectAtIndex:indexPath.row];
    [cell setupViewForTweet:tweet];
    cell.delegate=self;
    cell.twitterDeleteBtn.tag=indexPath.row;
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor=[UIColor lightGrayColor];
        
    }
    else{
          cell.contentView. backgroundColor=[UIColor lightTextColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = -60;
    if(y > h + reload_distance) {
        [self onLoadMorePosts];
    }
    
}
- (void)processBtnClick:(UIButton *)button{
    
    [tweets removeObjectAtIndex:button.tag];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:button.tag inSection:0]] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView reloadData];
}


@end
