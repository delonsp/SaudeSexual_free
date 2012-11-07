//
//  TextLevel1.m
//  SaudeSexual
//
//  Created by Alain Dutra on 15/07/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "TextLevel1.h"

@implementation TextLevel1
@synthesize sectionItems, oldSection, oldSectionRowsCount, arrayOfSectionRowsArrays, mutableArrayOfSectionRowsArrays;

-(id) init {
    if (self = [super init]) {
        NSString *path =[[NSBundle mainBundle] pathForResource:@"Text1" ofType:@"plist"];
        NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
        self.sectionItems = array;
        path =[[NSBundle mainBundle] pathForResource:@"Text1a" ofType:@"plist"];
        array = [[NSArray alloc] initWithContentsOfFile:path];
        arrayOfSectionRowsArrays =  array;
        mutableArrayOfSectionRowsArrays = [[NSMutableArray alloc] init];
        for (NSArray *array in arrayOfSectionRowsArrays) {
            NSMutableArray *myArray = [[NSMutableArray alloc] init];
            [mutableArrayOfSectionRowsArrays addObject:myArray];
        }
    }
    return self;
}

-(void) dealloc {
    sectionItems = nil;
    arrayOfSectionRowsArrays = nil;
    mutableArrayOfSectionRowsArrays = nil;
        
}

-(NSUInteger) insertSectionAndReturnsArrayCount:(NSUInteger)noOfSection {
    NSMutableArray *subSectionItems  = [[arrayOfSectionRowsArrays objectAtIndex:noOfSection] mutableCopy];
    [subSectionItems removeObjectAtIndex:0];
    [mutableArrayOfSectionRowsArrays replaceObjectAtIndex:noOfSection withObject:subSectionItems];
    oldSection = [NSNumber numberWithInt:noOfSection];
    
    oldSectionRowsCount = [subSectionItems count];
    return oldSectionRowsCount;
}

-(void) removeSection:(NSUInteger)noOfSection {
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    [mutableArrayOfSectionRowsArrays replaceObjectAtIndex:noOfSection withObject:myArray];
}

@end
