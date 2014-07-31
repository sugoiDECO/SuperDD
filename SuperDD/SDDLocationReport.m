//
//  SDDLocationReport.m
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/10.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import "SDDLocationReport.h"

#import <AFNetworking/AFNetworking.h>

@implementation SDDLocationReport

+ (NSString *)representUrl
{
    return @"/projects/57/issues.json";
}

+ (NSString *)resultKey
{
    return @"issues";
}

+ (void)reportLocation:(CLLocation *)location
{
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDegrees lng = location.coordinate.longitude;
    NSString *geometry = [NSString stringWithFormat:@"{\"type\":\"Point\",\"coordinates\":[%f,%f]}", lng, lat];
    NSDictionary *requestBody = @{@"issue": @{@"project_id": @57,
                                              @"subject": @"post from iPad",
                                              @"geometry": geometry},
                                  @"key": SHIRASETE_API_KEY};
    
    NSString *baseUrl = [SRRemoteConfig defaultConfig].baseurl;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl, [self representUrl]] parameters:requestBody success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
