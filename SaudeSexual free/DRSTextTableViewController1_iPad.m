//
//  DRSTextTableViewController1_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 03/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSTextTableViewController1_iPad.h"

@interface DRSTextTableViewController1_iPad ()

@end

@implementation DRSTextTableViewController1_iPad
@synthesize dvc, item, text1, oldTag;



-(void) detail {
    DRSAppDelegate *appDelegate = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
    UISplitViewController *svc1 = [appDelegate.tabBarController.viewControllers objectAtIndex:0];
    UINavigationController *detail1 = [svc1.viewControllers objectAtIndex:1];
    self.dvc = [detail1.viewControllers objectAtIndex: 0];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
        titleView.text = @"Saúde Sexual Free";
        [titleView sizeToFit];
        
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:imgView];
        
    if (!self.dvc) {
        [self detail];
    }
    
    if (self.dvc.navigationController.viewControllers.count >1) {
        [self.dvc.navigationController popToRootViewControllerAnimated:YES];
                
    }
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Voltar"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                    action:nil];
            
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    oldTag = -1;

    
    if (self.text1 == nil) {
        self.text1 = [[TextLevel1 alloc] init];
    }
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
   }

- (void)viewDidUnload
{
    [super viewDidUnload];
    dvc=nil, item=nil, text1=nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return text1.sectionItems.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[text1.mutableArrayOfSectionRowsArrays objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    NSArray *array = [text1.mutableArrayOfSectionRowsArrays objectAtIndex:section];
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    self.item = [array objectAtIndex:row];
   
    
    cell.textLabel.text = self.item;
    cell.textLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:20];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView: (UITableView*)tableView 
  willDisplayCell: (UITableViewCell*)cell 
forRowAtIndexPath: (NSIndexPath*)indexPath {
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
}


#pragma mark - Table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,section, 300, 50)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag = section;
    button.frame = CGRectMake(5,section, 290, 40);
    UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal
                                             stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [button setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:12 topCapHeight:0];
    [button setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    
    [button addTarget:self 
               action:@selector(expandSection:)
     forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:22];
    
    [button setTitle:[text1.sectionItems objectAtIndex:section] forState:UIControlStateNormal];
    [headerView addSubview:button];
    return headerView;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

-(void) expandSection:(UIButton *) button {
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:EXPANDED_SECTION_IN_IPAD];
    
    NSInteger section = [text1.sectionItems indexOfObject:button.titleLabel.text];
 
    [self.tableView beginUpdates];
        
    if (text1.oldSection && oldTag != section) {
        
        //delete oldSection rows
        [text1 removeSection:[text1.oldSection intValue]];
        
        NSMutableArray *indexPathArrayA = [[NSMutableArray alloc] initWithCapacity:text1.oldSectionRowsCount];
        
        for (int i =0; i<text1.oldSectionRowsCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:[text1.oldSection intValue]];
            [indexPathArrayA insertObject:indexPath atIndex:i];
        }
        
     
        [self.tableView deleteRowsAtIndexPaths:indexPathArrayA withRowAnimation:UITableViewRowAnimationAutomatic];
    } 
    
    if (oldTag != section) {
        
        //add newSection rows
        
        int newRowsCount = [text1 insertSectionAndReturnsArrayCount:section];
        NSMutableArray *indexPathArrayB = [[NSMutableArray alloc] initWithCapacity:newRowsCount];
        for (int i =0; i<newRowsCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            [indexPathArrayB insertObject:indexPath atIndex:i];
        }
        
        [self.tableView insertRowsAtIndexPaths:indexPathArrayB withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    [self.tableView endUpdates];
    oldTag = section;
        
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:SELECTED_TOPIC_IN_IPAD];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    NSArray *array = [text1.arrayOfSectionRowsArrays objectAtIndex:section]; //subject
    NSString *subject = [array objectAtIndex:0];
    array = [text1.mutableArrayOfSectionRowsArrays objectAtIndex:section];
    NSString *topic = [array objectAtIndex:row]; //topic
   [self.dvc updateDetailViewWithThisSubject:subject andThisTopic:topic];

}

@end
