//
//  DRSPictureViewController_iPhone.h
//  SaudeSexual
//
//  Created by Alain Machado da Silva Dutra on 16/04/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRSPictureViewController_iPhone : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *myView;
@property (copy, nonatomic) NSString *image;
@property (strong, nonatomic) IBOutlet UIScrollView *sv;

@end
