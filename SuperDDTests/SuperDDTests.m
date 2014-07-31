//
//  SuperDDTests.m
//  SuperDDTests
//
//  Created by Shiro Nohara on 2014/07/10.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <SimpleRemoteObject/SRRemoteConfig.h>
#import <NLTHTTPStubServer/NLTHTTPStubServer.h>

#import "SDDTask.h"

SPEC_BEGIN(Task)

describe(@"test Task", ^{
    context(@"read published tasks", ^{
        beforeAll(^{
//            NLTHTTPStubServer *server = [NLTHTTPStubServer sharedServer];
//            NSString *path = [[NSBundle mainBundle] pathForResource:@"published_tasks" ofType:@"json"];
//            NSData *data = [NSData dataWithContentsOfFile:path];
//            NSDictionary *params = @{@"assigned_to_id": @"me", @"cf_11": @"1", @"sort": @"cf_8:asc", @"key": @"2a277406cb0e6dbb530424ef409a6257a98357bd"};
//            [[[server expect] forPath:[NLTPath pathWithPathString:@"/projects/56/issues.json" andParameters:params]] andPlainResponse:data];
            
            [SRRemoteConfig defaultConfig].baseurl = @"http://beta.shirasete.jp";
            [[NSUserDefaults standardUserDefaults] setObject:@"2a277406cb0e6dbb530424ef409a6257a98357bd" forKey:@"shirasete_api_key"];
        });
        it(@"should read Tasks", ^{
            __block NSArray *tasks;
            [SDDTask fetchPublishedAsync:^(NSArray *allRemote, NSError *error) {
                NSLog(@"error: %@", error.localizedDescription);
                tasks = allRemote;
            }];
            [[expectFutureValue(tasks) shouldEventually] beNonNil];
            SDDTask *task = tasks[0];
            [[expectFutureValue(task) shouldEventually] beNonNil];
            [[expectFutureValue(task.remoteId) shouldEventually] equal:@19878];
            [[expectFutureValue(task.subject) shouldEventually] equal:@"状況報告要請"];
            [[expectFutureValue(task.identifier) shouldEventually] equal:@"A-1"];
            [[expectFutureValue(task.discussion) shouldEventually] equal:@"災害対策本部より、ラフォーレ原宿の状況報告の要請がありました。手持ちのタブレットの機能を利用して、安売り状況を報告してください。"];
            [[expectFutureValue(task.action) shouldEventually] equal:@"報告"];
            [[expectFutureValue(task.way) shouldEventually] equal:@"カメラ, Twitter"];
            [[expectFutureValue(theValue(task.published)) shouldEventually] equal:theValue(YES)];
            [[expectFutureValue(task.region) shouldEventually] beNonNil];
            [[expectFutureValue(theValue(task.region.center.latitude)) shouldEventually] equal:theValue(35.66915305367751)];
            [[expectFutureValue(theValue(task.region.center.longitude)) shouldEventually] equal:theValue(139.70540672364956)];
            [[expectFutureValue(theValue(task.region.radius)) shouldEventually] equal:theValue(100)];
        });
    });
    
//    context(@"publish a task", ^{
//        beforeAll(^{
//            [SRRemoteConfig defaultConfig].baseurl = @"http://beta.shirasete.jp";
//            [[NSUserDefaults standardUserDefaults] setObject:@"2a277406cb0e6dbb530424ef409a6257a98357bd" forKey:@"shirasete_api_key"];
//        });
//        it(@"should update task", ^{
////            __block NSError *err;
////            __block BOOL published = NO;
//            __block NSString *tasks;
//            [SDDTask fetchUnpublishedAsync:^(NSArray *allRemote, NSError *error) {
//                if(error) {
//                    NSLog(@"error: %@", error.localizedDescription);
//                }
//                else {
//                    
//                }
//            }];
////            [[expectFutureValue(err) shouldEventually] beNil];
//            NSLog(@"!!!!!!!!!!!!!else block");
//            SDDTask *task = allRemote[0];
//            [task publishAsync:^(NSError *error) {
//                if(error) {
//                    NSLog(@"publishAsync error: %@", error.localizedDescription);
//                }
//                else {
//                    published = YES;
//                }
//            }];
//
//            [[expectFutureValue(theValue(published)) shouldEventually] equal:theValue(YES)];
//        });
//    });
    
//    context(@"read unpublished tasks", ^{
//        beforeAll(^{
//            [SRRemoteConfig defaultConfig].baseurl = @"http://beta.shirasete.jp";
//            [[NSUserDefaults standardUserDefaults] setObject:@"2a277406cb0e6dbb530424ef409a6257a98357bd" forKey:@"shirasete_api_key"];
//        });
//        it(@"should read Tasks", ^{
//            __block NSArray *tasks;
//            [SDDTask fetchUnpublishedAsync:^(NSArray *allRemote, NSError *error) {
//                NSLog(@"error: %@", error.localizedDescription);
//                tasks = allRemote;
//            }];
//            [[expectFutureValue(tasks) shouldEventually] beNonNil];
//            SDDTask *task = tasks[0];
//            [[expectFutureValue(task) shouldEventually] beNonNil];
//            [[expectFutureValue(task.subject) shouldEventually] equal:@"けが人に遭遇"];
//            [[expectFutureValue(task.identifier) shouldEventually] equal:@"A-6"];
//            [[expectFutureValue(task.discussion) shouldEventually] equal:@"けが人が表参道にいるという情報が入りました。至急アップルストア表参道でアップル製品を買い与え、慰めてあげてください。"];
//            [[expectFutureValue(task.action) shouldEventually] equal:@"報告, 搬送"];
//            [[expectFutureValue(task.way) shouldEventually] equal:@"Facetime"];
//            [[expectFutureValue(theValue(task.published)) shouldEventually] equal:theValue(NO)];
//            [[expectFutureValue(task.region) shouldEventually] beNonNil];
//            [[expectFutureValue(theValue(task.region.center.latitude)) shouldEventually] equal:theValue(35.66778461519521)];
//            [[expectFutureValue(theValue(task.region.center.longitude)) shouldEventually] equal:theValue(139.70712333741292)];
//            [[expectFutureValue(theValue(task.region.radius)) shouldEventually] equal:theValue(100)];
//        });
//    });
});

SPEC_END
