//
//  MainViewController.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 02.08.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "MainViewController.h"
#import "Question.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    [self loadQuestions];
    [self setPoints];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadQuestions {
    NSString *mainBundleFilePath = [[NSBundle mainBundle] pathForResource: @"questions" ofType: @"txt"];
    
    if (mainBundleFilePath) {
        NSError *error;
        NSString* fileContents = [NSString stringWithContentsOfFile:mainBundleFilePath encoding:NSUTF8StringEncoding error:&error];
        fileContents = [fileContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
        
        NSArray *lines = [fileContents componentsSeparatedByCharactersInSet:newlineCharSet];
        NSMutableArray * questions = [[NSMutableArray alloc] init];
        
        for(NSString *line in lines){
            NSArray *words = [line componentsSeparatedByString:@","];
            
            Question *q = [[Question alloc] init];
            q.word = [words objectAtIndex:0];
            NSString *imageString = [words objectAtIndex:1];
            
            q.imageString1 = [imageString stringByAppendingString:@"1.jpeg"];
            q.imageString2 = [imageString stringByAppendingString:@"2.jpeg"];
            q.imageString3 = [imageString stringByAppendingString:@"3.jpeg"];
            q.imageString4 = [imageString stringByAppendingString:@"4.jpeg"];
            
            UIImage *tempImage = [UIImage imageNamed:q.imageString1];
            if (!tempImage) {
                NSLog(@"IMAGE DOES NOT EXIST: %@", q.imageString1);
            }
            
            tempImage = [UIImage imageNamed:q.imageString2];
            if (!tempImage) {
                NSLog(@"IMAGE DOES NOT EXIST: %@", q.imageString2);
            }

            tempImage = [UIImage imageNamed:q.imageString3];
            if (!tempImage) {
                NSLog(@"IMAGE DOES NOT EXIST: %@", q.imageString3);
            }
            
            tempImage = [UIImage imageNamed:q.imageString4];
            if (!tempImage) {
                NSLog(@"IMAGE DOES NOT EXIST: %@", q.imageString4);
            }
            
            [questions addObject:q];
        }
        
        [Question setAllQuestions:questions];
        
    } else {
        NSLog(@"NO FILE");
    }
}

- (void) setPoints {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL pointsSet = [defaults boolForKey:@"pointsSet"];
    
    if(!pointsSet){
        [defaults setInteger:400 forKey:@"points"];
        [defaults setBool:YES forKey:@"pointsSet"];
    }
    
    [defaults synchronize];
}

@end

















