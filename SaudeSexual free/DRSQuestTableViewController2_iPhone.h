//
//  DRSQuestTableViewController2_iPhone.h
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 23/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "LocalyticsSession.h"

@interface DRSQuestTableViewController2_iPhone : UITableViewController<UIAlertViewDelegate> {
    AppModel *model;
}
@property (copy, nonatomic) NSString *quest;
@property (strong, nonatomic) NSDictionary *questDict;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (nonatomic) BOOL flag;

-(NSArray *) returnMyArray;

@end
