//
//  DEPictureTableViewCell.h
//  ImpotenciaSexual
//
//  Created by Alain Machado da Silva Dutra on 08/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"

@interface DEPictureTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *picture;
@property (strong, nonatomic) IBOutlet OHAttributedLabel *label;
@end
