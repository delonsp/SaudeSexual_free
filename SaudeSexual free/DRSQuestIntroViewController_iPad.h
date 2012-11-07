//
//  DRSQuestIntroViewController_iPad.h
//  SaudeSexual
//
//  Created by Alain Dutra on 24/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestIntroViewController_iPhone.h"

@interface DRSQuestIntroViewController_iPad : DRSQuestIntroViewController_iPhone

@property (strong, nonatomic) IBOutlet UITextView *textView;

-(void) updateDetailViewWithThisContent: (NSString *) content andProduct: (SKProduct *) product;
//- (void) continuar:(id)sender;

@end
