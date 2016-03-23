//
//  WebStore.m
//  TwitterMention
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import "RSWebStore.h"
#import "Constant.h"
#import "RSTweet.h"
@implementation RSWebStore
+ (void)searchTweet:(NSString *)query block:(void (^)(NSDictionary* arrTweets, NSString *error))block
{
    
    
    
    [RSWebStore searchTweetswithQuery:query block:^(NSDictionary *arrTweets, NSString *error) {
        if (!error) {
            NSArray *tweets = [RSTweet tweetsFromJSONArray:[arrTweets objectForKey:@"statuses"]];
            NSDictionary * dict =[[NSDictionary alloc]initWithObjectsAndKeys:[arrTweets valueForKey:@"search_metadata"],@"url",tweets,@"result", nil];
            block(dict, error);
        } else {
            block(nil, error);
        }
    }];
}

+(void)searchTweetswithQuery:(NSString*)query block:(void (^)(NSDictionary* arrTweets, NSString *error))block

{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    NSString* accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOKEN"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",hostUrl,searchUrl,query]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@",accessToken] forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if ([httpResponse statusCode]==200) {
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary * arrayJSON = [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            block(arrayJSON,error.description);
           
        }
       else{
            (nil,error.debugDescription);
        }
        }];
    [dataTask resume];
}
+(void)authenticateApp:(void (^)(BOOL isAuth, NSString *error))block
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    NSString* postString = @"grant_type=client_credentials";
    NSData* jsonData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = jsonData;
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",hostUrl,authUrl]]];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    NSData *plainData = [[NSString stringWithFormat:@"%@:%@",consumerKey,consumerSecretKey] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *secret = [plainData base64EncodedStringWithOptions:0];
    
    [request setValue:[NSString stringWithFormat:@"Basic %@",secret] forHTTPHeaderField:@"Authorization"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if ([httpResponse statusCode]==200) {
        NSMutableDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [[NSUserDefaults standardUserDefaults] setValue:[jsonData valueForKey:@"access_token"] forKey:@"TOKEN"];
        block(YES,nil);
        }
        else
        {
        dispatch_async(dispatch_get_main_queue(), ^{
            block(NO,error.description);
        });
        }
    }];
    [dataTask resume];
}

@end
