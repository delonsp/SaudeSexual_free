//
//  DRSQuestTableViewController2_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 23/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestTableViewController2_iPad.h"
#import "DRSBarResultViewController_iPad.h"
#import "DRSQuestTableViewController2_iPad.h"
#import "DRSAppDelegate.h"

@interface DRSQuestTableViewController2_iPad ()

@end

@implementation DRSQuestTableViewController2_iPad
@synthesize flag;
@synthesize lastIndexPath;
@synthesize questDict;
@synthesize quest;

//-(void) setArrayFromModel: (NSArray*) aArray {
//    _arrayFromModel = aArray;
//}
    
- (NSArray *) arrayFromModel {
    
    if(!_arrayFromModel) {
        _arrayFromModel = [[NSArray alloc] init];
        NSDictionary *dict = model.questionnaire.questionnaireDictionary;
        NSString *myKey = [model.questionnaire.questFromDict objectAtIndex:model.questionnaire.pageOfQuestionnaire];
        _arrayFromModel = [dict objectForKey:myKey];
    }
    
    return _arrayFromModel;
}

#pragma mark - Custom Methods



-(IBAction)goToNextQuestion:(id)sender {
    
    
    NSUInteger position = [self.lastIndexPath row]+1;
    
    NSUInteger point = [model.questionnaire setPointFromChoice:position];
    NSNumber *num = [NSNumber numberWithInt:point];
    
    [model.questionnaire.partialScore insertObject:num
                             atIndex:model.questionnaire.pageOfQuestionnaire];
    
    
    
    
    if (model.questionnaire.pageOfQuestionnaire == model.questionnaire.totalofPages-1 && self.flag == YES) {
        
        [self goToFinalResult];
        
    } else if (self.flag == NO) {
        [model.questionnaire.partialScore removeObjectAtIndex:model.questionnaire.pageOfQuestionnaire];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Marque uma opção"
                                                        message:@"Precisa marcar uma opção antes de continuar"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        model.questionnaire.pageOfQuestionnaire++;
        DRSQuestTableViewController2_iPad *childController = [[DRSQuestTableViewController2_iPad alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:childController animated:YES];
        DRSAppDelegate *appDeleg = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDeleg disableLeftBarButtonItemOnNavbar:YES];
    }
}

-(void) goToFinalResult {
    
    
    [model finalScore];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:CHOSE_TO_DO_QUESTIONNAIRE_IN_IPAD];
    DRSBarResultViewController_iPad *childController = [[DRSBarResultViewController_iPad alloc]
                                                   initWithNibName:@"DRSBarGraphViewController_iPad" bundle:nil];
    
    
    childController.graphName = model.questionnaire.questionnaireName;    
    
    [self.navigationController pushViewController:childController animated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    model = [AppModel sharedModel];
    
    if (self.quest) 
        model.questionnaire.questionnaireName = self.quest;
    if (model.questionnaire.pageOfQuestionnaire != 0) 
        [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title = model.questionnaire.questionnaireName;
    UIImageView *tableHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 620, 130)];
    
    [tableHeaderView setBackgroundColor:[UIColor 
                                         colorWithRed:0.31 green:0.52 blue:0.74 alpha:1]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 610, 120)];
    NSArray *array = self.arrayFromModel;
    headerLabel.text = [array objectAtIndex:0];
    headerLabel.numberOfLines = 6;
    headerLabel.textAlignment = UITextAlignmentLeft;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:18.0];
    headerLabel.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:headerLabel];
    [self.tableView setTableHeaderView:tableHeaderView];
    
    
    UIBarButtonItem *nextButton;
    
    if (model.questionnaire.pageOfQuestionnaire != model.questionnaire.totalofPages-1 ) {
        
        nextButton = [[UIBarButtonItem alloc]
                      initWithTitle:@"Próxima pergunta"
                      style:UIBarButtonItemStyleBordered
                      target:self
                      action:@selector(goToNextQuestion:)];
    } else {
        nextButton = [[UIBarButtonItem alloc]
                      initWithTitle:@"Resultado"
                      style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(goToNextQuestion:)];
    }
    
    self.navigationItem.rightBarButtonItem = nextButton;
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
//    if([[NSUserDefaults standardUserDefaults] boolForKey:@"noMoreAlertsForQuest"] == FALSE)
//        if ([self.quest isEqualToString:IPE] || [self.quest isEqualToString:QEQ] || [self.quest isEqualToString:SEAR] || [self.quest isEqualToString:SQoLM]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ATENÇÃO"
//                                                            message:@"Este é um questionário quantitativo, portanto a nota não será atribuída a um grau específico de intensidade de doença. Para mais detalhes veja 'Sobre os Questionários'"
//                                                           delegate:self cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:@"Mostrar novamente", @"Não mostrar novamente esta mensagem", nil];
//            
//            [alert show];
//        }
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        
    if (buttonIndex == 2) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"noMoreAlertsForQuest"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.quest = nil; self.questDict = nil; self.lastIndexPath = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
   return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self arrayFromModel] count]-1;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row +1;
    
    static NSString *CellIdentifier = @"Cell";
    NSString *item = [self.arrayFromModel objectAtIndex:row];
    
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger oldRow = [self.lastIndexPath row];
    cell.textLabel.text = item;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.numberOfLines = 4;
    cell.accessoryType = (row == oldRow && self.lastIndexPath != nil) ? 
    UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int newRow = [indexPath row];
    int oldRow = (self.lastIndexPath != nil) ? [self.lastIndexPath row] : -1;
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        self.lastIndexPath = indexPath ;
        
    }
    self.flag = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
