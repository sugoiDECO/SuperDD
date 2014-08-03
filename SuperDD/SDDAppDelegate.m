//
//  SDDAppDelegate.m
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/04.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import "SDDAppDelegate.h"

#import <Parse/Parse.h>
#import <SRRemoteConfig.h>

#import "SDDUser.h"


@implementation SDDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"SViiPvhjP57ZBEAZGsKEq16TuAG4OeTbaAe7z9WH"
                  clientKey:@"yNIRypQQLzZgV2Tv9QB659beJCQyOVZWO0iz37A5"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [NSUserDefaults resetStandardUserDefaults];
    NSString *shiraseteAPIKey = SHIRASETE_API_KEY;
    if (shiraseteAPIKey && shiraseteAPIKey.length > 0) {
        NSLog(@"shiraseteAPIKey: %@", shiraseteAPIKey);
    }
    else {
        NSLog(@"No Key !!!!");
    }
    
    [SRRemoteConfig defaultConfig].baseurl = @"http://beta.shirasete.jp";
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.channels = @[];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SDDUser fetchAsync:^(NSArray *allRemote, NSError *error) {
                if (error) {
                    NSLog(@"fetch user error: %@", error.localizedDescription);
                }
                else {
                    SDDUser *currentUser = allRemote[0];
                    NSString *channelName = [NSString stringWithFormat:@"channel_%@", currentUser.remoteId];
                    NSLog(@"trying to set channel: %@", channelName);
                    [PFPush subscribeToChannelInBackground:channelName block:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"subscribeToChannelInBackground succeeded");
                        }
                        else {
                            NSLog(@"subscribeToChannelInBackground error: %@", error.localizedDescription);
                        }
                    }];
                }
            }];
        }
        else {
            NSLog(@"saveInBackgroundWithBlock error: %@", error.localizedDescription);
        }
    }];
    
    
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
    splitViewController.delegate = (id)navigationController.topViewController;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self refreshTasks];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:notification.alertBody delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
    else {
        
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded) {
            
        }
        else {
            
        }
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
//    NSNotification *notification = [NSNotification notificationWithName:@"refreshTasks" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self refreshTasks];
}

- (void)refreshTasks
{
    NSNotification *notification = [NSNotification notificationWithName:@"refreshTasks" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
