//
//  DRSQuestTableViewController1_iPhone.h
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 23/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRSIAPDataSource.h"
#import "MBProgressHUD.h"
#import "DRSSaudeSexualIAPHelper.h"
#import "DRSStoreCell.h"
#import "Reachability.h"
#import "UIImage+iPhone5.h"

#define kNormalCell @"NormalCell"
#define kDRSStoreCell @"DRSStoreCell"

@interface DRSQuestTableViewController1_iPhone : UITableViewController {
     DRSIAPDataSource *_dataSource;
     MBProgressHUD *_hud;
     NSArray *_products;
     NSMutableArray *_productsFromItunes;
     NSNumberFormatter * _priceFormatter;
     BOOL _restoreTapped;
    
}

@property (strong, nonatomic) DRSIAPDataSource *dataSource;

- (void)productPurchased:(NSNotification *)notification;
- (void) loadProducts;
- (void) appWillEnterForegroundNotification: (NSNotification *) notification;
- (BOOL) checkConnection;
- (void) restoreTapped;
- (void) setProducts:(NSArray *)products;
- (BOOL) checkProductsinIndexPath: (NSIndexPath*) indexPath;
- (SKProduct *) returnCorrectProductinIndexPath: (NSIndexPath*) indexPath;


@end
