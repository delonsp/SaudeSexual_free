//
//  DRSQuestIntroViewController_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 24/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestIntroViewController_iPad.h"
#import "DRSQuestTableViewController2_iPad.h"

@interface DRSQuestIntroViewController_iPad ()
//@property (strong, nonatomic) NSDictionary *dict;
@property (strong, nonatomic) UILabel *titleView;

@end

@implementation DRSQuestIntroViewController_iPad
//@synthesize dict;
@synthesize titleView;



-(void) updateDetailViewWithThisContent:(NSString *)content andProduct:(SKProduct *)product {
    self.product = product;
    self.key = content;
    titleView.text = content;
    [titleView.text isEqualToString:@"Sobre os Questionários"] ? titleView.text = @"Introdução" : titleView;
    [titleView.text isEqualToString:@"all"] ? titleView.text = @"Todos os Questionários": titleView;
    
    NSArray *array = [[NSArray alloc] init];
    array = [self.dict objectForKey:self.key];
   
    __block NSString *str2 = [[NSString alloc] init];
    str2 = @"ATENÇÃO: OS RESULTADOS DOS QUESTIONÁRIOS NÃO SÃO EM NENHUM MOMENTO ENVIADOS PARA FONTES EXTERNAS ATRAVÉS DE UPLOAD OU OUTRAS FORMAS DE TRANSMISSÃO DE DADOS. ELE FICA SOMENTE ARMAZENADO NO SEU DISPOSITIVO. CASO ACHE INTERESSANTE QUE VERSÃO FUTURA DESTE APLICATIVO ENVIE EMAIL PARA O SEU MÉDICO COM OS RESULTADOS, FAVOR ENVIAR SUA OPINIÃO PARA contato@drsolution.org\n\n";

        
    array = [self.dict objectForKey:self.key];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        str2 = [str2 stringByAppendingString:obj];
        str2 = [str2 stringByAppendingString:@"\n\n"];
        
        
    }];
    [self.textView setText:str2];
    
    [self buyButton:nil];
    
        
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"noMoreAlertsForQuest"] == FALSE)
        if ([self.key isEqualToString:IPE] || [self.key isEqualToString:QEQ] || [self.key isEqualToString:SEAR] || [self.key isEqualToString:SQoLM]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ATENÇÃO"
                                                            message:@"Este é um questionário quantitativo, portanto a nota não será atribuída a um grau específico de intensidade de doença. Para mais detalhes veja 'Sobre os Questionários'"
                                                           delegate:self cancelButtonTitle:@"OK"
                                                  otherButtonTitles:@"Mostrar novamente", @"Não mostrar novamente esta mensagem", nil];
            
            [alert show];
        }


}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor 
                                                         colorWithRed:0.31 green:0.52 blue:0.74 alpha:1];                                                         
    self.titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:30.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
        titleView.text = @"Introdução";
        [titleView sizeToFit];
    }
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"Intro Questionários" ofType:@"plist"];
    self.dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    [self updateDetailViewWithThisContent:@"Sobre os Questionários" andProduct:nil];
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

-(void) buyButton:(NSNotification *)notification  {
    
       
    if (self.product && !([titleView.text isEqualToString:@"Introdução"])) {
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
            self.navigationItem.rightBarButtonItem = nil;
        }
        
    } else if ([self.key isEqualToString:@"OVP"]) {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Prosseguir"
                                         style:UIBarButtonItemStyleBordered target:self
                                        action:@selector(goToQuest:)];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];

    } else if ([titleView.text isEqualToString:@"Introdução"]) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"Sem conexão"
                                         style:UIBarButtonItemStyleBordered target:self
                                        action:nil];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor redColor];
    }
}


-(void) goToQuest: (id) sender {
    NSLog(@"%@",self.key);
    if (self.key) {
        DRSQuestTableViewController2_iPad *detailViewController = [[DRSQuestTableViewController2_iPad alloc] initWithNibName:@"DRSQuestTableViewController2_iPad" bundle:nil];
        if ([detailViewController respondsToSelector:@selector(setQuest:)])
            [detailViewController setValue:self.key forKey:@"quest"];
        NSLog(@"dvc.quest = %@", detailViewController.quest);
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}


@end
