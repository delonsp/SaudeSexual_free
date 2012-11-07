//
//  AppModel.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 16/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "AppModel.h"

enum {
    kEDITS,
    kHSDD,
    kIIEF,
    kIPE,
    kOVP,
    kQEQ,
    kSEAR,
    kSQOL
};

@implementation AppModel
@synthesize dataStoreFile, listOfAnswers;
@synthesize questionnaire;

//static AppModel *sharedObject = nil;




-(id) init {
    self = [super init];
    if (self) {
        self.dataStoreFile = @"appmodel.sqlite";
        [self getObjectsFromDataStore];
        self.questionnaire = [[DRSQuestionnaire alloc] init];
    }
    return self;
}


+ (AppModel *)sharedModel {
    static dispatch_once_t once;
    static AppModel * sharedModel;
    dispatch_once(&once, ^{
        sharedModel = [[self alloc] init];
    });
    return sharedModel;
}


#pragma Core Data

-(void)getObjectsFromDataStore{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Quest"
                                              inManagedObjectContext:[self managedObjectContext]];
    request.entity = entity;
    self.listOfAnswers = [[[self managedObjectContext] executeFetchRequest:request error:nil] mutableCopy];
    
}

-(void)addManagedObject{
    
    Quest *managedObject = (Quest*)[NSEntityDescription insertNewObjectForEntityForName:@"Quest" 
                                                                             inManagedObjectContext:[self managedObjectContext]];
    
    managedObject.quest = questionnaire.questionnaireName;
    managedObject.result = questionnaire.totalScore;
    managedObject.data = [NSDate date];
   
    
    [self.listOfAnswers addObject:managedObject];
    [self saveChangesToDataStore];
    
}

- (void)saveChangesToDataStore {
    NSError *error = nil;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (NSManagedObjectContext *)managedObjectContext {
    if (managedObjectContext) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator) {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory]
                                              stringByAppendingPathComponent:self.dataStoreFile]];
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                  configuration:nil
                                                            URL:storeUrl
                                                        options:nil
                                                          error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator;
}


- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


-(void) finalScore {
        
    [questionnaire finalScore];
   
    [self addManagedObject];
}


@end
