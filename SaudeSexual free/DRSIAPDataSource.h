//
//  DRSIAPDataSource.h
//  SaudeSexual free
//
//  Created by Alain Machado da Silva Dutra on 14/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRSIAPDataSource : NSObject {
    NSArray * _sectionsArray;
    NSArray * _itemsArray;
    NSDictionary *_rootItems;
    NSArray *_questArray;
    NSString *_item;
    NSArray *_DRSproductIdentifiers;
}

@property (strong, nonatomic) NSArray *sectionsArray;
@property (strong, nonatomic) NSArray *itemsArray;
@property (strong, nonatomic) NSDictionary *rootItems;
@property (strong, nonatomic) NSArray *questArray;
@property (copy, nonatomic) NSString *item;
@property(strong, nonatomic) NSArray * DRSproductIdentifiers;
@property (strong, nonatomic) NSDictionary *dictOfProductsIDs;


@end
