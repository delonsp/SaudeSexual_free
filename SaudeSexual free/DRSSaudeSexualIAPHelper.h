//
//  DRSSaudeSexualIAPHelper.h
//  SaudeSexual free
//
//  Created by Alain Machado da Silva Dutra on 12/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAPHelper.h"


@interface DRSSaudeSexualIAPHelper : IAPHelper

@property (strong, nonatomic) NSDictionary *dirs;


+ (DRSSaudeSexualIAPHelper *) sharedInstance;

@end
