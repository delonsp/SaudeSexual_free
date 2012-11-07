//
//  DETableViewCell.m
//  ImpotenciaSexual
//
//  Created by Alain Machado da Silva Dutra on 08/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DETableViewCell.h"

@implementation DETableViewCell
@synthesize label;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.Label = [[OHAttributedLabel alloc] init];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
