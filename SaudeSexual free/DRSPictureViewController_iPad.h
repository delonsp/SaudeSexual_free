//
//  DRSPictureViewController_iPad.h
//  SaudeSexual
//
//  Created by Alain Dutra on 24/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSPictureViewController_iPhone.h"
#import "DRSAppDelegate.h"

@interface DRSPictureViewController_iPad : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *sv;
@property (copy, nonatomic) NSString *image;
@property (strong, nonatomic) IBOutlet UIImageView *myView;

@end
