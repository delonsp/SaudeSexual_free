//
//  DRSPictureViewController_iPad.m
//  SaudeSexual
//
//  Created by Alain Dutra on 24/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSPictureViewController_iPad.h"

@interface DRSPictureViewController_iPad ()

@end

@implementation DRSPictureViewController_iPad
@synthesize image;
@synthesize sv;
@synthesize myView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    sv.minimumZoomScale=0.5;
    sv.maximumZoomScale=2.0;
    sv.delegate=self;
    
    UIImage *aImage = [UIImage imageNamed:image];
    myView = [[UIImageView alloc] initWithImage:aImage];
    sv.contentSize=aImage.size;
    [self.sv addSubview:myView];
    myView.frame = CGRectMake(0, 0, 640, 600);
    myView.contentMode = UIViewContentModeScaleAspectFit;
    
    
	DRSAppDelegate *appDelegate = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
    UINavigationController *nvc = [appDelegate masterNavigationController];
    UIViewController *vc = [nvc.viewControllers lastObject];
    [vc.navigationItem setHidesBackButton:YES];
    
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DRSAppDelegate *appDelegate = (DRSAppDelegate *) [[UIApplication sharedApplication] delegate];
    UINavigationController *nvc = [appDelegate masterNavigationController];
    UIViewController *vc = [nvc.viewControllers lastObject];
    [vc.navigationItem setHidesBackButton:NO];
}

- (void)viewDidUnload
{
    [self setMyView:nil];
    image = nil;
    [self setSv:nil];
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - ScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.myView;
}

@end
