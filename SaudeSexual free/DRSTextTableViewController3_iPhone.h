//
//  DRSTextTableViewController3_iPhone.h
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 16/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRSAttributedTableView.h"

@interface DRSTextTableViewController3_iPhone : UITableViewController<DRSAttributedTableView>

@property (strong, nonatomic) NSDictionary *picturesDictionary;
@property (strong, nonatomic) NSArray *picturesArray;
@property (strong, nonatomic) NSMutableArray *arrayOfTags;
@property (copy, nonatomic) NSString *topic;
@property (copy, nonatomic) NSString *subject;
@property (strong, nonatomic) NSDictionary *rootItems;
@property (strong, nonatomic) NSArray *itemsArray;
@property (copy, nonatomic) NSString *item;
@property (assign) CGFloat fontSize;

@end
