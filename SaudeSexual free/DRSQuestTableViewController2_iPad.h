//
//  DRSQuestTableViewController2_iPad.h
//  SaudeSexual
//
//  Created by Alain Dutra on 23/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestTableViewController2_iPhone.h"


@interface DRSQuestTableViewController2_iPad : UITableViewController<UIAlertViewDelegate> {
    AppModel *model;
    NSArray *_arrayFromModel;
}
@property (copy, nonatomic) NSString *quest;
@property (strong, nonatomic) NSDictionary *questDict;
@property (strong, nonatomic) NSIndexPath *lastIndexPath;
@property (nonatomic) BOOL flag;
@property (nonatomic, readonly) NSArray *arrayFromModel;




@end
