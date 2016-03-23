//
//  TweetViewCell.h
//  TwitterMention
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RSTweet.h"
@protocol TweetViewCellDelegate <NSObject>

@optional
- (void)processBtnClick:(NSInteger)tag;
@end
@interface RSTweetViewCell : UITableViewCell

@property (nonatomic, weak) UIViewController<TweetViewCellDelegate> *delegate;
@property (nonatomic, strong) RSTweet *tweet;
@property (nonatomic, strong) IBOutlet UIImageView *twitterAvatar;
@property (nonatomic, strong) IBOutlet UILabel *twitterHandle;
@property (nonatomic, strong) IBOutlet UILabel *twitterName;
@property (nonatomic, strong) IBOutlet UILabel *twitterContent;
@property (nonatomic, strong) IBOutlet UIButton *twitterRetweetBtn;
@property (nonatomic, strong) IBOutlet UIButton *twitterDeleteBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tweetContentViewHeight;

+ (CGFloat)heightOfCellWithTweet:(RSTweet*)tweet;
- (void)setupViewForTweet:(RSTweet*)tweet ;
- (void)setupView;


@end
