//
//  SDDUser.m
//  SuperDD
//
//  Created by Shiro Nohara on 2014/08/01.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import "SDDUser.h"

@implementation SDDUser

+ (NSString *)representUrl
{
    return @"/users/current.json";
}

+ (NSString *)resultKey
{
    return @"user";
}

@end
