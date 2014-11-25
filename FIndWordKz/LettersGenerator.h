//
//  LettersGenerator.h
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 29.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LettersGenerator : NSObject

+ (NSMutableArray *) generateLetters: (NSString*) word;

@end
