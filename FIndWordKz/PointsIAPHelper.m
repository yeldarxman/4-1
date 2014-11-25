//
//  PointsIAPHelper.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 03.08.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "PointsIAPHelper.h"

@implementation PointsIAPHelper

@synthesize delegate;

+ (PointsIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static PointsIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"4pics1word.500points",
                                      @"4pics1word.200points",
                                      @"4pics1word.1200points",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (void)buyProduct:(SKProduct *)product {
    [super buyProduct:product];
    if([delegate respondsToSelector:@selector(buyingPorduct)]){
        [delegate buyingPorduct];
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [super completeTransaction:transaction];
    if([delegate respondsToSelector:@selector(didBuyProduct)]){
        [delegate didBuyProduct];
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [super failedTransaction:transaction];
    if([delegate respondsToSelector:@selector(failedToBuyProduct)]){
        [delegate failedToBuyProduct];
    }
}

@end
