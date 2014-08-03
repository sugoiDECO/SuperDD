//
//  SDDDetailViewController.m
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/04.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import "SDDDetailViewController.h"

#import "SDDTask.h"


@interface SDDDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation SDDDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.noTaskLabelView.hidden = YES;
        self.identifierLabel.text = self.detailItem.identifier;
        self.subjectLabel.text = self.detailItem.subject;
        self.discussionTextView.text = self.detailItem.discussion;
        self.discussionTextView.font = [UIFont systemFontOfSize:24.0];
        self.actionTextView.text = self.detailItem.action;
        self.actionTextView.font = [UIFont systemFontOfSize:24.0];
        self.wayTextView.text = self.detailItem.way;
        self.wayTextView.font = [UIFont systemFontOfSize:24.0];
    }
    else {
        self.noTaskLabelView.hidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = @"一覧";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
