//
//  CorrectAnswerViewController.h
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 31.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

@protocol CorrectAnswerViewControllerDelegate <NSObject>

- (void) nextQuestion;

@end

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"

@interface CorrectAnswerViewController : UIViewController <GADInterstitialDelegate>

@property (strong, nonatomic) IBOutlet UILabel *correctWordLabel;
@property (strong, nonatomic) GADInterstitial *interstitial;
@property id<CorrectAnswerViewControllerDelegate> delegate;
@property (strong, nonatomic) NSString *correctWord;
@property BOOL adReceived;

- (IBAction)nextQuestionButtonPressed:(id)sender;

@end
