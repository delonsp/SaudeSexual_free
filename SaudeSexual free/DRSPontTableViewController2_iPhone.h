//
//  DRSPontTableViewController2_iPhone.h
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 07/05/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"

@interface DRSPontTableViewController2_iPhone : UITableViewController {
    AppModel *model;
}
@property (copy) NSDate *data;
@property (copy) NSString *questName;
@property (assign, nonatomic) NSUInteger number;

@end
