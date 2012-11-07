//
//  DRSTextTableViewController3_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 11/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSTextTableViewController3_iPad.h"
#import "DETableViewCell.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "DEPictureTableViewCell.h"
#import "DRSPictureViewController_iPad.h"

@interface DRSTextTableViewController3_iPad ()
@property (strong, nonatomic) UILabel *headerLabel;
@end

@implementation DRSTextTableViewController3_iPad


#define kTextTableViewCell @"TextTableViewCell"
#define kPictureTableViewCell @"PictureTableViewCell"
#define kPictureTag @"FIGURA"
#define kIntroTag @"$$DrSolution - Soluções em Aplicativos para Saúde$$"

@synthesize item, rootItems, itemsArray, arrayOfTags, picturesArray, picturesDictionary, topic, subject;
@synthesize tableView, myToolbar;
@synthesize headerLabel;

#pragma mark - DRSAttributedTable protocol methods

-(CGFloat) defineFontSize {
    return 16.0f;
}

-(CGFloat) defineHeightForRowWithCellContentWidth: (CGFloat) cellContentWidth
                                        andString: (NSString *) string {
    CGFloat cellContentMargin = 10.0f;
    CGSize constraint = CGSizeMake(cellContentWidth - (cellContentMargin * 2), 20000.0f);
    CGFloat fontSize = [self defineFontSize];
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (cellContentMargin * 2);
}

- (CGRect) defineFrameWithCellContentWidth: (CGFloat) cellContentWidth
                                 andString: (NSString *) string {
    CGFloat cellContentMargin = 10.0f;
    CGFloat fontSize = [self defineFontSize];
    CGSize constraint = CGSizeMake(cellContentWidth - (cellContentMargin* 2), 20000.0f);
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = CGRectMake(cellContentMargin, cellContentMargin, cellContentWidth - (cellContentMargin * 2), MAX(size.height, 44.0f));
    return frame;
}



-(void) updateDetailViewWithThisSubject:(NSString *)suBject andThisTopic:(NSString *)toPic {
    if (![[self.view.subviews lastObject] isKindOfClass: [UITableView class]]) {
        [[self.view.subviews lastObject] removeFromSuperview];
    }
    self.subject = suBject;
    self.topic = toPic;
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"noMoreAlertsForHomo"] == FALSE)
        if ([self.subject isEqualToString:HOMO]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ATENÇÃO"
                                                            message:@"Este texto contém referências por vezes explícitas a respeito de práticas homossexuais. Se não se sentir a vontade com estes temas por favor não leia esta Seção"
                                                           delegate:self cancelButtonTitle:@"Bloquear este conteúdo"
                                                  otherButtonTitles:@"Não bloquear", @"Não mostrar novamente esta mensagem", nil];
            
            [alert show];
            UIView *aView = [[UIView alloc] initWithFrame:self.tableView.frame];
            aView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:aView];
        }
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"noMoreAlertsForDST"] == FALSE)
         if ([self.subject isEqualToString:DST]) {
             UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Atenção"
                                                             message:@"Este texto contém imagens fortes de pessoas doentes."
                                                            delegate:self cancelButtonTitle:@"OK"
                                                   otherButtonTitles:@"Mostrar novamente", @"Não mostrar novamente esta mensagem", nil];
             [alert2 show];
             
         }
             
    NSString *path = [[NSBundle mainBundle] pathForResource:self.subject ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.rootItems = dict;
    NSArray *array = [[NSArray alloc] init];
    array = [self.rootItems objectForKey:self.topic];
    self.itemsArray = array;
    path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@ Pictures Dictionary",self.subject] ofType:@"plist"];
    dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.picturesDictionary = dict;
    array =  [self.picturesDictionary objectForKey:self.topic];
    self.picturesArray = array;
    self.arrayOfTags = [[NSMutableArray alloc] initWithCapacity:self.picturesArray.count];
    
    for (int i=1; i<=self.picturesArray.count; i++) {
        NSString *str = [NSString stringWithFormat:@"FIGURA %i", i];
        [self.arrayOfTags addObject:str];
    }
    headerLabel.text = self.topic;
    [headerLabel sizeToFit];
    [tableView reloadData];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]  atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   
    if ([alertView.title isEqualToString:@"ATENÇÃO"] && buttonIndex == 1) {
        [[self.view.subviews lastObject] removeFromSuperview];
    } else if ([alertView.title isEqualToString:@"ATENÇÃO"] && buttonIndex == 2) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"noMoreAlertsForHomo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if (![alertView.title isEqualToString:@"ATENÇÃO"] && buttonIndex == 2) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"noMoreAlertsForDST"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor 
                                                         colorWithRed:0.31 green:0.52 blue:0.74 alpha:1];                                                         
    self.headerLabel = (UILabel *)self.navigationItem.titleView;
    if (!headerLabel) {
        headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:30.0];
        headerLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        headerLabel.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = headerLabel;
        
    }
    if (self.topic) {
        headerLabel.text = self.topic;
    } else {
        headerLabel.text = @"Textos";
    }
    
    [headerLabel sizeToFit];
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Voltar"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
     
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setHidesBackButton:YES];
    
    if (self.subject == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sexual intro" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        self.itemsArray = array;
        headerLabel.text = @"Informações importantes";
        
    }
}


- (void)viewDidUnload
{
    [super viewDidUnload];
     item = nil, rootItems = nil, itemsArray = nil, arrayOfTags = nil, picturesArray = nil, picturesDictionary = nil, topic = nil, subject = nil ;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count]-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row]+1;
    self.item = [self.itemsArray objectAtIndex:row];
    NSString *CellIdentifier;
    float font_size = [self defineFontSize];
    
    
    if ([self.item rangeOfString:kPictureTag].location == NSNotFound &&
        [self.item rangeOfString:kIntroTag].location == NSNotFound){
        CellIdentifier = kTextTableViewCell;
        DETableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DETableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.label.lineBreakMode = UILineBreakModeWordWrap;
        cell.label.minimumFontSize = font_size;
        cell.label.font = [UIFont systemFontOfSize:font_size];
        
        NSMutableAttributedString* attrItem = [NSMutableAttributedString attributedStringWithStringModifiedByTokens:item];
        
        cell.label.backgroundColor = [UIColor whiteColor];
        
        
        cell.label.attributedText = attrItem;
        
        cell.label.frame = [self defineFrameWithCellContentWidth:700.0f andString:self.item];
        
        return cell;
        
    } else {
        CellIdentifier = kPictureTableViewCell;
        UINib *nib = [UINib nibWithNibName:@"DEPictureTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        
        DEPictureTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DEPictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UIImage *image;
        BOOL flag = YES;
        
        if (!([self.item rangeOfString:kIntroTag].location == NSNotFound)) {
            image = [UIImage imageNamed:@"drsolution.png"];
            flag = NO;
        } else {
            for (NSString *str in self.arrayOfTags) {
                if (!([self.item rangeOfString:str].location == NSNotFound)) {
                    NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                    int value = [[str stringByTrimmingCharactersInSet:nonDigits] intValue];
                    
                    image = [UIImage imageNamed:[self.picturesArray objectAtIndex:value-1]];
                }
            }

        }
                  
        cell.picture.image = image; 
        
        cell.label.minimumFontSize = font_size;
        cell.label.font = [UIFont systemFontOfSize:font_size];
        NSMutableAttributedString* attrItem = [NSMutableAttributedString attributedStringWithStringModifiedByTokens:item];
        cell.label.attributedText = attrItem;
        if (flag) cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView: (UITableView*)tableView 
  willDisplayCell: (UITableViewCell*)cell 
forRowAtIndexPath: (NSIndexPath*)indexPath {
    cell.backgroundView = nil;
}




-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = [indexPath row]+1;
    self.item = [self.itemsArray objectAtIndex:row];
   
        
    if ([self.item rangeOfString:kPictureTag].location == NSNotFound &&
           [self.item rangeOfString:kIntroTag].location == NSNotFound) {
        
        return [self defineHeightForRowWithCellContentWidth:700.0f andString:self.item];
        
    }
    return 140;
}

-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row]+1;
    self.item = [self.itemsArray objectAtIndex:row];
    if ([self.item rangeOfString:kPictureTag].location == NSNotFound) {
        return nil;
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row]+1;
    NSString *temp = [self.itemsArray objectAtIndex:row];
    NSString *temp2;
    for (NSString *str in self.arrayOfTags) {
        if (!([temp rangeOfString:str].location == NSNotFound)) {
            NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            int value = [[str stringByTrimmingCharactersInSet:nonDigits] intValue];
            
            temp2 = [self.picturesArray objectAtIndex:value-1];
        }
    }
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:SELECTED_PICTURE_IN_IPAD];
    DRSPictureViewController_iPad* vc = [[DRSPictureViewController_iPad alloc] initWithNibName:@"DRSPictureViewController_iPhone" bundle:nil];
    vc.image = temp2;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
