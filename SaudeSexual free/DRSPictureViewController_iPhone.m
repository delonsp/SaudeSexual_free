//
//  DRSPictureViewController_iPhone.m
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 16/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSPictureViewController_iPhone.h"

@implementation DRSPictureViewController_iPhone
@synthesize image;
@synthesize myView;
@synthesize sv;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Voltar"
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    sv.minimumZoomScale=0.5;
    sv.maximumZoomScale=2.0;
    sv.delegate=self;
 
    UIImage *aImage = [UIImage imageNamed:image];
    myView = [[UIImageView alloc] initWithImage:aImage];
    sv.contentSize=aImage.size;
    [self.sv addSubview:myView];
    myView.frame = CGRectMake(0, 0, 320, 460);
    myView.contentMode = UIViewContentModeScaleAspectFit;
        
}


- (void)viewDidUnload
{
    
    image = nil;
    myView = nil;
    sv = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - ScrollView delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.myView;
}

@end
