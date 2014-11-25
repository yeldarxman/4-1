//
//  IAPHelper.m
//  FIndWordKz
//
//  Created by Yeldar Merkaziyev on 03.08.14.
//  Copyright (c) 2014 Yeldar Merkaziyev. All rights reserved.
//

#import "IAPHelper.h"
@import StoreKit;

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {
    // You create an instance variable to store the SKProductsRequest you will issue to retrieve a list of products, while it is active.
    SKProductsRequest * _productsRequest;
    
    // You also keep track of the completion handler for the outstanding products request, ...
    RequestProductsCompletionHandler _completionHandler;
    
    // ... the list of product identifiers passed in, ...
    NSSet * _productIdentifiers;
    
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    self = [super init];
    
    if (self) {
        // Store product identifiers
        //        for (NSString * productIdentifier in _productIdentifiers) {
        //            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
        //            if (productPurchased) {
        //                [_purchasedProductIdentifiers addObject:productIdentifier];
        //                NSLog(@"Previously purchased: %@", productIdentifier);
        //            } else {
        //                NSLog(@"Not purchased: %@", productIdentifier);
        //            }
        //        }
        
        _productIdentifiers = productIdentifiers;
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    // a copy of the completion handler block inside the instance variable
    _completionHandler = [completionHandler copy];
    // Create a new instance of SKProductsRequest, which is the Apple-written class that contains the code to pull the info from iTunes Connect
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"Loaded products...");
    _productsRequest = nil;
    NSArray * skProducts = response.products;
    skProducts =  [skProducts sortedArrayUsingComparator: ^NSComparisonResult(SKProduct *p1, SKProduct *p2){
        return [p1.price compare:p2.price];
        
    }];
    
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ – Product: %@ – Price: %0.2f", skProduct.productIdentifier, skProduct.localizedTitle, skProduct.price.floatValue);
    }
    _completionHandler(YES, skProducts);
    _completionHandler = nil;
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Failed to load list of products."
                                                      message:nil
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    _completionHandler(NO, nil);
    _completionHandler = nil;
}

- (void)buyProduct:(SKProduct *)product
{
    NSLog(@"Buying %@...", product.productIdentifier);
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Bought successfully!"
//                                                      message:@"Thank you for your purchase. Enjoy!"
//                                                     delegate:nil
//                                            cancelButtonTitle:@"OK"
//                                            otherButtonTitles:nil];
//    [message show];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:transaction.payment.productIdentifier];
}

// called when a transaction has been restored and successfully completed
- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Restored successfully!"
                                                      message:@"Enjoy!"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

// called when a transaction has failed
- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Ups!"
//                                                          message:transaction.error.localizedDescription
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        [message show];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    NSLog(@"provideContentForProductIdentifier");
    
    NSInteger points = [[NSUserDefaults standardUserDefaults] integerForKey:@"points"];
    
    NSLog(@"IDENTIFIER: %@", productIdentifier);
    
    if ([productIdentifier rangeOfString:@"1200points"].location != NSNotFound) {
        points = points + 1200;
    } else if([productIdentifier rangeOfString:@"500points"].location != NSNotFound){
        points = points + 500;
    } else if([productIdentifier rangeOfString:@"200points"].location != NSNotFound) {
        points = points + 200;
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setInteger:points forKey:@"points"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
