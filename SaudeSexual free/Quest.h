//
//  Quest.h
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 16/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Quest : NSManagedObject

@property (nonatomic,assign) NSDate * data;
@property (nonatomic,assign) NSString * quest;
@property (nonatomic,assign) NSString * result;

@end
