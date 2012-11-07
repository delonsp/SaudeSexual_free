//
//  DRSSaudeSexualIAPHelper.m
//  SaudeSexual free
//
//  Created by Alain Machado da Silva Dutra on 12/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSSaudeSexualIAPHelper.h"
#import "DRSContentController.h"

@interface DRSSaudeSexualIAPHelper ()

-(void) unlockContentForProductIdentifier:(NSString *)productIdentifier
                                         directory:(NSString *)directory;

@end

@implementation DRSSaudeSexualIAPHelper


+ (DRSSaudeSexualIAPHelper *) sharedInstance {
    static dispatch_once_t once;
    static DRSSaudeSexualIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
                sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id) init {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockPreviousPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    
    NSSet * productIdentifiers = [NSSet setWithObjects:
                                  @"org.drsolution.saudesexual.HSDD",
                                  @"org.drsolution.saudesexual.IIEF",
                                  @"org.drsolution.saudesexual.ipe",
                                  @"org.drsolution.saudesexual.QEQ",
                                  @"org.drsolution.saudesexual.SEAR",
                                  @"org.drsolution.saudesexual.SQoLM",
                                  @"org.drsolution.saudesexual.EDITS",
                                  @"org.drsolution.saudesexual.all",nil];
    
    self.dirs = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"all",
                 @"org.drsolution.saudesexual.all",
                 @"EDITS",
                 @"org.drsolution.saudesexual.EDITS",
                 @"HSDD",
                 @"org.drsolution.saudesexual.HSDD",
                 @"IIEF-5",
                 @"org.drsolution.saudesexual.IIEF",
                 @"IPE",
                 @"org.drsolution.saudesexual.ipe",
                 @"QEQ",
                 @"org.drsolution.saudesexual.QEQ",
                 @"SEAR",
                 @"org.drsolution.saudesexual.SEAR",
                 @"SQoL-M",
                 @"org.drsolution.saudesexual.SQoLM",nil];
    
    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {
             
        for (NSString *str in productIdentifiers) {
                
            if ([[NSUserDefaults standardUserDefaults] boolForKey:str] ) {
                
                [self unlockContentForProductIdentifier:str directory:[self.dirs objectForKey:str]];
            }
              
        }
    }
    
    return self;
}

-(void) dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setDirs:nil];
}

- (void)unlockPreviousPurchased:(NSNotification *)notification {
    
    NSString * productIdentifier = notification.object;
    [self unlockContentForProductIdentifier:productIdentifier directory:[self.dirs objectForKey:productIdentifier]];
        
}


-(void) unlockContentForProductIdentifier:(NSString *)productIdentifier directory:(NSString *)directory {
        
    [[NSUserDefaults standardUserDefaults] setBool:YES
                                            forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[DRSContentController sharedInstance] unlockContentWithString:directory];
    
}


@end
