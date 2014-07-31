//
//  SDDLocationReport.h
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/10.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import "SRSimpleRemoteObject.h"

#import <CoreLocation/CoreLocation.h>

@interface SDDLocationReport : SRSimpleRemoteObject

+ (void)reportLocation:(CLLocation *)location;

@property (nonatomic, strong) NSString *geometry;

@end
