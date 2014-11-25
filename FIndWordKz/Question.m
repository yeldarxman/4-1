//
//  Question.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 29.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "Question.h"

@implementation Question

static NSMutableArray *allQuestions;

+ (NSMutableArray*) getAllQuestions {
    return allQuestions;
}

+ (void) setAllQuestions:(NSMutableArray *)questions {
    allQuestions = questions;
}

@end
