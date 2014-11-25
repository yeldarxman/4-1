//
//  Letter.h
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 29.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Letter : NSObject

@property (strong, nonatomic) NSString *letter;
@property BOOL belongsToTheWord;

@end
