//
//  DRSInfoTableViewController_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 12/05/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSInfoTableViewController_iPhone.h"
#import "DETableViewCell.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "DEPictureTableViewCell.h"

#define FONT_SIZE 16.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
#define kTextTableViewCell @"TextTableViewCell"
#define kPictureTableViewCell @"PictureTableViewCell"

@interface DRSInfoTableViewController_iPhone ()

@end

@implementation DRSInfoTableViewController_iPhone
@synthesize item, itemsArray;
@synthesize cell_content_width;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated {
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:25.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        titleView.text = @"Informações Importantes";
        
        self.navigationItem.titleView = titleView;
    }
    [titleView sizeToFit];
    
   self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.31 green:0.52 blue:0.74 alpha:1]; 
    
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:CLICKED_INFO_TAB_IN_IPHONE];
    if (self.itemsArray == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sexual info" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        self.itemsArray = array;
        
    }
    self.cell_content_width = 320.0f;
    
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
    return self.itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float font_size = FONT_SIZE;
    int row = [indexPath row];
    self.item = [self.itemsArray objectAtIndex:row];
    NSString *CellIdentifier;
    DETableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[DETableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (row == [self.itemsArray indexOfObject:[itemsArray lastObject]]) {
        CellIdentifier = kPictureTableViewCell;
        UINib *nib = [UINib nibWithNibName:@"DEPictureTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        
        DEPictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DEPictureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImage *image = [UIImage imageNamed:@"drsolution.png"];
        cell.picture.image = image; 
        cell.label.minimumFontSize = font_size;
        cell.label.font = [UIFont systemFontOfSize:font_size];
        NSMutableAttributedString* attrItem = [NSMutableAttributedString attributedStringWithStringModifiedByTokens:item];
        cell.label.attributedText = attrItem;
        return cell;
    }
    
    cell.label.lineBreakMode = UILineBreakModeWordWrap;
    cell.label.minimumFontSize = font_size;
    cell.label.font = [UIFont systemFontOfSize:font_size];
    CGSize constraint = CGSizeMake(cell_content_width - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [item sizeWithFont:[UIFont systemFontOfSize:font_size] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    NSMutableAttributedString* attrItem = [NSMutableAttributedString attributedStringWithStringModifiedByTokens:item];
    cell.label.attributedText = attrItem;
    cell.label.frame = CGRectMake(CELL_CONTENT_MARGIN, CELL_CONTENT_MARGIN, cell_content_width - (CELL_CONTENT_MARGIN * 2), MAX(size.height, 44.0f));
    return cell;
}


#pragma mark - Table view delegate


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    int row = [indexPath row];
    if (row == [self.itemsArray indexOfObject:[itemsArray lastObject]])
        return 120;
    self.item = [self.itemsArray objectAtIndex:row];
    float font_size = FONT_SIZE;
    CGSize constraint = CGSizeMake(cell_content_width - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    CGSize size = [self.item sizeWithFont:[UIFont systemFontOfSize:font_size] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height, 44.0f);
    return height + (CELL_CONTENT_MARGIN * 2);
}

-(NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

@end
