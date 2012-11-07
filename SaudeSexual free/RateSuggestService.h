//
//  RateSuggestService.h
//  CNS
//
//  Created by Tal Hashai on 27/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RateSuggestService : NSObject <UIAlertViewDelegate>

+ (RateSuggestService *)sharedService;

- (void)setSuggestInterval:(int)intervalDays;
- (void)setAlertTitle:(NSString *)title body:(NSString *)body buttonYes:(NSString *)buttonYes buttonNo:(NSString *)buttonNo;
- (void)setRateUrl:(NSString *)url;

- (BOOL)check;

@end
