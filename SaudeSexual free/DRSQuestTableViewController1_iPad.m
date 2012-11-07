//
//  DRSQuestTableViewController1_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 23/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestTableViewController1_iPad.h"
#import "DRSPontTableViewController_iPad.h"
#import "DRSPontTableViewController2_iPad.h"

@interface DRSQuestTableViewController1_iPad ()

@end

@implementation DRSQuestTableViewController1_iPad
@synthesize dvc;

- (void) detail {
    DRSAppDelegate *appDelegate = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
    UISplitViewController *svc1 = [appDelegate.tabBarController.viewControllers objectAtIndex:1];
    UINavigationController *detail1 = [svc1.viewControllers objectAtIndex:1];
    self.dvc = [detail1.viewControllers objectAtIndex: 0];
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
     
    if (!self.dvc) {
        [self detail];
    }
    
    if (self.dvc.navigationController.viewControllers.count >1) {
        [self.dvc.navigationController popToRootViewControllerAnimated:YES];
        
    }
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Voltar"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];

}



- (void)viewDidLoad
{
    [super viewDidLoad];
 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.dataSource.itemsArray = [self.dataSource.sectionsArray objectAtIndex:indexPath.section];
    self.dataSource.item = [self.dataSource.itemsArray objectAtIndex:[indexPath row]];
    NSString *CellIdentifier;
    
    if (indexPath.section ==0 && indexPath.row !=3) {
        
        CellIdentifier = kNormalCell;
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = self.dataSource.item;
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        
        return cell;
        
    } else {
        
        CellIdentifier = kDRSStoreCell;
        
        UINib *nib = [UINib nibWithNibName:@"DRSStoreCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        
        DRSStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[DRSStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.cellLabelText.text = self.dataSource.item;
        cell.cellLabelText.textAlignment = UITextAlignmentLeft;
        cell.cellLabelText.numberOfLines = 4;
        cell.cellLabelText.backgroundColor = [UIColor clearColor];
        cell.cellLabelText.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        
        
        if (indexPath.section == 1) {
            
            SKProduct *product;
            
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            _hud = nil;
            
            if ([self checkProductsinIndexPath:indexPath]) {
                
                cell.cellPriceLabel.text = @"OK";
                cell.cellPriceLabel.textAlignment = UITextAlignmentLeft;
                UIImage *unlocked = [UIImage imageNamed:@"Unlocked.png"];
                cell.cellPriceImage.image = unlocked;
                
                
            } else {
                product = [self returnCorrectProductinIndexPath:indexPath];
                
                if ((product == nil && [self checkConnection] == YES)) {
                    
                    NSLog(@"%@",product.productIdentifier);
                    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    _hud.labelText = @"Obtendo informações...";
                    [self performSelector:@selector(timeout:) withObject:nil
                               afterDelay:30.0];
                    
                    NSLog(@"hud = %@", _hud);
                    
                } else if (product == nil && [self checkConnection] == NO) {
                    
                    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    _hud.labelText = @"Obtendo informações...";
                    [self performSelector:@selector(noConnection:) withObject:nil
                               afterDelay:3.0];
                    
                     NSLog(@"hud = %@", _hud);
                }
                
                cell.cellPriceLabel.text = [_priceFormatter stringFromNumber:product.price];
                UIImage *shoppingCart = [UIImage imageNamed:@"Shopping-Cart.png"];
                cell.cellPriceImage.image = shoppingCart;
            }
            
        }
        
        if (indexPath.section == 0) {
            cell.cellPriceLabel.text = @"Gratuito";
            cell.cellPriceLabel.textAlignment = UITextAlignmentLeft;
            UIImage *thumbsUp = [UIImage imageNamed:@"Thumbs-Up.png"];
            cell.cellPriceImage.image = thumbsUp;
        }
        
        
        return cell;
        
    }

    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];


}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSString *quest;
    SKProduct * product;

    
    if (indexPath.section == 0) {
        self.dataSource.itemsArray = [self.dataSource.sectionsArray objectAtIndex:indexPath.section];
        quest = [self.dataSource.itemsArray objectAtIndex:[indexPath row]];
        
        if (indexPath.row ==0 ) {
            [self restoreTapped];
            
        } else if (indexPath.row == 1){
            self.dataSource.itemsArray = [self.dataSource.sectionsArray objectAtIndex:indexPath.section];
            quest = [self.dataSource.itemsArray objectAtIndex:[indexPath row]];
            [self.dvc updateDetailViewWithThisContent:quest andProduct:nil];
            
        } else if (indexPath.row == 2) {
            DRSPontTableViewController_iPad *vc1 = [[DRSPontTableViewController_iPad alloc] initWithNibName:@"DRSPontTableViewController_iPhone" bundle:nil];
            DRSAppDelegate *appDelegate = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
            UINavigationController *nvc = [appDelegate detailNavigationController];
            DRSPontTableViewController2_iPad *vc2 = [[DRSPontTableViewController2_iPad alloc] initWithNibName:@"DRSPontTableViewController2_iPhone" bundle:nil];
            [nvc pushViewController:vc2 animated:YES];
            [self.navigationController pushViewController:vc1 animated:YES];

        } else {
            quest = @"OVP";
            [self.dvc updateDetailViewWithThisContent:quest andProduct:nil];
        }
        
    } else {
        product = [self returnCorrectProductinIndexPath:indexPath];
        self.dataSource.itemsArray = [self.dataSource.sectionsArray objectAtIndex:indexPath.section];
        
        if (indexPath.row == 0) {
            quest = @"all";
            if ([[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier]) {
               
                UIAlertView * alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Já comprado"
                                           message:@"Você já adquiriu todos os questionários!"
                                           delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:nil];
                
                [alertView show];
            }

        } else {
            quest = [self.dataSource.itemsArray objectAtIndex:[indexPath row]];
            NSRange startRange = [quest rangeOfString:@"("];
            NSRange endRange = [quest rangeOfString:@")"];
            NSRange searchRange = NSMakeRange(startRange.location+1 , endRange.location-startRange.location-1);
            quest = [quest substringWithRange:searchRange];
            
        }

        
        [self.dvc updateDetailViewWithThisContent:quest andProduct:product];
        
    }
}



@end
