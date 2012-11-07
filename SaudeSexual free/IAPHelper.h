//
//  IAPHelper.h
//  In App Rage iOS 6
//
//  Created by Alain Machado da Silva Dutra on 12/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler: (RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;
- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction;


@end
