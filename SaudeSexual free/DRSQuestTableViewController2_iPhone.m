//
//  DRSQuestTableViewController2_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 23/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestTableViewController2_iPhone.h"
#import "DRSAppDelegate.h"
#import "DRSBarResultViewController.h"

@interface DRSQuestTableViewController2_iPhone ()

@end

@implementation DRSQuestTableViewController2_iPhone
@synthesize quest, questDict, flag, lastIndexPath;

#pragma mark - Custom Methods

- (NSArray *) returnMyArray {
    NSDictionary *dict = model.questionnaire.questionnaireDictionary;
   
    NSString *myKey = [model.questionnaire.questFromDict objectAtIndex:model.questionnaire.pageOfQuestionnaire];
    
    NSArray *array = [dict objectForKey:myKey];
    return array;
}

- (void) goToNextQuestion:(id)sender {
    
    
    NSUInteger position = [lastIndexPath row]+1;
    
    NSUInteger point = [model.questionnaire setPointFromChoice:position];
    NSNumber *num = [NSNumber numberWithInt:point];
    
    [model.questionnaire.partialScore insertObject:num
                                atIndex:model.questionnaire.pageOfQuestionnaire];
    
    
  
    
    if (model.questionnaire.pageOfQuestionnaire == model.questionnaire.totalofPages-1 && flag == YES) {
        
        [self goToFinalResult];
        
    } else if (flag == NO) {
        [model.questionnaire.partialScore removeObjectAtIndex:model.questionnaire.pageOfQuestionnaire];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Marque uma opção"
                                                        message:@"Precisa marcar uma opção antes de continuar"
                                                       delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        model.questionnaire.pageOfQuestionnaire++;
        DRSQuestTableViewController2_iPhone *childController = [[DRSQuestTableViewController2_iPhone alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:childController animated:YES];
        DRSAppDelegate *appDeleg = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
        [appDeleg disableLeftBarButtonItemOnNavbar:YES];
    }
}

-(IBAction)goToFinalResult {
    
   
    [model finalScore];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:CHOSE_TO_DO_QUESTIONNAIRE_IN_IPHONE];
    DRSBarResultViewController *childController = [[DRSBarResultViewController alloc]
                                                   initWithNibName:@"DRSBarGraphViewController" bundle:nil];

    
    childController.graphName = model.questionnaire.questionnaireName;    
   
    [self.navigationController pushViewController:childController animated:YES];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    model = [AppModel sharedModel];
    if (self.quest) 
        model.questionnaire.questionnaireName = self.quest;
    NSString *str = [NSString stringWithFormat:@"The questionnaire %@ was not unlocked for some reason",self.quest ];
    BOOL check = [model.questionnaire.questionnaireName isEqualToString:@"Not unlocked"];
    
    NSAssert(!(check), str);

    
    if (model.questionnaire.pageOfQuestionnaire != 0) 
        [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title = model.questionnaire.questionnaireName;
    UIImageView *tableHeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];

    [tableHeaderView setBackgroundColor:[UIColor 
                                         colorWithRed:0.31 green:0.52 blue:0.74 alpha:1]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 310, 120)];
    NSArray *array = [self returnMyArray];
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
//    if ([self.quest isEqualToString:IPE] || [self.quest isEqualToString:QEQ] || [self.quest isEqualToString:SEAR] || [self.quest isEqualToString:SQoLM]) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ATENÇÃO"
//                                                        message:@"Este é um questionário quantitativo, portanto a nota não será atribuída a um grau específico de intensidade de doença. Para mais detalhes veja 'Sobre os Questionários'"
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:@"Mostrar novamente", @"Não mostrar novamente esta mensagem", nil];
//        
//        [alert show];
//    }

}

//-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//        
//    if (buttonIndex == 2) {
//        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"noMoreAlertsForQuest"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    quest = nil; questDict = nil; lastIndexPath = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self returnMyArray] count]-1;
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row +1;
    NSArray *array = [self returnMyArray];
    static NSString *CellIdentifier = @"Cell";
    NSString *item = [array objectAtIndex:row];
    
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSUInteger oldRow = [lastIndexPath row];
    cell.textLabel.text = item;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.numberOfLines = 4;
    cell.accessoryType = (row == oldRow && lastIndexPath != nil) ? 
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
    int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
    if (newRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        lastIndexPath = indexPath ;
        
    }
    flag = YES;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
