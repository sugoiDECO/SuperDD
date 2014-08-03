//
//  SDDMasterViewController.m
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/04.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import "SDDMasterViewController.h"

#import "SDDDetailViewController.h"

#import "UIAlertView+SDD.h"
#import "SDDTask.h"
#import "SDDLocationReport.h"

@interface SDDMasterViewController () {
    NSMutableArray *_tasks;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) SDDTask *latestUnpublishedTask;
@property (nonatomic, strong) CLCircularRegion *region;

@end

@implementation SDDMasterViewController

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.detailViewController = (SDDDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(refresh) name:@"refreshTasks" object:nil];
    
    self.locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 25;
        [self.locationManager startUpdatingLocation];
    }
    
//    _tasks = [[[[SDDTask tasksFromPropertyList:@"tasks"] reverseObjectEnumerator] allObjects] mutableCopy];
//    
//    SDDTask *task = _tasks[0];
//    self.detailViewController.detailItem = task;
    [self refresh];
//    [self localNotification];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

//- (void)localNotification
//{
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
//    notification.timeZone = [NSTimeZone defaultTimeZone];
//    notification.alertBody = @"LocalNotification after 10 sec";
//    notification.soundName = UILocalNotificationDefaultSoundName;
//    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
////    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//}

- (void)refresh
{
    NSLog(@"refresh");
    [SDDTask fetchPublishedAsync:^(NSArray *allRemote, NSError *error) {
        if (error) {
            [UIAlertView showErrorAndRetryAlertViewWithError:error retryBlock:^{
                [self refresh];
            }];
        }
        else {
            _tasks = [allRemote mutableCopy];
            [self.tableView reloadData];
            if (_tasks.count > 0) {
                SDDTask *task = _tasks[0];
                self.detailViewController.detailItem = task;
            }
            else {
                self.detailViewController.detailItem = nil;
            }
//            [self fetchLatestUnpublishedTask];
        }
    }];
}

//- (void)fetchLatestUnpublishedTask
//{
//    [SDDTask fetchUnpublishedAsync:^(NSArray *allRemote, NSError *error) {
//        if (error) {
//            [UIAlertView showErrorAndRetryAlertViewWithError:error retryBlock:^{
//                [self fetchLatestUnpublishedTask];
//            }];
//        }
//        else {
//            if (allRemote.count > 0) {
//                SDDTask *task = allRemote[0];
//                self.latestUnpublishedTask = task;
//                NSLog(@"set latestUnpublishedTask: %@", self.latestUnpublishedTask.identifier);
//                self.region = self.latestUnpublishedTask.region;
//                [self startMonitoringForRegion];
//            }
//            else {
//                NSLog(@"No more unpublished tasks");
//            }
//        }
//    }];
//}

//- (void)publishTask
//{
//    [self.latestUnpublishedTask publishAsync:^(NSError *error) {
//        if (error) {
//            NSLog(@"latestUnpublishedTask error: %@", error.localizedDescription);
//            [UIAlertView showErrorAndRetryAlertViewWithError:error retryBlock:^{
//                [self publishTask];
//            }];
//        }
//        else {
//            NSLog(@"published");
//            [self refresh];
//        }
//    }];
//}

//- (void)stopMonitoringForRegion
//{
//    if (self.region) {
//        [self.locationManager stopMonitoringForRegion:self.region];
//    }
//}

//- (void)startMonitoringForRegion
//{
//    if (self.region) {
//        NSLog(@"startMonitoringForRegion");
//        [self.locationManager startMonitoringForRegion:self.region];
//    }
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _tasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    SDDTask *task = _tasks[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", task.identifier, task.subject];
    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDDTask *task = _tasks[indexPath.row];
    self.detailViewController.detailItem = task;
}

#pragma mark - CLLocation Manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [SDDLocationReport reportLocation:locations[0]];
}

//- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
//{
//    NSLog(@"didEnterRegion");
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
////    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:-1];
////    notification.timeZone = [NSTimeZone defaultTimeZone];
//    notification.alertBody = [NSString stringWithFormat:@"%@ %@", self.latestUnpublishedTask.identifier, self.latestUnpublishedTask.subject];
//    notification.soundName = UILocalNotificationDefaultSoundName;
////    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
//    
////    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"didEnterRegion" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////    [alertView show];
//    
//    [self.locationManager stopMonitoringForRegion:self.region];
//    [self publishTask];
//}

//- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
//{
//    NSLog(@"didEnterRegion");
////    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"didExitRegion" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////    [alertView show];
//}

- (IBAction)p:(id)sender {
//    [self publishTask];
}

@end
