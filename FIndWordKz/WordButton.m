//
//  WordButton.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 29.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "WordButton.h"

@implementation WordButton
@synthesize delegate;
@synthesize assignedButtonCenter;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id) init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"WordButton" owner:self options:nil] objectAtIndex:0];
    
    [self addTarget:self action:@selector(didPressButton) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void) didPressButton {
    if([delegate respondsToSelector:@selector(didPressWordButton:)]){
        [delegate didPressWordButton:self];
    }
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
