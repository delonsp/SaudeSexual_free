//
//  DRSAppDelegate.m
//  SaudeSexual free
//
//  Created by Alain Machado da Silva Dutra on 12/10/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSAppDelegate.h"
#import "DRSTextTableViewController1_iPad.h"
#import "DRSQuestTableViewController1_iPad.h"
#import "DRSInfoTableViewController_iPad.h"
#import "RateSuggestService.h"
#import "LocalyticsSession.h"
#import "DRSSaudeSexualIAPHelper.h"

#define APP_ID 570322384
#define APP_KEY @"5f626bbe77d62a78ac3e14e-9f493d1e-25df-11e2-606b-00ef75f32667"

@implementation DRSAppDelegate

@synthesize window = _window;
@synthesize tabBarController=_tabBarController;
@synthesize tab1VC, tab2VC, tab3VC;



////// IPAD ONLY

- (UISplitViewController *) splitViewController {
    
	if (![self.tabBarController.selectedViewController isKindOfClass:[UISplitViewController class]]) {
		NSLog(@"Unexpected navigation controller class in tab bar controller hierarchy, check nib.");
		return nil;
	}
	return (UISplitViewController *)self.tabBarController.selectedViewController;
}
- (UINavigationController *) masterNavigationController {
	UISplitViewController *split = [self splitViewController];
	if (split && split.viewControllers && [split.viewControllers count])
		return [split.viewControllers objectAtIndex:0];
	return nil;
}
- (UINavigationController *) detailNavigationController {
	UISplitViewController *split = [self splitViewController];
	if (split && split.viewControllers && [split.viewControllers count]>1)
		return [split.viewControllers objectAtIndex:1];
	return nil;
}
- (UIViewController *) currentMasterViewController {
	UINavigationController *nav = [self masterNavigationController];
	if (nav && nav.viewControllers && [nav.viewControllers count])
		return [nav.viewControllers objectAtIndex:0];
	return nil;
}



#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (BOOL)tabBarController:(UITabBarController *)tbc shouldSelectViewController:(UIViewController *)viewController {
	if (!viewController.tabBarItem.enabled)
		return NO;
    
	
	if (![viewController isEqual:tbc.selectedViewController]) {
		NSLog(@"About to switch tabs, popping to root view controller.");
		UINavigationController *nav1 = [self detailNavigationController];
        UINavigationController *nav2 = [self masterNavigationController];
		if (nav1 && [nav1.viewControllers count]>1)
			[nav1 popToRootViewControllerAnimated:YES];
        if (nav2 && [nav2.viewControllers count]>1)
			[nav2 popToRootViewControllerAnimated:YES];
	}
	
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    //    UISplitViewController *svc = (UISplitViewController* ) viewController;
    //    UINavigationController *master = [svc.viewControllers objectAtIndex:0];
    UINavigationController *master = [self masterNavigationController];
    
    id m1 = [master.viewControllers objectAtIndex: 0];
    
    
    if ([m1 respondsToSelector: @selector(detail)]) {
        [m1 detail];
    }
    
}

#pragma mark -
#pragma mark Setup App Tabs / Splits

- (void)setupSplitViews {
    
    NSMutableArray *tabViewControllers = [[NSMutableArray alloc] initWithCapacity:3];
    
    //first tab (IntelligentSplitViewController)
    UISplitViewController *vc1 = [self.tab1VC splitViewController];
    
    UITabBarItem *tempTab1 = [[UITabBarItem alloc] initWithTitle:@"Textos"
                                                           image:[UIImage imageNamed:@"96-book.png"]
                                                             tag:0];
    vc1.tabBarItem = tempTab1;
    
    [tabViewControllers addObject:vc1];
    
    //second tab (IntelligentSplitViewController)
    UISplitViewController *vc2 = [self.tab2VC splitViewController];
    
    UITabBarItem *tempTab2 = [[UITabBarItem alloc] initWithTitle:@"Questionários"
                                                           image:[UIImage imageNamed:@"117-todo.png"]
                                                             tag:1];
    vc2.tabBarItem = tempTab2;
    [tabViewControllers addObject:vc2];
    
    //third tab (UIViewController)
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.tab3VC];
    //UIViewController *vc3 = self.tab3VC;
    
    UITabBarItem *tempTab3 = [[UITabBarItem alloc] initWithTitle:@"Info"
                                                           image:[UIImage imageNamed:@"Alert.png"]
                                                             tag:2];
    nav.tabBarItem = tempTab3;
    
    
    [tabViewControllers addObject:nav];
    [self.tabBarController setViewControllers:tabViewControllers];
    self.tabBarController.delegate = self;
    
    
}

#pragma mark -
#pragma mark Application lifecycle


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [[LocalyticsSession sharedLocalyticsSession] startSession:APP_KEY];
    [DRSSaudeSexualIAPHelper sharedInstance];
    
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        application.statusBarOrientation = UIInterfaceOrientationLandscapeRight;
        [self setupSplitViews];
        self.window.rootViewController = self.tabBarController;
        [self.window makeKeyAndVisible];
        
    } else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0")){
        [self customizeiPhoneTheme];
    }
    
    
    
    NSString *rateUrl = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=1&type=Purple+Software", APP_ID];
    
    [[RateSuggestService sharedService] setSuggestInterval:7];
    [[RateSuggestService sharedService] setRateUrl:rateUrl];
    [[RateSuggestService sharedService] setAlertTitle:NSLocalizedString(@"Dar nota ao aplicativo", nil)
                                                 body:NSLocalizedString(@"Você se importaria em gastar um instante para dar uma nota ao app SaúdeSexual Free?", nil)
                                            buttonYes:NSLocalizedString(@"Sim", nil)
                                             buttonNo:NSLocalizedString(@"Não, obrigado", nil)];
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Application entering background: save");
    [[AppModel sharedModel] saveChangesToDataStore];
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [[RateSuggestService sharedService] check];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Close Localytics Session
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	NSLog(@"LOW_MEMORY_WARNING");
}

- init {
	if ((self = [super init])) {
		// initialize  to nil
		//mainWindow = nil;
	}
	return self;
}




- (void) disableLeftBarButtonItemOnNavbar:(BOOL)disable
{
    static UILabel *l = nil;
    
    if (disable) {
        if (l != nil)
            return;
        l = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 160, 44)];
        l.backgroundColor = [UIColor clearColor];
        l.userInteractionEnabled = YES;
        [self.window addSubview:l];
    }
    else {
        if (l == nil)
            return;
        [l removeFromSuperview];
        
        l = nil;
    }
}

-(void)customizeiPhoneTheme
{
    [[UIApplication sharedApplication]
     setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    UIImage *navBarImage = [[UIImage tallImageNamed:@"menubar.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 15, 5, 15)];
    
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor blackColor]];
                         
    UIImage *barButton = [[UIImage tallImageNamed:@"menubar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 4, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    UIImage *backButton = [[UIImage tallImageNamed:@"back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 4)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
//    
//    UIImage *minImage = [UIImage tallImageNamed:@"ipad-slider-fill"];
//    UIImage *maxImage = [UIImage tallImageNamed:@"ipad-slider-track.png"];
//    UIImage *thumbImage = [UIImage tallImageNamed:@"ipad-slider-handle.png"];
//    
//    [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
//    [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
//    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
//    [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateHighlighted];
    
    UIImage* tabBarBackground = [UIImage tallImageNamed:@"tabbar.png"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage tallImageNamed:@"tabbar-active.png"]];
    
}




@end
