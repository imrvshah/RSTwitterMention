//
//  WebStore.h
//  TwitterMention
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSWebStore : NSObject
@property(nonatomic,strong)NSString *strNextURL;
@property(nonatomic,strong)NSString *strRefreshURL;
+ (void)searchTweet:(NSString *)query block:(void (^)(NSDictionary* arrTweets, NSString *error))block;
+(void)searchTweetswithQuery:(NSString*)query block:(void (^)(NSDictionary* arrTweets, NSString *error))block;
+(void)authenticateApp:(void (^)(BOOL isAuth, NSString *error))block;

@end
