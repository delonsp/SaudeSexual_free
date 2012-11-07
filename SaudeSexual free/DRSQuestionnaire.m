//
//  DRSQuestionnaire.m
//  SaudeSexual
//
//  Created by Alain Dutra on 09/07/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSQuestionnaire.h"
#import "DRSContentController.h"

@implementation DRSQuestionnaire

float const kMaxGENERIC = 100.0f;
float const kMaxHSDD = 16.0f;
float const kMaxIIEF = 25.0f;
float const kMaxOVP = 15.0f;
NSString * const EDITS = @"EDITS";
NSString * const HSDD = @"HSDD";
NSString * const IIEF = @"IIEF-5";
NSString * const IPE = @"IPE";
NSString * const QEQ = @"QEQ";
NSString * const SEAR = @"SEAR";
NSString * const SQoLM = @"SQoL-M";
NSString * const OVP = @"OVP";

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


@synthesize pageOfQuestionnaire, questionnaireDictionary, questFromDict, totalofPages, dictOptions, resultados, partialScore, totalScore, listOfAnswers, dirURL;

-(id) init {
    self = [super init];
    if (self) {
        self.pageOfQuestionnaire = 0;
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"Questionários" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *array = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        self.dictOptions = array;
        self.partialScore = [[NSMutableArray alloc] init];
        
        path = [bundle pathForResource:@"Resultados" ofType:@"plist"];
        array = [[NSArray alloc] initWithContentsOfFile:path];
        self.resultados = array;
    }
    return self;
}


-(void) dealloc {
    pageOfQuestionnaire = 0;
    questionnaireDictionary = nil;
    questFromDict = nil;
    totalofPages = 0;
    dictOptions = nil;
    resultados = nil;
    partialScore = nil;
    totalScore=nil;
    listOfAnswers=nil;
    dirURL=nil;
    questionnaireName = nil;
}

-(void) setQuestionnaireName:(NSString *)questName {
    __block BOOL ok = NO;
    NSArray *array = [[NSArray alloc] initWithArray:[DRSContentController sharedInstance].
                      arrayofUnlockedQuests] ;
   [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       if ([obj isEqualToString:questName]) {
           ok = YES;
       }
            }];
    if (ok) {
        questionnaireName = questName;
        
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfURL:
                              [[DRSContentController sharedInstance].dictionaryofUnlockedURLS objectForKey:questionnaireName]];
        self.questionnaireDictionary = dict;
        self.questFromDict = [[self.questionnaireDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        self.totalofPages = [[self.questionnaireDictionary allKeys] count];
    } else if ([questName isEqualToString:@"OVP"]) {
        
        questionnaireName = questName;
        NSString *path = [[NSBundle mainBundle] pathForResource:self.questionnaireName ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        self.questionnaireDictionary = dict;
        self.questFromDict = [[self.questionnaireDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        self.totalofPages = [[self.questionnaireDictionary allKeys] count];
        
    } else {
        questionnaireName = @"Not unlocked";
    }
     
    
}

-(NSString *) questionnaireName {
    
    return questionnaireName;
}

-(NSUInteger) setPointFromChoice:(NSUInteger)row {
    
    NSUInteger number = [self.dictOptions indexOfObject:self.questionnaireName];
    
    NSUInteger point=0;
    
    switch (number) {
        case kEDITS:
            point = 6 - row;
            break;
            
        case kHSDD:
            point = row-1;
            break;
            
        case kIIEF:
            
            if (self.pageOfQuestionnaire == 0) 
                point = row;
            else
                point = row-1;
            
            break;
            
        case kIPE:
            if (self.pageOfQuestionnaire < 8) 
                point = 6- row;
            else 
                point = row;
            
            break;
            
        case kOVP:
            point = row;
            break;
            
        case kQEQ:
            point = 6- row;
            break;
            
        case kSEAR:
            if (self.pageOfQuestionnaire != 7 && self.pageOfQuestionnaire != 10) 
                point = 6-row;
            else 
                point = row;
            
            break;
            
        case kSQOL:
            if (self.pageOfQuestionnaire != 0 && self.pageOfQuestionnaire != 4 && self.pageOfQuestionnaire != 8) 
                point = row;
            else
                point = 7-row;
            break;
    }
    
    return point;
}

-(void) finalScore {
    
    int score = 0;
    for (NSNumber *num in self.partialScore) {
        
        score += [num intValue];
        
    }
    
    NSUInteger number = [self.dictOptions indexOfObject:self.questionnaireName];
    
    switch (number) {
        case kEDITS:
            score = (score-11) * 100 / 44;
            break;
        case kHSDD:
            // pontuação simples
        case kIIEF:
            //pontuação simples
            break;
        case kIPE:
            score = (score - 10)* 100 / 40;
            break;
        case kOVP:
            //pontuação simples
            break;
        
        case kQEQ:
            score = (score - 6)* 100 / 24;
            break;
        case kSEAR:
            score = (score -14) * 100 / 56;
            break;
        case kSQOL:
            score = (score -11) * 100 / 55;
            break;
    }
    
    self.totalScore  = [NSString stringWithFormat:@"%u",score];
}

-(NSString *) getConclusionFromQuestName:(NSString*) quest withResult:(NSUInteger)result {
    NSString *str = [[NSString alloc] init];
    NSUInteger number = [self.dictOptions indexOfObject:quest];
    NSDictionary *dict;
    switch (number) {
            
        case kOVP:
            dict = [self.resultados objectAtIndex:2];
            if (result > 10)
                str = [dict objectForKey:@"organ"];
            else
                str = [NSString stringWithFormat:@"Isto significa %@", [dict objectForKey:@"psico"]];
            
            break;

        case kIIEF:
            dict = [self.resultados objectAtIndex:1];
            if (result <= 7) {
                str = [NSString stringWithFormat:@"Isto significa %@",[dict objectForKey:@"severa"]];
            } else if (result >= 8 && result <= 11){
                str = [NSString stringWithFormat:@"Isto significa %@",[dict objectForKey:@"moderada"]];
            } else if (result >=12 && result <= 16) {
                str = [NSString stringWithFormat:@"Isto significa %@",[dict objectForKey:@"leve a moderada"]];
            } else if (result >=17 && result <=21) {
                str = [NSString stringWithFormat:@"Isto significa %@",[dict objectForKey:@"leve"]];
            } else {
                str = [NSString stringWithFormat:@"Isto significa %@",[dict objectForKey:@"ausência"]];
            }
            
            break;
        case kHSDD:
            dict = [self.resultados objectAtIndex:0];
            if (result <= 6) {
                str = [NSString stringWithFormat:@"Isto significa %@",[dict objectForKey:@"normal"]];
            } else {
                str = [NSString stringWithFormat:@"Isto significa %@",[dict objectForKey:@"anormal"]];
            }
            
            break;
            
        default:
            str=@"";
            break;
    }
    return str;
}



@end
