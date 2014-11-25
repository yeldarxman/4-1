//
//  GameViewController.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 26.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "GameViewController.h"
#import "LettersGenerator.h"

#define SHOW_LETTER_POINTS 60
#define TRASH_LETTERS_POINTS 100
#define MY_INTERSTITIAL_UNIT_ID @"ca-app-pub-4571309167331364/6470666333"

@interface GameViewController ()

@end

@implementation GameViewController
@synthesize image1;
@synthesize image2;
@synthesize image3;
@synthesize image4;
@synthesize wordLetterButtons;
@synthesize indexForLetterToBeAdded;
@synthesize currentQuestion;
@synthesize bottomButtons;
@synthesize eyeButtonAlert;
@synthesize trashButtonAlert;
@synthesize trashed;
@synthesize interstitialAd;
@synthesize receivedAd;
@synthesize adCounter;
@synthesize selectedImageView;

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
    // Создание представления стандартного размера вверху экрана.
    // Доступные константы AdSize см. в GADAdSize.h.
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    
    // Указание идентификатора рекламного блока.
    bannerView_.adUnitID = @"ca-app-pub-4571309167331364/5935832330";
    
    // Укажите, какой UIViewController необходимо восстановить
    // после перехода пользователя по объявлению и добавить в иерархию представлений.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    [self loadFromUserDefaults];
    [self configureViews];
}

- (void) viewWillAppear:(BOOL)animated{
    // Инициирование общего запроса на загрузку с объявлением.
    [bannerView_ loadRequest:[GADRequest request]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureViews {
    [self configureImages];
    [self updateLevelAndPointsLabels];
}

- (void) configureImages {
    [image1.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [image1.layer setBorderWidth: 2.0];
    [image2.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [image2.layer setBorderWidth: 2.0];
    [image3.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [image3.layer setBorderWidth: 2.0];
    [image4.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [image4.layer setBorderWidth: 2.0];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    UILongPressGestureRecognizer *longPress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    UILongPressGestureRecognizer *longPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    UILongPressGestureRecognizer *longPress3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    
    [self.image1 setUserInteractionEnabled:YES];
    [self.image1 addGestureRecognizer:longPress];
    
    [self.image2 setUserInteractionEnabled:YES];
    [self.image2 addGestureRecognizer:longPress1];
    
    [self.image3 setUserInteractionEnabled:YES];
    [self.image3 addGestureRecognizer:longPress2];
    
    [self.image4 setUserInteractionEnabled:YES];
    [self.image4 addGestureRecognizer:longPress3];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    
    [self.image1 setUserInteractionEnabled:YES];
    [self.image1 addGestureRecognizer:tapGesture];
    
    [self.image2 setUserInteractionEnabled:YES];
    [self.image2 addGestureRecognizer:tapGesture1];
    
    [self.image3 setUserInteractionEnabled:YES];
    [self.image3 addGestureRecognizer:tapGesture2];
    
    [self.image4 setUserInteractionEnabled:YES];
    [self.image4 addGestureRecognizer:tapGesture3];
}

- (void) updateLevelAndPointsLabels {
    [self updateLevelLabel];
    [self updatePointsLabel];
}

- (void) updateLevelLabel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger questionIndex = [defaults integerForKey:@"questionIndex"];
    [self.levelLabel setText:[NSString stringWithFormat:@"Деңгей: %i", (int)questionIndex + 1]];
}

- (void) updatePointsLabel {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger points = [defaults integerForKey:@"points"];
    [self.scoreButton setTitle:[NSString stringWithFormat:@"Ұпай: %i", (int)points] forState:UIControlStateNormal];
}

- (void) setCorrectImages {
    [self.image1 setImage:[UIImage imageNamed:currentQuestion.imageString1]];
    [self.image2 setImage:[UIImage imageNamed:currentQuestion.imageString2]];
    [self.image3 setImage:[UIImage imageNamed:currentQuestion.imageString3]];
    [self.image4 setImage:[UIImage imageNamed:currentQuestion.imageString4]];
}

- (void) configureWordLetterButtons: (NSString *) word {
    //remove buttons from the word buttons view holder
    for(UIView *view in self.wordButtonsHolder.subviews){
        [view removeFromSuperview];
    }
    
    for(WordButton *wordButton in wordLetterButtons) {
        [self wordButtonPressed:wordButton];
    }
    
    //clear the array of old buttons
    if(wordLetterButtons == nil){
        wordLetterButtons = [[NSMutableArray alloc] init];
    }
    [wordLetterButtons removeAllObjects];
    
    //configure the buttons holder
    [self.wordButtonsHolder setFrame:CGRectMake(self.wordButtonsHolder.frame.origin.x,
                                                self.wordButtonsHolder.frame.origin.y,
                                                word.length * (38 + 5) - 5,
                                                38)];
    [self.wordButtonsHolder setCenter:CGPointMake(self.view.frame.size.width/2,
                                                  self.wordButtonsHolder.center.y)];
    
    //add new buttons to the word buttons view holder
    for(int i=0; i<word.length; i++){
        WordButton *button = [[WordButton alloc] init];
        [button setDelegate:self];
        [wordLetterButtons addObject:button];
        [self.wordButtonsHolder addSubview:button];
        button.frame = CGRectMake(i*(38 + 5), 0, 38, 38);
    }
}

- (void) configureBottomButtons {
    
    if(bottomButtons == nil){
        bottomButtons = [[NSMutableArray alloc] init];
    
        [bottomButtons addObject:self.button1];
        [bottomButtons addObject:self.button2];
        [bottomButtons addObject:self.button3];
        [bottomButtons addObject:self.button4];
        [bottomButtons addObject:self.button5];
        [bottomButtons addObject:self.button6];
        [bottomButtons addObject:self.button7];
        [bottomButtons addObject:self.button8];
        [bottomButtons addObject:self.button9];
        [bottomButtons addObject:self.button10];
        [bottomButtons addObject:self.button11];
        [bottomButtons addObject:self.button12];
    }
    
    //generate letters
    NSMutableArray *lettersArray = [LettersGenerator generateLetters:currentQuestion.word];
    for(int i=0; i<lettersArray.count; i++){
        [[bottomButtons objectAtIndex:i] setTitle:[lettersArray objectAtIndex:i] forState:UIControlStateNormal];
        [[bottomButtons objectAtIndex:i] setAlpha:1.0];
    }
}


- (void) imageTapped:(UITapGestureRecognizer *)recognizer{
    [recognizer.view.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    [recognizer.view.layer setOpacity:0.5];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         [recognizer.view.layer setOpacity:1.0];
                     }
                     completion:^(BOOL finished){
                         [recognizer.view.layer setBackgroundColor:[UIColor clearColor].CGColor];
                     }];
    [self animateImageView:recognizer.view];    
}



- (void) imagePressed:(UIGestureRecognizer *)recognizer{
    switch (recognizer.state) {
        case 0:
        case 1: // object pressed
            [recognizer.view.layer setBackgroundColor:[UIColor whiteColor].CGColor];
            [recognizer.view.layer setOpacity:0.5];
        case 2:
            [recognizer.view.layer setBackgroundColor:[UIColor whiteColor].CGColor];
            [recognizer.view.layer setOpacity:0.5];
            break;
        case 3: // object released
            [recognizer.view.layer setOpacity:1.0];
            [self animateImageView:recognizer.view];
            break;
        default: // unknown tap
            break;
    }
}

- (void) animateImageView:(UIView*) view {
    selectedImageView = view;
    
    //resize the image
    CGRect destinationRect;
    if(self.imageIsFullSized){
        destinationRect = self.lastRect;
    } else {
        destinationRect = CGRectMake(0,
                                     0,
                                     self.imagesHolderView.frame.size.width,
                                     self.imagesHolderView.frame.size.height);
        self.lastRect = [view frame];
        [self.imagesHolderView bringSubviewToFront: view];
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [view setFrame:destinationRect];
                     }
                     completion:^(BOOL finished){
                         self.imageIsFullSized = !self.imageIsFullSized;
                         if(!self.imageIsFullSized){
                             selectedImageView = nil;
                         }
                     }];
}

- (IBAction)letterPressed:(id)sender {
    WordButton *wordButton = [self getAvailableWordButton];
    [self moveLetterButton:(UIButton *)sender toWordButton:wordButton correctLetter:NO];
}

- (IBAction)eyeButtonPressed:(id)sender {
    if(eyeButtonAlert == nil){
        eyeButtonAlert = [[UIAlertView alloc] initWithTitle:@"Әрiптi ашу" message:@"Бұл сөздегi бiр әрiптi ашу – 60 ұпай" delegate:self cancelButtonTitle:@"Болдырмау" otherButtonTitles:@"Ашу", nil];
    }
    
    [eyeButtonAlert show];
}

- (IBAction)trashButtonPressed:(id)sender {
    if(trashed) {
        [[[UIAlertView alloc] initWithTitle:@"Әрiптер жойылған" message:@"Бұл сөзге қатысы жоқ әрiптердiң барлығы жойылған!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
        return;
    }
    
    if(trashButtonAlert == nil){
        trashButtonAlert = [[UIAlertView alloc] initWithTitle:@"Әрiптердi жою" message:@"Бұл сөзге қатысы жоқ әрiптердi жою – 100 ұпай" delegate:self cancelButtonTitle:@"Болдырмау" otherButtonTitles:@"Жою", nil];
    }
    
    [trashButtonAlert show];
}

- (void) moveLetterButton:(UIButton *) button toWordButton:(WordButton *)wordButton correctLetter:(BOOL) correctLetter {
    
    //check if we have not reached the bounds
    if(wordButton == nil){
        return;
    }
    
    //assign the sender button to the word button
    wordButton.hasLetter = YES;
    wordButton.assignedButton = button;
    wordButton.assignedButtonCenter = button.center;
    
    CGPoint senderPoint = [self.bottomViewHolder convertPoint:button.center toView:self.view];
    CGPoint receiverPoint = [self.wordButtonsHolder convertPoint:wordButton.center toView:self.view];
    
    [self.view addSubview:button];
    [button setCenter:senderPoint];
    [self.view bringSubviewToFront:button];
    
    // animation using block code
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         button.center = receiverPoint;
                         
                         //basic animation
                         {
                             CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                             animation.fromValue = [NSNumber numberWithFloat:0.0f];
                             animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
                             animation.duration = 0.2;
                             animation.repeatCount = 1;
                             [button.layer addAnimation:animation forKey:@"SpinAnimation"];
                         }
                     }completion:^(BOOL finished){
                         [wordButton setTitle:[button titleForState:UIControlStateNormal] forState:UIControlStateNormal];
                         [button setAlpha:0.0];
                         
                         if(correctLetter){
                             [wordButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                             wordButton.hasCorrectLetter = correctLetter;
                         }
                         
                         [self checkCorrectness];
                     }];
}

- (void) wordButtonPressed: (WordButton *) button {
    if(button.assignedButton == nil || button.hasCorrectLetter){
        return;
    }
    
    //set empty title to the word button
    [button setTitle:@"" forState:UIControlStateNormal];
    button.hasLetter = NO;
    
    CGPoint receiverPoint = [self.bottomViewHolder convertPoint:button.assignedButtonCenter toView:self.view];
    
    // animation using block code
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         button.assignedButton.center = receiverPoint;
                         [button.assignedButton setAlpha:1.0];
                         
                         //basic animation
                         {
                             CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                             animation.fromValue = [NSNumber numberWithFloat:0.0f];
                             animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
                             animation.duration = 0.2;
                             animation.repeatCount = 1;
                             [button.assignedButton.layer addAnimation:animation forKey:@"SpinAnimation"];
                         }
                     }completion:^(BOOL finished){
                         [self.bottomViewHolder addSubview:button.assignedButton];
                         [button.assignedButton setCenter:button.assignedButtonCenter];
                         
                         [self checkCorrectness];
                     }];
}

- (void) checkCorrectness {
    NSString *tempWord = @"";
    
    for(WordButton *button in wordLetterButtons){
        if([button titleForState:UIControlStateNormal] == nil || [[button titleForState:UIControlStateNormal] isEqualToString:@""]){
            //stop the loop and make the letters white
            for(WordButton *wordButton in wordLetterButtons){
                if(![wordButton hasCorrectLetter]){
                    [wordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
            }
            return;
        }
        tempWord = [NSString stringWithFormat:@"%@%@", tempWord, [button titleForState:UIControlStateNormal]];
    }
    
    if(tempWord.length < currentQuestion.word.length){
        return;
    }
    
    if([tempWord caseInsensitiveCompare:currentQuestion.word] == NSOrderedSame){
        for(WordButton *button in wordLetterButtons){
            button.hasCorrectLetter = NO;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        [self performSegueWithIdentifier:@"correctAnswer" sender:self];
    } else {
        for(WordButton *wordButton in wordLetterButtons){
            if(![wordButton hasCorrectLetter]){
                [wordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}

- (WordButton *) getAvailableWordButton {
    for(WordButton *button in wordLetterButtons){
        if(!button.hasLetter && !button.hasCorrectLetter){
            return button;
        }
    }
    
    return nil;
}

- (void) loadQuestion:(NSInteger) index {
    
    if(index >  [[Question getAllQuestions] count] - 1){
        index = arc4random_uniform((int)[[Question getAllQuestions] count]);
        
        //save the index in the defaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger questionIndex = [defaults integerForKey:@"questionIndex"];
        questionIndex = [[Question getAllQuestions] count];
        [defaults setInteger:questionIndex forKey:@"questionIndex"];
        [defaults synchronize];
    }
    
    currentQuestion = [[Question getAllQuestions] objectAtIndex:index];
    
    [self setCorrectImages];
    [self configureWordLetterButtons:currentQuestion.word];
    [self configureBottomButtons];
    [self updateLevelAndPointsLabels];
    [self initInterstitialAd];
}

- (void) showLetter {
    [self makeWordButtonsPress:@selector(showLetterAndSave) fromObject:self];
}

- (void) showLetterUndexIndex: (int) index{
    NSString *letter = [[currentQuestion.word substringFromIndex:index] substringToIndex:1];
    
    for(UIButton *button in bottomButtons){
        if(button.alpha != 0){
            NSString *tempLetter = [button titleForState:UIControlStateNormal];
            if([tempLetter isEqualToString:letter]) {
                [self moveLetterButton:button toWordButton:[wordLetterButtons objectAtIndex:index] correctLetter:YES];
                break;
            }
        }
    }

}

- (void) makeWordButtonsPress:(SEL)callbackSelector fromObject:(id) object{
    for(WordButton *button in wordLetterButtons){
        if(!button.hasCorrectLetter){
            //set empty title to the word button
            [button setTitle:@"" forState:UIControlStateNormal];
            button.hasLetter = NO;
        }
    }
    
    // animation using block code
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         for(WordButton *button in wordLetterButtons){
                             if(!button.hasCorrectLetter){
                                 CGPoint receiverPoint = [self.bottomViewHolder convertPoint:button.assignedButtonCenter toView:self.view];
                                 button.assignedButton.center = receiverPoint;
                                 [button.assignedButton setAlpha:1.0];
                                 
                                 //basic animation
                                 {
                                     CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                                     animation.fromValue = [NSNumber numberWithFloat:0.0f];
                                     animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
                                     animation.duration = 0.2;
                                     animation.repeatCount = 1;
                                     [button.assignedButton.layer addAnimation:animation forKey:@"SpinAnimation"];
                                 }
                             }
                         }
                     }completion:^(BOOL finished){
                         for(WordButton *button in wordLetterButtons){
                             if(!button.hasCorrectLetter){
                                 [self.bottomViewHolder addSubview:button.assignedButton];
                                 [button.assignedButton setCenter:button.assignedButtonCenter];
                                 button.assignedButton = nil;
                             }
                         }
                         
                         if (callbackSelector != nil && object != nil)
                             if([object respondsToSelector:callbackSelector]){
                                #pragma clang diagnostic push
                                #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                                [object performSelector:callbackSelector];
                                #pragma clang diagnostic pop
                             }
                     }];
}

- (void) showLetterAndSave {
    //generate a random number
    int length = (int)currentQuestion.word.length;
    int random = arc4random_uniform(length);
    
    while([[wordLetterButtons objectAtIndex:random] hasCorrectLetter]){
        random = arc4random_uniform(length);
    }
    
    [self showLetterUndexIndex:random];
    
    //save the index in the list of correct letter indices
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //correct indices
    NSString *correctIndices = (NSString *)[defaults objectForKey:@"correctIndices"];
    if(correctIndices == nil){
        correctIndices = @"";
    }
    correctIndices = [NSString stringWithFormat:@"%@%i",correctIndices, random];
    [defaults setObject:correctIndices forKey:@"correctIndices"];
    [defaults synchronize];
}

- (void) trashButtons {
    [self makeWordButtonsPress:@selector(trashButtonsAndSave) fromObject:self];
}

- (void) trashButtonsAndSave {
    NSString *tempWord = currentQuestion.word;
    
    for(UIButton *button in bottomButtons){
        NSString *letter = [button titleForState:UIControlStateNormal];
        
        NSRange rOriginal = [tempWord rangeOfString: letter];
        if (NSNotFound != rOriginal.location) {
            tempWord = [tempWord
                        stringByReplacingCharactersInRange: rOriginal
                                                withString: @""];
        } else {
            button.alpha = 0.0;
        }
    }
    
    //save the index in the list of correct letter indices
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    trashed = YES;
    [defaults setBool:YES forKey:@"buttonsTrashed"];
    [defaults synchronize];
}

#pragma mark - load questions from NSUserDefaults
- (void) loadFromUserDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *correctIndices = (NSString *)[defaults objectForKey:@"correctIndices"];
    
    if(correctIndices == nil){
        correctIndices = @"";
    }
    
    NSLog(@"Correct indices: %@", correctIndices);
    
    //load the right question
    NSInteger questionIndex = [defaults integerForKey:@"questionIndex"];
    [self loadQuestion:questionIndex];

    for (int i=0; i<correctIndices.length; i++){
        NSString *indexString = [[correctIndices substringFromIndex:i] substringToIndex:1];
        int index = [indexString intValue];
        [self showLetterUndexIndex:index];
    }
    
    BOOL buttonsTrashed = [defaults boolForKey:@"buttonsTrashed"];
    
    if (buttonsTrashed == YES) {
        [self trashButtons];
        trashed = YES;
    } else {
        trashed = NO;
    }
}

#pragma mark - WordButtonDelegate
- (void) didPressWordButton:(id)button {
    [self wordButtonPressed:(WordButton *)button];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if([alertView isEqual:eyeButtonAlert]){
        if(buttonIndex == 1){
            if([self checkPoints:SHOW_LETTER_POINTS]){
                [self showLetter];
                
                //points
                {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSInteger points = [defaults integerForKey:@"points"];
                    points = points - SHOW_LETTER_POINTS;
                    [defaults setInteger:points forKey:@"points"];
                    [defaults synchronize];
                }
                
                [self updatePointsLabel];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Жеткiлiксiз ұпай" message:@"Өкiнiшке орай сiздiң ұпай саныңыз жеткiлiксiз, қосымша ұпайды \"Ұпай\" мәзiрiнен сатып ала аласыз" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            }
        }
    } else if ([alertView isEqual:trashButtonAlert]){
        if(buttonIndex == 1){
            
            if([self checkPoints:TRASH_LETTERS_POINTS]){
                [self trashButtons];
                
                //points
                {
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    NSInteger points = [defaults integerForKey:@"points"];
                    points = points - TRASH_LETTERS_POINTS;
                    [defaults setInteger:points forKey:@"points"];
                    [defaults synchronize];
                }
                
                [self updatePointsLabel];
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"Жеткiлiксiз ұпай" message:@"Өкiнiшке орай сiздiң ұпай саныңыз жеткiлiксiз, қосымша ұпайды \"Ұпай\" мәзiрiнен сатып ала аласыз" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] show];
            }
        }
    }
}

#pragma mark - CorrectAnswerViewControllerDelegate
- (void) nextQuestion {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger questionIndex = [defaults integerForKey:@"questionIndex"];
    
    //load next question
    [self loadQuestion:questionIndex];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"correctAnswer"]){
        //set the correct label text
        CorrectAnswerViewController *target = [segue destinationViewController];
        target.correctWord = currentQuestion.word;
        target.interstitial = interstitialAd;
        target.adReceived = receivedAd;
        [target setDelegate:self];
        
        //change the ad flag to NO
        receivedAd = NO;
        
        //empty the correct letter indices and increment the index of the question to be loaded
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSInteger questionIndex = [defaults integerForKey:@"questionIndex"];
        questionIndex++;
        
        NSInteger points = [defaults integerForKey:@"points"];
        points = points + 4;
        
        [defaults setObject:@"" forKey:@"correctIndices"];
        [defaults setInteger:questionIndex forKey:@"questionIndex"];
        [defaults setInteger:points forKey:@"points"];
        [defaults setBool:NO forKey:@"buttonsTrashed"];
        trashed = NO;
        
        [defaults synchronize];
        
        //resize the selected image back to its original size
        if(selectedImageView != nil){
            NSLog(@"ImageView is selected");
            [self animateImageView:selectedImageView];
            selectedImageView = nil;
        }
        
    } else if([[segue identifier] isEqualToString:@"points"]) {
        PointsTableViewController *target = [[[segue destinationViewController] childViewControllers] objectAtIndex:0];
        target.delegate = self;
    }
}

- (BOOL) checkPoints:(NSInteger) aPoints {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger points = [defaults integerForKey:@"points"];

    return aPoints <= points;
}

#pragma mark - Interstitial Ad
- (void) initInterstitialAd {
    //load the ad
    interstitialAd = [[GADInterstitial alloc] init];
    interstitialAd.adUnitID = MY_INTERSTITIAL_UNIT_ID;
    interstitialAd.delegate = self;
    
    [interstitialAd loadRequest:[GADRequest request]];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)aInterstitial {
    adCounter++;
    if(adCounter % 2 == 0){
        receivedAd = YES;
    } else {
        interstitialAd = nil;
    }
    NSLog(@"Ad received!");
}

- (void) interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error{
    receivedAd = NO;
    interstitialAd = nil;
    NSLog(@"Ad error: %@",error);
}

#pragma mark points view controller delegate
- (void) didBuyPoints {
    [self updatePointsLabel];
}

@end









