//
//  UIAlertView+SDD.m
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/10.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import "UIAlertView+SDD.h"

#import <BlocksKit/BlocksKit.h>
#import <BlocksKit/BlocksKit+UIKit.h>

@implementation UIAlertView (SDD)

+ (void)showErrorAndRetryAlertViewWithError:(NSError *)error retryBlock:(SDDRetryBlock)retryBlock
{
    NSString *errorDescription = error.localizedDescription;
    NSLog(@"error: %@", errorDescription);
    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:kAlertViewTitleError message:errorDescription];
    [alertView bk_addButtonWithTitle:@"あきらめる" handler:nil];
    [alertView bk_addButtonWithTitle:@"再試行" handler:retryBlock];
    [alertView show];
}

@end
