//
//  Tweet.h
//  TwitterMention
//
//  Created by Ravi Shah on 3/19/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSTweet : NSObject
@property (nonatomic,strong) NSString* profileURL;
@property (nonatomic,strong) NSString* tweetHandle;
@property (nonatomic,strong) NSString* tweet;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* twitterId;
@property (nonatomic,strong) NSString* twitterURL;
@property (nonatomic) float tweetHeight;
+ (NSArray*)tweetsFromJSONArray:(NSArray *)arr;
@end
