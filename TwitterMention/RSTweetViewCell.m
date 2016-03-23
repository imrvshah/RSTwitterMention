//
//  TweetViewCell.m
//  TwitterMention
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import "RSTweetViewCell.h"

#define POST_TEXT_WIDTH 282
#define POST_TEXT_HEIGHT 110
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@implementation RSTweetViewCell

+ (UILabel*)tweetLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, POST_TEXT_WIDTH, POST_TEXT_HEIGHT)];
    [label setFont:[UIFont fontWithName:@"Verdana" size:12.0]];
    return label;
}

+ (CGFloat)heightOfCellWithTweet:(RSTweet*)tweet
{
    CGFloat cellHeight = 0;
    UILabel *tweetLabel = [RSTweetViewCell tweetLabel];
    [tweetLabel setText:tweet.tweet];
    CGSize constraint = CGSizeMake(tweetLabel.frame.size.width, 20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [tweetLabel.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
        attributes:@{NSFontAttributeName:tweetLabel.font}
                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    cellHeight=60;
    cellHeight +=  size.height;
    tweet.tweetHeight= size.height+5;
    return MAX(cellHeight, 44) ;
}


- (void)awakeFromNib
{
    self.twitterAvatar.layer.masksToBounds = YES;
    self.twitterAvatar.layer.cornerRadius = 4;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.twitterContent setFont:[UIFont fontWithName:@"Verdana" size:12.0]];
    
//    [self.postLikeBtn setImage:[[UIImage imageNamed:@"like_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
//    [self.postReflectBtn setImage:[UIImage imageNamed:@"comment_icon"] forState:UIControlStateNormal];
//    [self.postMoreBtn setImage:[UIImage imageNamed:@"post_more_btn"] forState:UIControlStateNormal];

}

- (void)setupViewForTweet:(RSTweet*)tweet
{
    self.tweet = tweet;
    [self setupView];
}

- (void)setupView
{
    
    UILabel *tweetLabel = [RSTweetViewCell tweetLabel];
    [tweetLabel setText:self.tweet.tweet];
    CGSize constraint = CGSizeMake(tweetLabel.frame.size.width, 20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [tweetLabel.text boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:tweetLabel.font}
                                                       context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    self.tweetContentViewHeight.constant=size.height;
    
  __block  NSData *imgData;
    dispatch_async(kBgQueue, ^{
        imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.tweet.profileURL]]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           self.twitterAvatar.image = [UIImage imageWithData:imgData];
        });
    });
    self.twitterContent.text=self.tweet.tweet;
    [self.twitterName setText:self.tweet.name];
    self.twitterHandle.text = self.tweet.tweetHandle;
}

- (IBAction)onDeleteBtnClick:(UIButton*)sender
{
    [self.delegate processBtnClick:sender.tag];
}

- (IBAction)onRetweetBtnClick:(id)sender
{
    
}




@end