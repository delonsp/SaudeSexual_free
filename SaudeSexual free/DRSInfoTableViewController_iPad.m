//
//  DRSInfoTableViewController_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 23/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSInfoTableViewController_iPad.h"

@interface DRSInfoTableViewController_iPad ()

@end

@implementation DRSInfoTableViewController_iPad


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:CLICKED_INFO_TAB_IN_IPAD];
    self.cell_content_width = 950.0f;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
