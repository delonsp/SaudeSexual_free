//
//  DRSAttributedTableView.h
//  SaudeSexual
//
//  Created by Alain Dutra on 09/07/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DRSAttributedTableView <NSObject>
@required

- (CGRect) defineFrameWithCellContentWidth: (CGFloat) cellContentWidth andString: (NSString *) string;
- (CGFloat) defineHeightForRowWithCellContentWidth: (CGFloat) cellContentWidth andString: (NSString *) string;

@end
