//
//  DRSPontTableViewController_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 07/05/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSPontTableViewController_iPhone.h"
#import "DRSPontTableViewController2_iPhone.h"
#import "DRSBarGraphViewController.h"

@interface DRSPontTableViewController_iPhone ()


@end

@implementation DRSPontTableViewController_iPhone
@synthesize myArray, item,  rootItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSBundle *bundle = [NSBundle mainBundle];
    if (self.myArray == nil) {
        NSString *path = [bundle pathForResource:@"Nomes Questionários 2" ofType:@"plist"];
        NSArray *array =[[NSArray alloc] initWithContentsOfFile:path];
        self.myArray = array;
    }
    if (rootItems == nil) {
        NSString *path = [bundle pathForResource:@"productsID Dictionary 2" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        self.rootItems = dict;
        
//        self.questArray = [[self.rootItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
    }

    
    UIImageView *tableHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [tableHeaderView setBackgroundColor:[UIColor clearColor]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 310, 80)];
    headerLabel.text = @"Clique em uma das células para ver resultados anteriores";
    headerLabel.numberOfLines = 3;
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:20];
    headerLabel.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:headerLabel];
    [self.tableView setTableHeaderView:tableHeaderView];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [tableBackgroundView setFrame:self.tableView.frame];
    [self.tableView setBackgroundView:tableBackgroundView];
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Banco de Dados";
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.rootItems=nil; self.item = nil, self.myArray=nil; //self.questArray=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.item = [myArray objectAtIndex:indexPath.row];
    
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
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detailViewController;
    NSString *quest;
    
    
    if (indexPath.row == 0) {
        detailViewController = [[DRSPontTableViewController2_iPhone alloc] initWithNibName:@"DRSPontTableViewController2_iPhone" bundle:nil];
    } else {
        NSInteger number = indexPath.row;
        NSNumber *number2 = [[NSNumber alloc] initWithInt:number];
        NSString *stringNumber = [number2 stringValue];
        quest = [self.rootItems objectForKey:stringNumber];
        NSLog(@"quest = %@",quest);
        
        detailViewController = [[DRSBarGraphViewController alloc] initWithNibName:@"DRSBarGraphViewController" bundle:nil];
       
    }
    
    if ([detailViewController respondsToSelector:@selector(setGraphName:)])
        [detailViewController setValue:quest forKey:@"graphName"];
        
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

@end
