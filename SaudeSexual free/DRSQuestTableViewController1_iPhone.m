//
//  DRSQuestTableViewController1_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 23/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestTableViewController1_iPhone.h"
#import "DRSQuestTableViewController2_iPhone.h"
#import "DRSQuestIntroViewController_iPhone.h"
#import "DRSPontTableViewController_iPhone.h"



@interface DRSQuestTableViewController1_iPhone () {
    
}


@end

@implementation DRSQuestTableViewController1_iPhone

@synthesize dataSource = _dataSource;


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

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForegroundNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
     UIImage *navBarImage = [[UIImage imageNamed:@"menubar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 15, 5, 15)];
    [self.navigationController.navigationBar setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    
//    self.navigationController.navigationBar.tintColor = [UIColor
//                                                         colorWithRed:0.31 green:0.52 blue:0.74 alpha:1];
    
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:30.0];
        titleView.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        titleView.textColor = [UIColor whiteColor]; // Change to desired color
        
        self.navigationItem.titleView = titleView;
        
    }
    titleView.text = @"Questionários";
    [titleView sizeToFit];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.tableView setBackgroundView:imgView];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:CLICKED_QUESTIONNAIRE_TAB_IN_IPHONE];
    
    self.dataSource = [[DRSIAPDataSource alloc] init];
    _priceFormatter = [[NSNumberFormatter alloc] init];
    [_priceFormatter
     setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [self loadProducts];
        
}

- (void)productPurchased:(NSNotification *)notification {
    //
    
    NSString * productIdentifier = notification.object;
    
    if ([productIdentifier isEqualToString:@"org.drsolution.saudesexual.all"]) {
        
        [self.tableView reloadData];
    } else {
        NSArray *array = [self.dataSource.dictOfProductsIDs allKeysForObject:productIdentifier];
        NSInteger intg = [array[0] integerValue];
        NSLog(@"intg= %i", intg);
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:intg inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
        
        [_products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
            if ([product.productIdentifier isEqualToString:productIdentifier]) {
                NSArray *array = [self.dataSource.dictOfProductsIDs allKeysForObject:productIdentifier];
                NSInteger intg = [array[0] integerValue];
                NSLog(@"intg= %i", intg);
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:intg inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                *stop = YES;
            }
        }];
        
    }
    
}

-(void) appWillEnterForegroundNotification: (NSNotification *) notification {
    NSLog(@"appWillEnterForegroundNotification activated !!");
    [self loadProducts];
}

- (void) loadProducts {
    _products = nil;
    [self.tableView reloadData];
    if ([self checkConnection] == NO) {
        NSLog(@"No internet connection !");
        
    } else {
        [[DRSSaudeSexualIAPHelper sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
            
            if (success && products.count>0) {
                [self setProducts:products];
                [self.tableView reloadData];
            }
        }];
    }
    
}





-(BOOL) checkConnection {
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.dataSource = nil;
    _hud = nil;
    _products = nil;
    _productsFromItunes = nil;
    _priceFormatter = nil;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)setProducts:(NSArray *)products {
    _products = products;
    
    _productsFromItunes = [[NSMutableArray alloc] init];
    [_products enumerateObjectsUsingBlock:^(SKProduct *aProduct, NSUInteger idx, BOOL *stop) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:aProduct,@"theProduct",aProduct.price,@"thePrice",aProduct.localizedTitle,@"theTitle",aProduct.productIdentifier,@"theID",nil];
        [_productsFromItunes addObject:dict];
    }];
    
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.sectionsArray.count;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.dataSource.itemsArray = [self.dataSource.sectionsArray objectAtIndex:section];
    return [self.dataSource.itemsArray count];
    
}

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
                    _restoreTapped = NO;
                   
                                   
                
                } else if (product == nil && [self checkConnection] == NO) {
                    
                    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    _hud.labelText = @"Obtendo informações...";
                    [self performSelector:@selector(noConnection:) withObject:nil
                               afterDelay:3.0];
                    
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row != 3) {
        return 60;
    } else {
        return 90;
    }
}

#pragma mark - hud methods

-(void) timeout: (id) arg {
    _hud.labelText = @"Timeout !";
    _hud.detailsLabelText = @"Por favor tente novamente mais tarde.";
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.jpg"]];
    _hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHud:) withObject:nil afterDelay:3.0];
}

-(void) noConnection: (id) arg {
    
    _hud.labelText = @"Sem conexão !";
    _hud.detailsLabelText = @"Por favor cheque sua Internet.";
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.jpg"]];
    _hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHud:) withObject:nil afterDelay:3.0];

}

-(void) dismissHud: (id) arg {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    _hud = nil;
}

#pragma mark - Callbacks

-(void) restoreTapped {
    if ([self checkConnection]) {
        NSLog(@"Restore tapped!");
        UIAlertView * alertView = [[UIAlertView alloc]
                                   initWithTitle:@"Restaurar Conteúdo"
                                   message:@"Gostaria de checar e restaurar compras anteriores?"
                                   delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@"OK", nil];
        alertView.delegate = self;
        [alertView show];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Erro"
                              message:@"Não pôde conectar com a iTunes Store. Cheque sua conexão e tente novamente mais tarde"
                              delegate:nil
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil];
        [alert show];
    }
    
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView
didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [[DRSSaudeSexualIAPHelper sharedInstance] restoreCompletedTransactions];
        
    }
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detailViewController;
    NSString *quest;
    SKProduct * product;
    
    if (indexPath.section ==0) {
        self.dataSource.itemsArray = [self.dataSource.sectionsArray objectAtIndex:indexPath.section];
        quest = [self.dataSource.itemsArray objectAtIndex:[indexPath row]];
        if (indexPath.row == 0) {
            [self restoreTapped];
            detailViewController =nil;
            
        } else if (indexPath.row==1){
            detailViewController = [[DRSQuestIntroViewController_iPhone alloc] initWithNibName:@"DRSQuestIntroViewController_iPhone" bundle:nil];
        } else if (indexPath.row==2){
            detailViewController = [[DRSPontTableViewController_iPhone alloc] initWithNibName:@"DRSPontTableViewController_iPhone" bundle:nil];
        } else {
            quest = @"OVP";
            detailViewController = [[DRSQuestIntroViewController_iPhone alloc] initWithNibName:@"DRSQuestIntroViewController_iPhone" bundle:nil];
 
        }
        
    } else {
        
        product = [self returnCorrectProductinIndexPath:indexPath];
        self.dataSource.itemsArray = [self.dataSource.sectionsArray objectAtIndex:indexPath.section];
        detailViewController = [[DRSQuestIntroViewController_iPhone alloc] initWithNibName:@"DRSQuestIntroViewController_iPhone" bundle:nil];
        
        if (indexPath.row == 0) {
            quest = @"all";
            if ([[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier]) {
                detailViewController = nil;
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
        
    }
    
    
    if ([detailViewController respondsToSelector:@selector(setProduct:)])
        [detailViewController setValue:product forKey:@"product"];
    if ([detailViewController respondsToSelector:@selector(setKey:)])
        [detailViewController setValue:quest forKey:@"key"];
    
    if (detailViewController)
        [self.navigationController pushViewController:detailViewController animated:YES];
    
}

-(BOOL) checkProductsinIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger number = indexPath.row;
    NSNumber *number2 = [[NSNumber alloc] initWithInt:number];
    NSString *stringNumber = [number2 stringValue];
    
    
    NSString *DRSProductIdentifier = [self.dataSource.dictOfProductsIDs objectForKey:stringNumber];
    
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:DRSProductIdentifier];
    
}

-(SKProduct *) returnCorrectProductinIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger number = indexPath.row;
    NSNumber *number2 = [[NSNumber alloc] initWithInt:number];
    NSString *stringNumber = [number2 stringValue];
    
    NSString *DRSProductIdentifier = [self.dataSource.dictOfProductsIDs objectForKey:stringNumber];
    SKProduct *product;
    
    if (_productsFromItunes) {
        for (NSDictionary *dict in _productsFromItunes) {
            NSString *IAPProductIdentifier = [dict objectForKey:@"theID"];
            
            if ([IAPProductIdentifier isEqualToString:DRSProductIdentifier]) {
                product = [dict objectForKey:@"theProduct"];
            }
        }
        
    } else {
        NSLog(@"No access to products in iTunes Store. Check internet connection.");
        NSLog(@"_products = %@", _products);
    }
    
    
    
    return product;
    
    
}


@end
