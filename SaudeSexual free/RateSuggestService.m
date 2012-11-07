//
//  RateSuggestService.m
//  CNS
//
//  Created by Tal Hashai on 27/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RateSuggestService.h"

@interface RateSuggestService ()
{
    NSString *alertTitle;
    NSString *alertBody;
    NSString *alertButtonYes;
    NSString *alertButtonNo;
    NSString *rateUrl;
    
    NSString *suggestedRatingFilename;
    NSMutableDictionary *suggestedRating;
    int _daysInterval;
}
- (void)save;
@end

@implementation RateSuggestService

#define SUGGESTED_RATING_FILENAME      @"SuggestedRating.plist"

#define ENTRY_LAST_SUGGEST              @"lastSuggest"
#define ENTRY_SUGGEST_COUNT             @"suggestCount"
#define ENTRY_DID_RATE                  @"didRate"

#pragma mark - Singleton Management

static RateSuggestService *_sharedService;

+ (RateSuggestService *)sharedService 
{
	@synchronized(self) 
    {
        if (_sharedService == nil) 
            _sharedService = [[self alloc] init];					
    }
    return _sharedService;
}

- (RateSuggestService *)init
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    suggestedRatingFilename = [documentsDirectory stringByAppendingPathComponent:SUGGESTED_RATING_FILENAME];
    suggestedRating = [NSMutableDictionary dictionaryWithContentsOfFile:suggestedRatingFilename];
    
    if (!suggestedRating) 
    {
        suggestedRating = [[NSMutableDictionary alloc] init];
        [suggestedRating setObject:[NSDate date] forKey:ENTRY_LAST_SUGGEST];
        [suggestedRating setObject:[NSNumber numberWithInt:0] forKey:ENTRY_SUGGEST_COUNT];
        [self save];
    }
    
    return self;
}

- (void)save
{
    [suggestedRating writeToFile:suggestedRatingFilename atomically:YES];
}

- (void)setSuggestInterval:(int)intervalDays
{
    _daysInterval = intervalDays;
}

- (void)setAlertTitle:(NSString *)title body:(NSString *)body buttonYes:(NSString *)buttonYes buttonNo:(NSString *)buttonNo
{
    alertBody = body;
    alertTitle = title;
    alertButtonNo = buttonNo;
    alertButtonYes = buttonYes;
}

- (void)setRateUrl:(NSString *)url
{
    rateUrl = url;
}

- (int)daysDiff:(NSDate *)lastDate today:(NSDate *)today {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:NSDayCalendarUnit fromDate:lastDate toDate:today options:0];
	return [components day];
}

// returns YES if rate alert was shown
- (BOOL)check
{
    NSNumber *didRate = [suggestedRating objectForKey:ENTRY_DID_RATE];
    // user already rated, no need for this
    if (didRate && [didRate boolValue])
        return NO;
    
    NSDate *lastSuggest = [suggestedRating objectForKey:ENTRY_LAST_SUGGEST];
    int days = [self daysDiff:lastSuggest today:[NSDate date]];
    
    if (days < _daysInterval)
        return NO;
    
    int count = [[suggestedRating objectForKey:ENTRY_SUGGEST_COUNT] intValue] + 1;
    [suggestedRating setObject:[NSNumber numberWithInt:count] forKey:ENTRY_SUGGEST_COUNT];    
    [suggestedRating setObject:[NSDate date] forKey:ENTRY_LAST_SUGGEST];
    [self save];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                    message:alertBody 
                                                   delegate:self 
                                          cancelButtonTitle:alertButtonNo 
                                          otherButtonTitles:alertButtonYes, nil];
    [alert show];
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    // store the user's response
    [suggestedRating setObject:[NSNumber numberWithInt:buttonIndex] forKey:[[NSDate date] description]];
    [suggestedRating setObject:[NSNumber numberWithInt:buttonIndex] forKey:ENTRY_DID_RATE];
    [self save];    
    
    if (buttonIndex == 1)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:rateUrl]];
}

@end
