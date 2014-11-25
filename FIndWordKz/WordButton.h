//
//  WordButton.h
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 29.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Wordbuttondelegate <NSObject>

- (void) didPressWordButton: (id) button;

@end

@interface WordButton : UIButton

@property (strong, nonatomic) UIButton *assignedButton;
@property CGPoint assignedButtonCenter;
@property id<Wordbuttondelegate> delegate;
@property BOOL hasLetter;
@property BOOL hasCorrectLetter;
    
@end
