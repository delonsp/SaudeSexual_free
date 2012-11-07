//
//  DRSPontTableViewController_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 29/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSPontTableViewController_iPad.h"
#import "DRSPontTableViewController2_iPad.h"
#import "DRSBarGraphViewController_iPad.h"
#import "DRSAppDelegate.h"


@interface DRSPontTableViewController_iPad ()
@property (nonatomic) DRSPontTableViewController2_iPad *dvc;
@end

@implementation DRSPontTableViewController_iPad
@synthesize dvc;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DRSAppDelegate *appDelegate = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
    UINavigationController *nvc = [appDelegate detailNavigationController];
    self.dvc = [nvc.viewControllers lastObject];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:CLICKED_ANTERIOR_RESULTS_IN_IPAD];
    UIImageView *tableHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 120)];
    [tableHeaderView setBackgroundColor:[UIColor clearColor]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 310, 110)];
    headerLabel.text = @"Clique em uma das células para ver comparações entre os últimos resultados de cada um dos questionários";
    headerLabel.numberOfLines = 4;
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:20];
    headerLabel.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:headerLabel];
    [self.tableView setTableHeaderView:tableHeaderView];
	
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myArray count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.item = [self.myArray objectAtIndex:indexPath.row+1];
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.frame = CGRectMake(0, 0, 320, 90);
    cell.textLabel.text = self.item;
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.numberOfLines = 4;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger number = indexPath.row+1;
    NSNumber *number2 = [[NSNumber alloc] initWithInt:number];
    NSString *stringNumber = [number2 stringValue];
    NSString *quest = [self.rootItems objectForKey:stringNumber];
    NSLog(@"quest = %@",quest);

    
    if ([self.dvc isKindOfClass:[DRSPontTableViewController2_iPad class]]) {
        DRSBarGraphViewController_iPad *vc = [[DRSBarGraphViewController_iPad alloc] initWithNibName:@"DRSBarGraphViewController_iPad" bundle:nil];
        DRSAppDelegate *appDelegate = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
        UINavigationController *nvc = [appDelegate detailNavigationController];
        [nvc pushViewController:vc animated:YES];
        self.dvc = [nvc.viewControllers lastObject];
               
    }
    if ([self.dvc respondsToSelector:@selector(setGraphName:)]) {
        
        [self.dvc updateDetailViewWithThisContent:quest];
         
    }
   
}



@end
