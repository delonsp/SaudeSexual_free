//
//  DRSQuestTableViewController1_iPad.h
//  SaudeSexual
//
//  Created by Alain Dutra on 23/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestTableViewController1_iPhone.h"
#import "DRSQuestTableViewController2_iPad.h"
#import "DRSQuestIntroViewController_iPad.h"
#import "DRSAppDelegate.h"
#import "LocalyticsSession.h"

@interface DRSQuestTableViewController1_iPad : DRSQuestTableViewController1_iPhone {
    DRSQuestIntroViewController_iPad *dvc;
}

@property (strong, nonatomic) DRSQuestIntroViewController_iPad *dvc;
-(void) detail;
@end
