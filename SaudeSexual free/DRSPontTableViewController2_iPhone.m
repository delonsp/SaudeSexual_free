//
//  DRSPontTableViewController2_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 07/05/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSPontTableViewController2_iPhone.h"
#import "Quest.h"

@interface DRSPontTableViewController2_iPhone ()
@property (strong, nonatomic) NSDictionary *myDict;
@end

@implementation DRSPontTableViewController2_iPhone
@synthesize data,questName,number, myDict;

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
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:CLICKED_ANTERIOR_RESULTS_IN_IPHONE];
    model = [AppModel sharedModel];
    [model getObjectsFromDataStore];
    if (!self.myDict) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"Questionários" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        myDict = dict;
    }
    
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return model.listOfAnswers.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    int row = [indexPath row];
    Quest *quest = [model.listOfAnswers objectAtIndex:row];
    
    NSMutableString *text;
    self.data = quest.data;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/YYYY"];
    [dateFormat2 setTimeStyle:NSDateFormatterShortStyle];
    NSString *dataBr = [dateFormat stringFromDate:self.data];
    NSString *dataBr2 = [dateFormat2 stringFromDate:self.data];
    self.questName = quest.quest;
    self.number = [quest.result integerValue];
    
    NSString *str = [[myDict objectForKey:self.questName] objectAtIndex:0];
    NSString *str2 = [model.questionnaire getConclusionFromQuestName:self.questName withResult:self.number];
    text = [NSString stringWithFormat:@"No dia %@, no horário de %@ , você fez %u pontos no questionário: %@. %@", dataBr,
            dataBr2, number, str, str2];
    cell.textLabel.text = text;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
 
    cell.textLabel.numberOfLines= 6;
    
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
