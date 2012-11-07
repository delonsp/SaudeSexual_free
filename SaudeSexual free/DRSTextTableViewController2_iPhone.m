//
//  DRSTextTableViewController1_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 15/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//


#import "DRSTextTableViewController2_iPhone.h"
#import "DRSTextTableViewController3_iPhone.h"

@implementation DRSTextTableViewController2_iPhone
@synthesize rootDict, rootItems, item, key;

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
    
    self.navigationItem.title = @"Seções";
    
    if (rootDict == nil) {
        NSString *path =[[NSBundle mainBundle] pathForResource:@"Text2" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        rootDict = dict;
    }
    
    if (rootItems == nil) {
        NSArray *array = [[NSArray alloc] init];
        array = [rootDict objectForKey:self.key];
        self.rootItems = array;
    }
    
    UIImageView *tableHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [tableHeaderView setBackgroundColor:[UIColor clearColor]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 25)];
    
    headerLabel.text = [self.rootItems objectAtIndex:0];
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:22.0];
    headerLabel.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:headerLabel];
    [self.tableView setTableHeaderView:tableHeaderView];

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
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:24.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        titleView.text = @"Seções";
        
        self.navigationItem.titleView = titleView;
    }
    
    [titleView sizeToFit];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:imgView];
    
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
    return [rootItems count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    int row = [indexPath row];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    self.item = [self.rootItems objectAtIndex:row+1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.item;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    return cell;
}


#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    int row = [indexPath row]+1;
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:SELECTED_TOPIC_IN_IPHONE];
    self.item = [self.rootItems objectAtIndex:row];
    DRSTextTableViewController3_iPhone *detailViewController = [[DRSTextTableViewController3_iPhone alloc] initWithNibName:@"DRSTextTableViewController3_iPhone" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    detailViewController.topic = self.item;
    detailViewController.subject = self.key;
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}


@end
