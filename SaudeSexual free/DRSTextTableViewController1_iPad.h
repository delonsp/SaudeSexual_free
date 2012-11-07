//
//  DRSTextTableViewController1_iPad.h
//  SaudeSexual
//
//  Created by Alain Dutra on 03/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRSTextTableViewController3_iPad.h"
#import "DRSAppDelegate.h"
#import "TextLevel1.h"
#import "LocalyticsSession.h"
#import "AppModel.h"

@interface DRSTextTableViewController1_iPad : UITableViewController
@property (strong, nonatomic) DRSTextTableViewController3_iPad *dvc;
@property (strong, nonatomic) TextLevel1 *text1;
@property (strong, nonatomic) NSString *item;
@property (assign, nonatomic) NSInteger oldTag;


-(void) detail;
-(void) expandSection: (UIButton * ) button;
@end
