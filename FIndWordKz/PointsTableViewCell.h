//
//  PointsTableViewCell.h
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 03.08.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointsTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *pointsImageView;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsPriceLabel;

@end
