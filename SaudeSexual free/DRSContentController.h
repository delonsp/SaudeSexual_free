//
//  DRSContentController.h
//  SaudeSexual free
//
//  Created by Alain Machado da Silva Dutra on 15/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DRSSaudeSexualIAPHelper.h"


UIKIT_EXTERN NSString *const HMContentControllerUnlockedWordsDidChangeNotification;

@interface DRSContentController : NSObject {
    BOOL _ok;
}

@property (strong, nonatomic) NSMutableArray *arrayofUnlockedQuests;
@property (strong, nonatomic) NSMutableDictionary *dictionaryofUnlockedURLS;


+ (DRSContentController *)sharedInstance;
- (void)unlockContentWithString: (NSString *) directory;
- (BOOL)unlockEverything;


@end
