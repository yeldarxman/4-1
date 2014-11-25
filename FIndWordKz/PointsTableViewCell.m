//
//  PointsTableViewCell.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 03.08.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "PointsTableViewCell.h"

@implementation PointsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
