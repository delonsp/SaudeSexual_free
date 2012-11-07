//
//  DRSBarResultViewController.m
//  SaudeSexual
//
//  Created by Alain Dutra on 01/07/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSBarResultViewController.h"
#import "DRSAppDelegate.h"
enum {
    kEDITS,
    kHSDD,
    kIIEF,
    kIPE,
    kOVP,
    kQEQ,
    kSEAR,
    kSQOL
};



@interface DRSBarResultViewController ()

-(void) configureAnswers;

@end

@implementation DRSBarResultViewController
@synthesize result;

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
    self.navigationItem.title = @"Resultado";
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    axisSet.xAxis.title = @"Data";
    self.hostView.hostedGraph.title = self.graphName;
    self.navigationItem.backBarButtonItem.title = @"Questionários";
    if (!self.result) {
        self.result = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
        self.result.layer.cornerRadius = 8;
        self.result.backgroundColor = [UIColor colorWithRed:0.26 green:0.47 blue:0.72 alpha:0.7];
        self.result.font = [UIFont systemFontOfSize:16];
        self.result.textColor = [UIColor whiteColor];
        self.result.numberOfLines = 4;
       
        [self.view addSubview:self.result];
    }
    
    [self configureAnswers];
    
    DRSAppDelegate *appDeleg = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
    [appDeleg disableLeftBarButtonItemOnNavbar:NO];
    
    // change the back button to cancel and add an event handler
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Questionários"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(handleBack:)];
    
    self.navigationItem.leftBarButtonItem = backButton;

}

- (void) handleBack:(id)sender
{
    // pop to root view controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    model.questionnaire.pageOfQuestionnaire = 0;
    model.questionnaire.totalofPages = 0;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Questionários" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *array = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
    model.questionnaire.dictOptions = array;
    model.questionnaire.partialScore = [[NSMutableArray alloc] init];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) configureData {
    model = [AppModel sharedModel];
    [model getObjectsFromDataStore];
    if (self.graphName) {
        
        Quest *quest = [model.listOfAnswers lastObject];
        NSMutableArray *numbersArray = [[NSMutableArray alloc] initWithCapacity:1];
        NSMutableArray *datesArray = [[NSMutableArray alloc] initWithCapacity:1];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/YY"];
        [numbersArray addObject: [NSNumber numberWithInt:[quest.result integerValue]]];
        [datesArray addObject:[dateFormat stringFromDate:quest.data]];
            
        self.lastThreeResultsArray = numbersArray;
        self.lastThreeDatesArray = datesArray;
                
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        
        [dateFormat2 setTimeStyle:NSDateFormatterShortStyle];
    }
}


-(void) configureAnswers {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Resultados" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    NSString *str, *str2, *str3;
    NSUInteger num = [[self.lastThreeResultsArray lastObject] integerValue];
    NSUInteger number = [model.questionnaire.dictOptions indexOfObject:model.questionnaire.questionnaireName];
    NSDictionary *myDict;
    switch (number) {
        case kEDITS:
        case kIPE:
        case kQEQ:
        case kSEAR:
        case kSQOL:
            str3 = [NSString stringWithFormat:@"Em uma escala de 0 a 100 você fez %@ pontos.",
                    [[self.lastThreeResultsArray lastObject] stringValue]];
            
            self.result.text = str3;
            break;
        case kOVP:
            myDict = [array objectAtIndex:2];
            if (num > 10)
                str2 = [myDict objectForKey:@"organ"];
            else
                str2 = [myDict objectForKey:@"psico"];
            str = [NSString stringWithFormat:@"O resultado foi de %@ pontos. Isto significa %@",
                   [[self.lastThreeResultsArray lastObject] stringValue], str2];
            self.result.text = str;
            break;

                    
        case kIIEF:
            myDict = [array objectAtIndex:1];
            if (num <= 7) {
                str2 = [myDict objectForKey:@"severa"];
            } else if (num >= 8 && num <= 11){
                str2 = [myDict objectForKey:@"moderada"];
            } else if (num >=12 && num <= 16) {
                str2 = [myDict objectForKey:@"leve a moderada"];
            } else if (num >=17 && num <=21) {
                str2 = [myDict objectForKey:@"leve"];
            } else {
                str2 = [myDict objectForKey:@"ausência"];
            }
            str = [NSString stringWithFormat:@"O resultado foi de %@ pontos. Isto significa %@",
                   [[self.lastThreeResultsArray lastObject] stringValue], str2];
            self.result.text = str;
            break;
            
        case kHSDD:
            
            myDict = [array objectAtIndex:0];
            
            if (num <= 6) {
                str2 = [myDict objectForKey:@"normal"];
            } else {
                str2 = [myDict objectForKey:@"anormal"];
            }
            str = [NSString stringWithFormat:@"O resultado foi de %@ pontos. Isto significa %@",
                   [[self.lastThreeResultsArray lastObject] stringValue], str2];
            
            
            self.result.text = str;
            break;
    }
    
}


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return 1;
}


@end
