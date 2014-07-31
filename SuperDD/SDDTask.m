//
//  SDDTask.m
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/04.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import "SDDTask.h"

#import <AFNetworking/AFNetworking.h>

static NSString *kSDDCFIdentifierOrder = @"cf_8";
static NSString *kSDDCFIdentifierPublished = @"cf_11";

static NSMutableArray *tasks;


@interface SDDTask ()

@property (nonatomic, strong) NSArray *custom_fields;
@property (nonatomic, strong) NSString *geometry;
@property (nonatomic) CLLocationDistance radius;

@end


@implementation SDDTask

//
// custom fields
//
// cf_8  order
// cf_9  radius
// cf_10 identifier
// cf_11 published
// cf_12 アクション
// cf_13 手段
// cf_14 discussion

+ (NSString *)representUrl
{
    return @"/projects/56/issues.json";
}

+ (NSString *)resultKey
{
    return @"issues";
}

//+ (NSArray *)tasksFromPropertyList:(NSString *)bundleName
//{
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *filePath = [bundle pathForResource:bundleName ofType:@"plist"];
//    NSArray *plist = [NSArray arrayWithContentsOfFile:filePath];
//    
//    NSMutableArray *tasks = [NSMutableArray array];
//    for (NSDictionary *dic in plist) {
//        SDDTask *task = [SDDTask taskWithDictionary:dic];
//        [tasks addObject:task];
//    }
//    
//    return tasks;
//}

- (void)parseObject:(id)object ForKey:(NSString *)key
{
    if ([key isEqualToString:@"custom_fields"]) {
        NSArray *fields = object;
        for (NSDictionary *field in fields) {
            NSNumber *fieldID = field[@"id"];
            id value = field[@"value"];
            if ([fieldID isEqualToNumber:@10]) {
                self.identifier = value;
            }
            if ([fieldID isEqualToNumber:@14]) {
                self.discussion = value;
            }
            if ([fieldID isEqualToNumber:@12]) {
                self.action = value;
            }
            if ([fieldID isEqualToNumber:@13]) {
                self.way = value;
            }
            if ([fieldID isEqualToValue:@11]) {
                if ([value isEqualToString:@"1"]) {
                    self.published = YES;
                }
                else {
                    self.published = NO;
                }
            }
            if ([fieldID isEqualToNumber:@9]) {
                self.radius = [(NSString *)value doubleValue];
            }
        }
    }
    else {
        [super parseObject:object ForKey:key];
    }
}

//+ (SDDTask *)taskWithDictionary:(NSDictionary *)dictionary
//{
//    SDDTask *task = [[SDDTask alloc] init];
//    task.identifier = dictionary[@"identifier"];
//    task.subject = dictionary[@"subject"];
//    task.discussion = dictionary[@"discussion"];
//    task.action = dictionary[@"action"];
//    task.way = dictionary[@"way"];
//    NSNumber *latitude = dictionary[@"latitude"];
//    NSNumber *longitude = dictionary[@"longitude"];
//    NSNumber *radius = dictionary[@"radius"];
//    if (latitude && longitude && radius) {
//        task.region = [[CLCircularRegion alloc] initWithCenter:CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]) radius:[radius doubleValue] identifier:task.identifier];
//    }
//    
//    return task;
//}

+ (void)fetchPublishedAsync:(SRFetchCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sort"] = @"cf_8:desc";
    params[@"assigned_to_id"] = @"me";
    params[kSDDCFIdentifierPublished] = @1;
    NSString *apiKey = SHIRASETE_API_KEY;
    if (apiKey) {
        params[@"key"] = apiKey;
    }
    NSLog(@"params: %@", params);
    [self fetchAsyncWithParams:params async:completionBlock];
}

+ (void)fetchUnpublishedAsync:(SRFetchCompletionBlock)completionBlock
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"sort"] = @"cf_8:asc";
    params[@"assigned_to_id"] = @"me";
    params[kSDDCFIdentifierPublished] = @0;
    NSString *apiKey = SHIRASETE_API_KEY;
    if (apiKey) {
        params[@"key"] = apiKey;
    }
    NSLog(@"params: %@", params);
    [self fetchAsyncWithParams:params async:completionBlock];
}

- (CLLocationCoordinate2D)center
{
    NSData *data = [self.geometry dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *geometryDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&e];
    NSArray *coordinates = geometryDictionary[@"coordinates"];
    
    CLLocationCoordinate2D coordinate2d = CLLocationCoordinate2DMake([(NSNumber *)coordinates[1] doubleValue], [(NSNumber *)coordinates[0] doubleValue]);
    return coordinate2d;
}

- (CLCircularRegion *)region
{
    CLCircularRegion *r = [[CLCircularRegion alloc] initWithCenter:[self center] radius:self.radius identifier:self.identifier];
    return r;
}

- (void)publishAsync:(SDDCompletionBlock)completionBlock
{
    NSDictionary *requestBody = @{@"issue": @{
                                          @"custom_fields": @[
                                                  @{@"value":@"1", @"id":@11}
                                          ]
                                  },
                                  @"key": SHIRASETE_API_KEY};
    
    NSString *baseUrl = [SRRemoteConfig defaultConfig].baseurl;
    NSNumber *remoteId = self.remoteId;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager PUT:[NSString stringWithFormat:@"%@/issues/%@.json", baseUrl, remoteId] parameters:requestBody success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        completionBlock(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        completionBlock(error);
    }];
}

@end
