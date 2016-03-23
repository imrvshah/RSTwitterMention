//
//  Utility.m
//  TwitterMention
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import "RSUtility.h"

@implementation RSUtility
+(BOOL)isAuthenticated
{
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults stringForKey:@"TOKEN"];
    if (token == nil) {
        return false;
    }
    return true;
}
@end
