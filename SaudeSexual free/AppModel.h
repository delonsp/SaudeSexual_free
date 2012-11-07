//
//  AppModel.h
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 16/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Quest.h"
#import "DRSQuestionnaire.h"

#define EXPANDED_SECTION_IN_IPHONE @"Expanded Section in iPhone"
#define EXPANDED_SECTION_IN_IPAD @"Expanded Section in iPad"
#define SELECTED_TOPIC_IN_IPHONE @"Selected Topic in iPhone"
#define SELECTED_TOPIC_IN_IPAD @"Selected Topic in iPad"
#define SELECTED_PICTURE_IN_IPHONE @"Selected Picture in iPhone"
#define SELECTED_PICTURE_IN_IPAD @"Selected Picture in iPad"
#define CLICKED_QUESTIONNAIRE_TAB_IN_IPHONE @"Clicked Questionnaire Tab in iPhone"
#define CLICKED_QUESTIONNAIRE_TAB_IN_IPAD @"Clicked Questionnaire Tab in iPad"
#define CHOSE_TO_DO_QUESTIONNAIRE_IN_IPHONE @"Chose to do Questionnaire in iPhone"
#define CHOSE_TO_DO_QUESTIONNAIRE_IN_IPAD @"Chose to do Questionnaire in iPad"
#define CLICKED_ANTERIOR_RESULTS_IN_IPHONE @"Clicked Anterior Results in iPhone"
#define CLICKED_ANTERIOR_RESULTS_IN_IPAD @"Clicked Anterior Results in iPad"
#define SELECTED_SPECIFIC_ANTERIOR_RESULT_IN_IPHONE @"Selected Specific Anterior Result in iPhone"
#define SELECTED_SPECIFIC_ANTERIOR_RESULT_IN_IPAD @"Selected Specific Anterior Result in iPad"
#define CLICKED_INFO_TAB_IN_IPHONE @"Clicked Info Tab in iPhone"
#define CLICKED_INFO_TAB_IN_IPAD @"Clicked Info Tab in iPad"

#define HOMO @"Saúde do Homossexual"
#define DST @"DST"



@interface AppModel : NSObject {
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSString *questionnaireName;
}


@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(strong) NSString *dataStoreFile;
@property (nonatomic, strong) DRSQuestionnaire *questionnaire;
@property(strong) NSMutableArray *listOfAnswers;

-(NSString *)applicationDocumentsDirectory;
-(void)getObjectsFromDataStore;
-(void)addManagedObject;
-(void)saveChangesToDataStore;
-(void) finalScore;


+ (AppModel *)sharedModel;

@end
