//
//  DRSAppDelegate.h
//  SaudeSexual free
//
//  Created by Alain Machado da Silva Dutra on 12/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>



@class DRSTextTableViewController1_iPad; // FirstMasterViewController
@class DRSQuestTableViewController1_iPad; // SecondMasterViewController
@class DRSInfoTableViewController_iPad; // SecondViewController
@class RateSuggestService;



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
