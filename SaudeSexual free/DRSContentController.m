//
//  DRSContentController.m
//  SaudeSexual free
//
//  Created by Alain Machado da Silva Dutra on 15/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSContentController.h"


NSString *const HMContentControllerUnlockedWordsDidChangeNotification = @"HMContentControllerUnlockedWordsDidChangeNotification";

@implementation DRSContentController

+ (DRSContentController *)sharedInstance {
    static dispatch_once_t once;
    static DRSContentController * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id) init {
    if ((self = [super init])) {
        _dictionaryofUnlockedURLS = [[NSMutableDictionary alloc] init];
        _arrayofUnlockedQuests = [[NSMutableArray alloc] init];
        
    }
    return self;
}


-(void) unlockContentWithString:(NSString *) directory {
   
    if ([directory isEqualToString:@"all"]) {
        _ok = [self unlockEverything];
        return;
    }
    if (_ok) {
        NSURL * resourceURL = [NSBundle mainBundle].resourceURL;
        NSURL * dirURL = [resourceURL URLByAppendingPathComponent:directory];
        NSURL * plistURL = [dirURL URLByAppendingPathComponent:@"questQuestions.plist"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:plistURL.path]) {
            [_arrayofUnlockedQuests addObject:directory];
            [_dictionaryofUnlockedURLS setObject:plistURL forKey:directory];
            
        } else {
            NSLog(@"Não achei o caminho do diretório de %@",directory);
        }

    }
    
}

-(BOOL) unlockEverything {
    _dictionaryofUnlockedURLS = [[NSMutableDictionary alloc] init];
    NSURL * resourceURL = [NSBundle mainBundle].resourceURL;
    NSArray *array = [NSArray arrayWithObjects:@"EDITS", @"HSDD",@"IIEF-5",@"IPE",@"QEQ",@"SEAR",@"SQoL-M",nil];
    
    _arrayofUnlockedQuests = [[NSMutableArray alloc] initWithArray:array];
    
    [_arrayofUnlockedQuests enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        NSURL * dirURL = [resourceURL URLByAppendingPathComponent:obj];
        
        NSURL * plistURL = [dirURL URLByAppendingPathComponent:@"questQuestions.plist"];
        
        [_dictionaryofUnlockedURLS setObject:plistURL forKey:obj];
    }];
    
    return YES;

}

-(NSMutableArray *) arrayofUnlockedQuests {
    return _arrayofUnlockedQuests;
}

-(NSMutableDictionary *) arrayofUnlockedURLS {
    return _dictionaryofUnlockedURLS;
}

@end
