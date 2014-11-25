//
//  LettersGenerator.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 29.07.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "LettersGenerator.h"
#import "Letter.h"

@implementation LettersGenerator

+ (NSMutableArray *) generateLetters: (NSString*) word {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for(int i=0; i<12; i++) {
        NSString *stringLetter = @"";
        
        if(i < word.length){
            stringLetter = [[word substringFromIndex:i] substringToIndex:1];
        } else {
            stringLetter = [LettersGenerator generateRandomLetter];
        }
        
        [array addObject:stringLetter];
    }
    
    array = [LettersGenerator shuffleArray:array];
    
    return array;
}

+ (NSString *) generateRandomLetter {
    NSString *lettersString = @"А,Ә,Б,В,Г,Ғ,Д,Е,Ё,Ж,З,И,Й,К,Қ,Л,М,Н,Ң,О,Ө,П,Р,С,Т,У,Ұ,Ү,Ф,Х,Һ,Ц,Ч,Ш,Щ,Ъ,Ы,I,Ь,Э,Ю,Я";
    NSArray *letters = [lettersString componentsSeparatedByString: @","];
    
    int random = arc4random_uniform((int)letters.count);
    return [letters objectAtIndex:random];
}

+ (NSMutableArray *) shuffleArray:( NSMutableArray *) array{
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((int)remainingCount);
        [array exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return array;
}

@end 
