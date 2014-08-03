//
//  SDDDetailViewController.h
//  SuperDD
//
//  Created by Shiro Nohara on 2014/07/04.
//  Copyright (c) 2014年 Georepublic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDDTask;

@interface SDDDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) SDDTask *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UITextView *discussionTextView;
@property (weak, nonatomic) IBOutlet UITextView *actionTextView;
@property (weak, nonatomic) IBOutlet UITextView *wayTextView;

@property (weak, nonatomic) IBOutlet UIView *noTaskLabelView;


@end
