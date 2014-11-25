//
//  GameCollectionViewCell.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 30.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "GameCollectionViewCell.h"

@implementation GameCollectionViewCell

@synthesize image;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    [image.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [image.layer setBorderWidth: 2.0];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
