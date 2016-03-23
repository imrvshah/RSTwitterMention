//
//  ViewController.h
//  TwitterMention
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSViewController : UIViewController
@property(nonatomic,strong)NSString *strNextURL;
@property(nonatomic,strong)NSString *strTemp;
@property(nonatomic,strong)NSString *strRefreshURL;
- (NSString *)URLEncodeStringFromString:(NSString *)string;
@end

