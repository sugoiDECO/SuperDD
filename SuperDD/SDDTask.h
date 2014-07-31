//
//  SDDTask.h
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/04.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

#import <SRSimpleRemoteObject.h>

typedef void (^SDDCompletionBlock)(NSError *error);

@interface SDDTask : SRSimpleRemoteObject

//@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic, strong) NSString *discussion;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *way;
@property (nonatomic, readonly) CLCircularRegion *region;
@property (nonatomic) BOOL published;
//@property (nonatomic, strong) NSArray *custom_fields;
//@property (nonatomic, strong) NSString *geometry;
//@property (nonatomic) CLLocationDistance radius;

//+ (NSArray *)tasksFromPropertyList:(NSString *)bundleName;
//+ (SDDTask *)taskWithDictionary:(NSDictionary *)dictionary;
//+ (NSArray *)disclosedTasks;
//+ (SDDTask *)discloseNextTask;
+ (void)fetchPublishedAsync:(SRFetchCompletionBlock)completionBlock;
+ (void)fetchUnpublishedAsync:(SRFetchCompletionBlock)completionBlock;
- (void)publishAsync:(SDDCompletionBlock)completionBlock;

@end
