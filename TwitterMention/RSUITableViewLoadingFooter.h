//
//  UITableViewLoadingFooter.h
//  TwitterMention
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSUITableViewLoadingFooter : UIView

@property (nonatomic, strong) UIView *view;

- (void)startLoading;
- (void)stopLoading;

@end
