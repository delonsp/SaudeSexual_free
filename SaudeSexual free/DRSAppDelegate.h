//
//  DRSAppDelegate.h
//  SaudeSexual free
//
//  Created by Alain Machado da Silva Dutra on 12/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+iPhone5.h"


@class DRSTextTableViewController1_iPad; // FirstMasterViewController
@class DRSQuestTableViewController1_iPad; // SecondMasterViewController
@class DRSInfoTableViewController_iPad; // SecondViewController
@class RateSuggestService;

/*
 *  System Versioning Preprocessor Macros
 */
#define SYSTEM_VERSION_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]==NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch]!=NSOrderedDescending)


@interface DRSAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
  	DRSTextTableViewController1_iPad *tab1VC;
	DRSQuestTableViewController1_iPad *tab2VC;
	DRSInfoTableViewController_iPad *tab3VC;
}


@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *tabBarController;

@property (strong, nonatomic) IBOutlet DRSTextTableViewController1_iPad *tab1VC;
@property (strong, nonatomic) IBOutlet DRSQuestTableViewController1_iPad *tab2VC;
@property (strong, nonatomic) IBOutlet DRSInfoTableViewController_iPad *tab3VC;

// Convenience Methods / Accessors
@property (weak, nonatomic, readonly) UISplitViewController *splitViewController;
@property (weak, nonatomic, readonly) UIViewController *currentMasterViewController;
@property (weak, nonatomic, readonly) UINavigationController *masterNavigationController;
@property (weak, nonatomic, readonly) UINavigationController *detailNavigationController;



- (void) disableLeftBarButtonItemOnNavbar:(BOOL)disable;

@end
