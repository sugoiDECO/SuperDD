//
//  SDDMasterViewController.h
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/04.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>

@class SDDDetailViewController;

@interface SDDMasterViewController : UITableViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) SDDDetailViewController *detailViewController;

- (IBAction)p:(id)sender;

@end
