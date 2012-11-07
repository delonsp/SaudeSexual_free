//
//  DRSQuestIntroViewController_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 05/05/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestIntroViewController_iPhone.h"
#import "DRSQuestTableViewController2_iPhone.h"

@interface DRSQuestIntroViewController_iPhone () {
  
    
}

@end

@implementation DRSQuestIntroViewController_iPhone


@synthesize textView;
@synthesize key;
@synthesize product;
@synthesize dict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void) viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"noMoreAlertsForQuest"] == FALSE)
        if ([self.key isEqualToString:IPE] || [self.key isEqualToString:QEQ] || [self.key isEqualToString:SEAR] || [self.key isEqualToString:SQoLM]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ATENÇÃO"
                                                            message:@"Este é um questionário quantitativo, portanto a nota não será atribuída a um grau específico de intensidade de doença. Para mais detalhes veja 'Sobre os Questionários'"
                                                           delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:@"Mostrar novamente", @"Não mostrar novamente esta mensagem", nil];
            
            [alert show];
        }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyButton:) name:IAPHelperProductPurchasedNotification object:nil];
     self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 2) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"noMoreAlertsForQuest"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter
     setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter
     setNumberStyle:NSNumberFormatterCurrencyStyle];
       
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Intro Questionários" ofType:@"plist"];
    if (!self.dict) self.dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *array = [[NSArray alloc] init ];
    __block NSString *str2 = [[NSString alloc] init];
    str2 = @"ATENÇÃO: OS RESULTADOS DOS QUESTIONÁRIOS NÃO SÃO EM NENHUM MOMENTO ENVIADOS PARA FONTES EXTERNAS ATRAVÉS DE UPLOAD OU OUTRAS FORMAS DE TRANSMISSÃO DE DADOS. ELE FICA SOMENTE ARMAZENADO NO SEU DISPOSITIVO. CASO ACHE INTERESSANTE QUE VERSÃO FUTURA DESTE APLICATIVO ENVIE EMAIL PARA O SEU MÉDICO COM OS RESULTADOS, FAVOR ENVIAR SUA OPINIÃO PARA contato@drsolution.org\n\n";
    
    if (self.key) {
        
        array = [self.dict objectForKey:self.key];
        
        [array enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
            
            str2 = [str2 stringByAppendingString:str];
            str2 = [str2 stringByAppendingString:@"\n\n"];
            
            
        }];
        
    }
    
    
    self.textView.text = str2;
   
    self.textView.font = [UIFont fontWithName:@"TrebuchetMS" size:18.0];
    
    
    
    [self buyButton:nil];

}

-(void) viewWillDisappear:(BOOL)animated {
      [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) buyButton:(NSNotification *)notification  {
    
    NSLog(@"self.key = %@",self.key);
        
    if (self.product) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:self.product.productIdentifier] &&
            !([self.key isEqualToString:@"all"])) {
            self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"Prosseguir"
                                             style:UIBarButtonItemStyleBordered target:self
                                            action:@selector(goToQuest:)];
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];

        } else if (![[NSUserDefaults standardUserDefaults] boolForKey:self.product.productIdentifier]) {
            self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"Comprar"
                                             style:UIBarButtonItemStyleBordered target:self
                                            action:@selector(buyTapped:)];
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
           
        } else {
           
        }
        
    } else if ([self.key isEqualToString:@"OVP"]) {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Prosseguir"
                                         style:UIBarButtonItemStyleBordered target:self
                                        action:@selector(goToQuest:)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
        
    
    } else if ([self.key isEqualToString:@"Sobre os Questionários"]) {
    
         self.navigationItem.rightBarButtonItem = nil;    

    } else {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Sem conexão"
                                         style:UIBarButtonItemStyleBordered target:self
                                        action:nil];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];

    }

}

- (void)buyTapped:(id)sender {
    NSLog(@"Buy tapped!");
    [[DRSSaudeSexualIAPHelper sharedInstance] buyProduct:self.product];
}

-(void) goToQuest: (id) sender {
    NSLog(@"quest = %@", self.key);
    if (self.key) {
        DRSQuestTableViewController2_iPhone *detailViewController = [[DRSQuestTableViewController2_iPhone alloc] initWithNibName:@"DRSQuestTableViewController2_iPhone" bundle:nil];
        if ([detailViewController respondsToSelector:@selector(setQuest:)])
            [detailViewController setValue:self.key forKey:@"quest"];
        if (!([self.key isEqualToString:@"all"]))  [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}

- (void)viewDidUnload
{
           
    [self setProduct:nil];
    [self setKey:nil];
    [self setTextView:nil];
    [self setDict:nil];
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
