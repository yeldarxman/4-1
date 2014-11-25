//
//  PointsTableViewController.h
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 03.08.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PointsIAPHelper.h"
#import "PointsTableViewCell.h"
#import "StoreKit/StoreKit.h"

@protocol PointsTableViewControllerDelegate <NSObject>

- (void) didBuyPoints;

@end

@interface PointsTableViewController : UITableViewController<PointsIAPHelperDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) NSArray *points;
@property (strong, nonatomic) UIView* blackBackground;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property id<PointsTableViewControllerDelegate> delegate;

- (IBAction)backButtonPressed:(id)sender;

@end
