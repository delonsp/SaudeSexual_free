//
//  TextLevel1.h
//  SaudeSexual
//
//  Created by Alain Dutra on 15/07/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextLevel1 : NSObject
@property (strong, nonatomic) NSArray *sectionItems;
@property (assign, nonatomic) NSNumber *oldSection;
@property (assign, nonatomic) NSUInteger oldSectionRowsCount;
@property (strong, nonatomic) NSArray *arrayOfSectionRowsArrays;
@property (copy, nonatomic) NSMutableArray *mutableArrayOfSectionRowsArrays;
-(NSUInteger) insertSectionAndReturnsArrayCount: (NSUInteger) noOfSection;
-(void) removeSection: (NSUInteger) noOfSection;
@end

