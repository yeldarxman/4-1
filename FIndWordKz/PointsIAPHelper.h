//
//  PointsIAPHelper.h
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 03.08.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "IAPHelper.h"

@protocol PointsIAPHelperDelegate <NSObject>

- (void) buyingPorduct;
- (void) didBuyProduct;
- (void) failedToBuyProduct;

@end

@interface PointsIAPHelper : IAPHelper

@property id<PointsIAPHelperDelegate> delegate;

+ (PointsIAPHelper *)sharedInstance;

@end
