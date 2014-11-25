//
//  Question.h
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 29.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSString *imageString1;
@property (strong, nonatomic) NSString *imageString2;
@property (strong, nonatomic) NSString *imageString3;
@property (strong, nonatomic) NSString *imageString4;

+ (NSMutableArray *) getAllQuestions;
+ (void) setAllQuestions: (NSMutableArray *) questions;

@end
