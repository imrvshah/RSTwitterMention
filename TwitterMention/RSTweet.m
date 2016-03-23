//
//  Tweet.m
//  TwitterMention
//
//  Created by Ravi Shah on 3/19/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import "RSTweet.h"

@implementation RSTweet
+ (RSTweet*)userFromJSON:(NSDictionary *)dict
{
    RSTweet *tweet=[[RSTweet alloc]init];
    tweet.twitterId=[dict valueForKey:@"id_str"];
    tweet.tweet=[dict valueForKey:@"text"];
    tweet.name=[NSString stringWithFormat:@"%@",[[dict valueForKey:@"user" ] valueForKey:@"name"]];
    tweet.tweetHandle=[NSString stringWithFormat:@"@%@",[[dict valueForKey:@"user" ] valueForKey:@"screen_name"]];;
    tweet.profileURL=[[dict valueForKey:@"user"] valueForKey:@"profile_image_url"];
    return tweet;
}
+ (NSArray*)tweetsFromJSONArray:(NSArray *)arr
{
    NSMutableArray *usersMapped = [NSMutableArray new];
    [arr enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
        
        RSTweet *tweet = [RSTweet userFromJSON:dict];
        [usersMapped addObject:tweet];
    }];
    return usersMapped;
}

@end
