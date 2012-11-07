//
//  DRSIAPDataSource.m
//  SaudeSexual free
//
//  Created by Alain Machado da Silva Dutra on 14/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSIAPDataSource.h"

@interface DRSIAPDataSource () 

@end

@implementation DRSIAPDataSource

@synthesize sectionsArray = _sectionsArray;
@synthesize itemsArray = _itemsArray;
@synthesize rootItems = _rootItems;
@synthesize questArray = _questArray;
@synthesize item = _item;
@synthesize DRSproductIdentifiers = _DRSproductIdentifiers;

-(id) init {
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Nomes Questionários" ofType:@"plist"];
        self.sectionsArray =[[NSMutableArray alloc] initWithContentsOfFile:path];
        self.itemsArray = [[NSArray alloc] init];
        
        path = [[NSBundle mainBundle] pathForResource:@"Questionários" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        self.rootItems = dict;
        
        self.questArray = [[self.rootItems allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        NSArray * productIdentifiers = [NSArray  arrayWithObjects:
                                        @"org.drsolution.saudesexual.EDITS",
                                        @"org.drsolution.saudesexual.HSDD",
                                        @"org.drsolution.saudesexual.IIEF",
                                        @"org.drsolution.saudesexual.QEQ",
                                        @"org.drsolution.saudesexual.SEAR",
                                        @"org.drsolution.saudesexual.SQoLM",
                                        @"org.drsolution.saudesexual.ipe"
                                        @"org.drsolution.saudesexual.all",nil];
                     
        self.DRSproductIdentifiers = productIdentifiers;
        
        path = [[NSBundle mainBundle] pathForResource:@"productsID Dictionary" ofType:@"plist"];
        self.dictOfProductsIDs = [[NSDictionary alloc] initWithContentsOfFile:path];

    }
    return self;
}

-(void) dealloc {
    self.itemsArray =nil; self.rootItems =nil; self.rootItems=nil; self.questArray=nil;
    self.item = nil; self.DRSproductIdentifiers = nil;
}

@end
