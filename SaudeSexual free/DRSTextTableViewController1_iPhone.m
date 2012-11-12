//
//  DRSTextTableViewController1_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 15/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSTextTableViewController1_iPhone.h"
#import "DRSTextTableViewController2_iPhone.h"


@implementation DRSTextTableViewController1_iPhone
@synthesize rootItems, item;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (rootItems == nil) {
        NSString *path =[[NSBundle mainBundle] pathForResource:@"Text1" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        rootItems = array;
    }
    
//    UIColor* bgColor = [UIColor colorWithPatternImage:[UIImage tallImageNamed:@"ipad-BG-pattern.png"]];
    UIColor *bgColor = [UIColor grayColor];
    [self.tableView setBackgroundColor:bgColor];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
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
        
    }
    titleView.text = @"Saúde Sexual Free";
    [titleView sizeToFit];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//    [self.tableView setBackgroundView:imgView];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [rootItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    int row = [indexPath row];
    
    self.item = [self.rootItems objectAtIndex:row];
    cell.textLabel.text = self.item;
    cell.textLabel.textColor = [UIColor whiteColor];

//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.backgroundColor = [UIColor clearColor];
    

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    int row = [indexPath row];
    self.item = [self.rootItems objectAtIndex:row];
    DRSTextTableViewController2_iPhone *detailViewController = [[DRSTextTableViewController2_iPhone alloc] initWithNibName:@"DRSTextTableViewController2_iPhone" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    detailViewController.key = self.item;
    [self.navigationController pushViewController:detailViewController animated:YES];
     
}


@end
