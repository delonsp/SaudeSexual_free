//
//  DRSTextTableViewController3_iPad.h
//  SaudeSexual
//
//  Created by Alain Dutra on 11/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRSTextTableViewController3_iPhone.h"
#import "DRSAppDelegate.h"
#import "AppModel.h"
#import "LocalyticsSession.h"


@interface DRSTextTableViewController3_iPad : UIViewController<UITableViewDataSource, UITableViewDelegate, DRSAttributedTableView, UIAlertViewDelegate>

@property (assign, nonatomic) IBOutlet UIToolbar *myToolbar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSDictionary *picturesDictionary;
@property (strong, nonatomic) NSArray *picturesArray;
@property (strong, nonatomic) NSMutableArray *arrayOfTags;
@property (copy, nonatomic) NSString *topic;
@property (copy, nonatomic) NSString *subject;
@property (strong, nonatomic) NSDictionary *rootItems;
@property (strong, nonatomic) NSArray *itemsArray;
@property (copy, nonatomic) NSString *item;

-(void) updateDetailViewWithThisSubject:(NSString *)suBject andThisTopic:(NSString *) toPic;

@end
