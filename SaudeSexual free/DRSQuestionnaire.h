//
//  DRSQuestionnaire.h
//  SaudeSexual
//
//  Created by Alain Dutra on 09/07/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRSQuestionnaire : NSObject {
  
    NSString *questionnaireName;

}
extern float const kMaxGENERIC;
extern float const kMaxHSDD;
extern float const kMaxIIEF;
extern float const kMaxOVP;
extern NSString * const EDITS;
extern NSString * const HSDD;
extern NSString * const IIEF;
extern NSString * const IPE;
extern NSString * const QEQ;
extern NSString * const SEAR;
extern NSString * const SQoLM;
extern NSString * const OVP;


@property (strong, nonatomic) NSDictionary *questionnaireDictionary;
@property (copy, nonatomic) NSString *questionnaireName;
@property (assign) int pageOfQuestionnaire;
@property (strong) NSMutableArray *partialScore;
@property (copy, nonatomic) NSString *totalScore;
@property(strong) NSMutableArray *listOfAnswers;
@property(strong) NSArray *questFromDict;
@property(strong) NSArray *resultados;
@property (assign) NSUInteger totalofPages;
@property (strong, nonatomic) NSArray *dictOptions;
@property (nonatomic, readonly, strong) NSURL * dirURL;

-(NSUInteger)setPointFromChoice: (NSUInteger) choice ;
-(void) finalScore;
-(NSString *) getConclusionFromQuestName:(NSString*) quest withResult: (NSUInteger) result;
//- (id)initWithDirURL:(NSURL *)url;

@end
