//
//  GameViewController.h
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 26.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "WordButton.h"
#import "CorrectAnswerViewController.h"
#import "PointsTableViewController.h"
#import "GADInterstitial.h"
#import "GADBannerView.h"

@interface GameViewController : UIViewController <Wordbuttondelegate, UIAlertViewDelegate, CorrectAnswerViewControllerDelegate, GADInterstitialDelegate, PointsTableViewControllerDelegate>
{
    GADBannerView *bannerView_;
}

//images
@property (strong, nonatomic) IBOutlet UIView *imagesHolderView;
@property (strong, nonatomic) IBOutlet UIImageView *image1;
@property (strong, nonatomic) IBOutlet UIImageView *image2;
@property (strong, nonatomic) IBOutlet UIImageView *image3;
@property (strong, nonatomic) IBOutlet UIImageView *image4;


//level & score
@property (strong, nonatomic) IBOutlet UILabel *levelLabel;
@property (strong, nonatomic) IBOutlet UIButton *scoreButton;

//word buttons
@property (strong, nonatomic) IBOutlet UIView *wordButtonsHolder;
@property (strong, nonatomic) NSMutableArray *wordLetterButtons;

//bottom view
@property (strong, nonatomic) IBOutlet UIView *bottomViewHolder;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBgImageView;
// --- buttons
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;
@property (strong, nonatomic) IBOutlet UIButton *button4;
@property (strong, nonatomic) IBOutlet UIButton *button5;
@property (strong, nonatomic) IBOutlet UIButton *button6;
@property (strong, nonatomic) IBOutlet UIButton *button7;
@property (strong, nonatomic) IBOutlet UIButton *button8;
@property (strong, nonatomic) IBOutlet UIButton *button9;
@property (strong, nonatomic) IBOutlet UIButton *button10;
@property (strong, nonatomic) IBOutlet UIButton *button11;
@property (strong, nonatomic) IBOutlet UIButton *button12;

@property (strong, nonatomic) IBOutlet UIButton *eyeButton;
@property (strong, nonatomic) IBOutlet UIButton *trashButton;

@property (strong, nonatomic) NSMutableArray *bottomButtons;
@property (strong, nonatomic) Question *currentQuestion;
@property (strong, nonatomic) UIView *lastImageHolderView;
@property (strong, nonatomic) UIAlertView *eyeButtonAlert;
@property (strong, nonatomic) UIAlertView *trashButtonAlert;
@property (strong, nonatomic) GADInterstitial *interstitialAd;
@property (strong, nonatomic) UIView *selectedImageView;
@property BOOL imageIsFullSized;
@property BOOL trashed;
@property CGRect lastRect;
@property int indexForLetterToBeAdded;
@property BOOL receivedAd;
@property int adCounter;


- (IBAction)letterPressed:(id)sender;
- (IBAction)eyeButtonPressed:(id)sender;
- (IBAction)trashButtonPressed:(id)sender;



@end
