//
//  DRSTextTableViewController3_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 16/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSTextTableViewController3_iPhone.h"
#import "DETableViewCell.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "DEPictureTableViewCell.h"
#import "DRSPictureViewController_iPhone.h"

@implementation DRSTextTableViewController3_iPhone


#define kTextTableViewCell @"TextTableViewCell"
#define kPictureTableViewCell @"PictureTableViewCell"
#define kPictureTag @"FIGURA"

@synthesize item, rootItems, itemsArray, arrayOfTags, picturesArray, picturesDictionary, topic, subject;
@synthesize fontSize;

#pragma mark - DRSAttributedTableView Protocol Methods



-(CGFloat) defineHeightForRowWithCellContentWidth: (CGFloat) cellContentWidth
                                        andString: (NSString *) string {
    CGFloat cellContentMargin = 10.0f;
    CGSize constraint = CGSizeMake(cellContentWidth - (cellContentMargin * 2), 20000.0f);
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (cellContentMargin * 2);
}

- (CGRect) defineFrameWithCellContentWidth: (CGFloat) cellContentWidth
                                 andString: (NSString *) string {
    CGFloat cellContentMargin = 10.0f;
    CGSize constraint = CGSizeMake(cellContentWidth - (cellContentMargin* 2), 20000.0f);
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGRect frame = CGRectMake(cellContentMargin, cellContentMargin, cellContentWidth - (cellContentMargin * 2), MAX(size.height, 44.0f));
    return frame;
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[self.view.subviews lastObject] isKindOfClass: [UITableView class]]) {
        [[self.view.subviews lastObject] removeFromSuperview];
    }
    
    self.fontSize = 16.0f;
    
    
    if (self.rootItems == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:self.subject ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        self.rootItems = dict;
    }
    
    
    if (self.itemsArray == nil) { 
        NSArray *array = [[NSArray alloc] init];
        array = [self.rootItems objectForKey:self.topic];
        self.itemsArray = array;
                        
    }
    
    if (self.picturesDictionary == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@ Pictures Dictionary",self.subject] ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        self.picturesDictionary = dict;
    }
    
    if (self.picturesArray == nil) {
        NSArray *array =  [self.picturesDictionary objectForKey:self.topic];
        self.picturesArray = array;
    }
    
    if (self.arrayOfTags == nil) {
        self.arrayOfTags = [[NSMutableArray alloc] initWithCapacity:self.picturesArray.count];
        
        for (int i=1; i<=self.picturesArray.count; i++) {
            NSString *str = [NSString stringWithFormat:@"FIGURA %i", i];
            [self.arrayOfTags addObject:str];
        }
    }
    
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
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"%@,%i",alertView.title, buttonIndex);
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

-(void) viewDidUnload {
    [super viewDidUnload];
    item = nil, rootItems = nil, itemsArray = nil, arrayOfTags = nil, picturesArray = nil, picturesDictionary = nil, topic = nil, subject = nil ;
}

-(void) viewWillAppear:(BOOL)animated   {
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:20.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        titleView.text = self.subject;
                
        self.navigationItem.titleView = titleView;
    }
   
    [titleView sizeToFit];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    self.item = [self.itemsArray objectAtIndex:row];
    NSString *CellIdentifier;
    
    fontSize = 16.0f;
    
    row == 0 ? fontSize = 20.0f : fontSize;
    
    if ([self.item rangeOfString:kPictureTag].location == NSNotFound) {
        CellIdentifier = kTextTableViewCell;
        DETableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DETableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.label.lineBreakMode = UILineBreakModeWordWrap;
        cell.label.minimumFontSize = fontSize;
        cell.label.font = [UIFont systemFontOfSize:fontSize];

        NSMutableAttributedString* attrItem = [NSMutableAttributedString attributedStringWithStringModifiedByTokens:item];
        
        if (row == 0) {
            [attrItem setFont:[UIFont fontWithName:@"Baskerville-BoldItalic" size:fontSize]];
            [attrItem setTextBold:YES range:NSMakeRange(0, [attrItem length])];
            [attrItem setTextColor:[UIColor whiteColor]];
            cell.label.backgroundColor = [UIColor clearColor];
            cell.label.textAlignment = UITextAlignmentCenter;
            
        } else {
            cell.label.backgroundColor = [UIColor whiteColor];
        }
        
        cell.label.attributedText = attrItem;
        
        cell.label.frame = [self defineFrameWithCellContentWidth:320.0f andString:self.item];        
        return cell;
        
    } else {
        CellIdentifier = kPictureTableViewCell;
        UINib *nib = [UINib nibWithNibName:@"DEPictureTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        
        DEPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DEPictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UIImage *image;
        
        for (NSString *str in self.arrayOfTags) {
            if (!([self.item rangeOfString:str].location == NSNotFound)) {
                NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
                int value = [[str stringByTrimmingCharactersInSet:nonDigits] intValue];
                
                image = [UIImage imageNamed:[self.picturesArray objectAtIndex:value-1]];
            }
        }
        
        
        cell.picture.image = image; 
        
        cell.label.minimumFontSize = fontSize;
        cell.label.font = [UIFont systemFontOfSize:fontSize];
        NSMutableAttributedString* attrItem = [NSMutableAttributedString attributedStringWithStringModifiedByTokens:item];
        cell.label.attributedText = attrItem;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
}

#pragma mark - Table view delegate

- (void)tableView: (UITableView*)tableView 
  willDisplayCell: (UITableViewCell*)cell 
forRowAtIndexPath: (NSIndexPath*)indexPath {
    if ([indexPath row] == 0 ) {
        cell.backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        cell.backgroundColor = [UIColor colorWithRed:0.31 green:0.52 blue:0.74 alpha:1];
        
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
       
        
    }
    else
        cell.backgroundView = nil;
}
    
    


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int row = [indexPath row];
    self.item = [self.itemsArray objectAtIndex:row];
    
    fontSize = 16.0f;
    
    if (row == 0) {
        fontSize = 20.0f;
    }
    
    
    if ([self.item rangeOfString:kPictureTag].location == NSNotFound) {
        return [self defineHeightForRowWithCellContentWidth:320.0f andString:self.item];
    }
    
    return 140;
}

-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = [indexPath row];
    self.item = [self.itemsArray objectAtIndex:row];
    if ([self.item rangeOfString:kPictureTag].location == NSNotFound) {
        return nil;
    }
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [indexPath row];
    NSString *temp = [self.itemsArray objectAtIndex:row];
    NSString *temp2;
    for (NSString *str in self.arrayOfTags) {
        if (!([temp rangeOfString:str].location == NSNotFound)) {
            NSCharacterSet* nonDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
            int value = [[str stringByTrimmingCharactersInSet:nonDigits] intValue];
            
            temp2 = [self.picturesArray objectAtIndex:value-1];
        }
    }
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:SELECTED_PICTURE_IN_IPHONE];
    DRSPictureViewController_iPhone* vc = [[DRSPictureViewController_iPhone alloc] initWithNibName:@"DRSPictureViewController_iPhone" bundle:nil];
    vc.image = temp2;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
