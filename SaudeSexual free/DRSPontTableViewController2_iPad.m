//
//  DRSPontTableViewController2_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 29/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSPontTableViewController2_iPad.h"

@interface DRSPontTableViewController2_iPad ()

@end

@implementation DRSPontTableViewController2_iPad

-(void)updateDetailViewWithThisContent:(NSString *)content {
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
       self.navigationController.navigationBar.tintColor = [UIColor 
                                                             colorWithRed:0.31 green:0.52 blue:0.74 alpha:1];                                                         
        UILabel *titleView = (UILabel *)self.navigationItem.titleView;
        if (!titleView) {
            titleView = [[UILabel alloc] initWithFrame:CGRectZero];
            titleView.backgroundColor = [UIColor clearColor];
            titleView.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:30.0];
            titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            
            titleView.textColor = [UIColor whiteColor]; // Change to desired color
            
            self.navigationItem.titleView = titleView;
            titleView.text = @"Resultados Anteriores";
            [titleView sizeToFit];
        }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
