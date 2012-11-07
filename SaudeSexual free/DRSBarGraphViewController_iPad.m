//
//  DRSBarGraphViewController_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 02/07/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSBarGraphViewController_iPad.h"

@interface DRSBarGraphViewController_iPad ()

@end

@implementation DRSBarGraphViewController_iPad


-(void)updateDetailViewWithThisContent:(NSString *)content {
    
    self.resultAnnotation = nil;
    self.lastThreeResultsArray = nil;
    self.lastThreeDatesArray = nil;
    self.graphName = content;
    [self initPlot];
    [self.view reloadInputViews];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:SELECTED_SPECIFIC_ANTERIOR_RESULT_IN_IPAD];
    [self.navigationItem setHidesBackButton:YES];

}




@end
