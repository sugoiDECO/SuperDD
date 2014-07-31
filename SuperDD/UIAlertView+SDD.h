//
//  UIAlertView+SDD.h
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/10.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SDDRetryBlock)();

static NSString * const kAlertViewTitleError = @"エラー";
static NSString * const kAlertViewButtonTitleOK = @"OK";
static NSString * const kAlertViewButtonTitleYes = @"はい";
static NSString * const kAlertViewButtonTitleNo = @"いいえ";

@interface UIAlertView (SDD)

+ (void)showErrorAndRetryAlertViewWithError:(NSError *)error retryBlock:(SDDRetryBlock)retryBlock;

@end
