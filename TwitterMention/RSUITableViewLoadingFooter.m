//
//  UITableViewLoadingFooter.m
//  TwitterMention
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

#import "RSUITableViewLoadingFooter.h"

@interface RSUITableViewLoadingFooter()

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation RSUITableViewLoadingFooter

- (void)awakeFromNib
{
    self.view = [[[NSBundle mainBundle] loadNibNamed:@"UITableViewLoadingFooter" owner:self options:nil] objectAtIndex:0];
    self.view.frame = CGRectMake(self.view.frame.origin.x,
                                 self.view.frame.origin.x,
                                 self.frame.size.width,
                                 self.view.frame.size.height);
    [self addSubview:self.view];
    [self stopLoading];
}

- (void)startLoading
{
    [self.indicatorView startAnimating];
}

- (void)stopLoading
{
    [self.indicatorView stopAnimating];
}

@end
