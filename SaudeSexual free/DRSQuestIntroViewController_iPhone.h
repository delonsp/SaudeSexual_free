//
//  DRSQuestIntroViewController_iPhone.h
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 05/05/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRSSaudeSexualIAPHelper.h"
#import "DRSAttributedTableView.h"
#import "DRSSaudeSexualIAPHelper.h"

@interface DRSQuestIntroViewController_iPhone : UIViewController<UIAlertViewDelegate> {
      NSNumberFormatter * _priceFormatter;
}



@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (copy, nonatomic) NSString *key;
@property (strong, nonatomic) SKProduct *product;
@property (strong, nonatomic) NSDictionary *dict;

-(void) buyButton:(NSNotification *)notification;
- (void)buyTapped:(id)sender;
-(void) goToQuest: (id) sender;

@end
