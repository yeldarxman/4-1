//
//  CorrectAnswerViewController.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 31.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "CorrectAnswerViewController.h"

@interface CorrectAnswerViewController ()

@end

@implementation CorrectAnswerViewController
@synthesize delegate;
@synthesize correctWord;
@synthesize interstitial;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.correctWordLabel setText:correctWord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    if(self.adReceived){
        [interstitial presentFromRootViewController:self];
    }
}

- (IBAction)nextQuestionButtonPressed:(id)sender {
    if([delegate respondsToSelector:@selector(nextQuestion)]){
        [delegate nextQuestion];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) interstitialDidDismissScreen:(GADInterstitial *)ad {
    ad = nil;
    interstitial = nil;
}



@end
