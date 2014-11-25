//
//  PointsTableViewController.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 03.08.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "PointsTableViewController.h"

@interface PointsTableViewController ()

@end

@implementation PointsTableViewController

@synthesize points;
@synthesize blackBackground;
@synthesize activityIndicator;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //activity indicator
    blackBackground = [[UIView alloc] init];
    [blackBackground setFrame: self.view.frame];
    [blackBackground setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    activityIndicator = [[UIActivityIndicatorView alloc] init];
    [blackBackground addSubview:activityIndicator];
    [activityIndicator setCenter:blackBackground.center];
    [activityIndicator startAnimating];
    [activityIndicator setColor:[UIColor whiteColor]];
    
    [blackBackground setAlpha:0.0];
    [self.view addSubview:blackBackground];
    
    //set delegate
    [[PointsIAPHelper sharedInstance] setDelegate:self];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reload) forControlEvents:UIControlEventValueChanged];
    
    [self reload];
}

- (void)reload {
    [self.refreshControl beginRefreshing];
    
    if (self.tableView.contentOffset.y == 0) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
        } completion:^(BOOL finished){
            
        }];
    }
    
    [[PointsIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *aPoints) {
        if (success) {
            points = aPoints;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return points.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PointsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PointsTableViewCell" forIndexPath:indexPath];
    SKProduct * product = (SKProduct *) points[indexPath.row];
    cell.pointsLabel.text = product.localizedTitle;
    NSString *priceString = [NSString stringWithFormat:@"%@%@", [product.priceLocale objectForKey:NSLocaleCurrencySymbol], product.price];
    cell.pointsPriceLabel.text = priceString;
    NSLog(@"%@", priceString);
    
    if([product.localizedTitle hasPrefix:@"200"]){
        [cell.pointsImageView setImage:[UIImage imageNamed:@"200 points image.png"]];
    } else if([product.localizedTitle hasPrefix:@"500"]){
        [cell.pointsImageView setImage:[UIImage imageNamed:@"500 points image.png"]];
    } else if([product.localizedTitle hasPrefix:@"1200"]) {
        [cell.pointsImageView setImage:[UIImage imageNamed:@"1200 points image.png"]];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[PointsIAPHelper sharedInstance] buyProduct:[points objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) showLoadingScreen {
    [self.view bringSubviewToFront:blackBackground];
    [self.backButton setEnabled:NO];
    [blackBackground setAlpha:1.0];
    [self.view setUserInteractionEnabled:NO];
}

- (void) hideLoadingScreen {
    [self.view sendSubviewToBack:blackBackground];
    [self.backButton setEnabled:YES];
    [blackBackground setAlpha:0.0];
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark - delegate
- (void) buyingPorduct {
    [self showLoadingScreen];
}

- (void) didBuyProduct {
    [self hideLoadingScreen];
    if([self.delegate respondsToSelector:@selector(didBuyPoints)]){
        [self.delegate didBuyPoints];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) failedToBuyProduct {
    [self hideLoadingScreen];
}

@end
