//
//  DRSBarGraphViewController.h
//  SaudeSexual
//
//  Created by Alain Dutra on 30/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"
#import "Quest.h"

@interface DRSBarGraphViewController : UIViewController<CPTBarPlotDataSource, CPTBarPlotDelegate>{
    AppModel *model;
}
@property (nonatomic, strong) IBOutlet CPTGraphHostingView *hostView;
@property (nonatomic, copy) NSString *graphName;
@property (nonatomic, strong) CPTBarPlot *myPlot;
@property (nonatomic, strong) CPTPlotSpaceAnnotation *resultAnnotation;
@property (nonatomic, strong) NSArray *lastThreeResultsArray;
@property (nonatomic, strong) NSArray *lastThreeDatesArray;

-(void)initPlot;
-(void)configureGraph;
-(void)configurePlots;
-(void)configureAxes;
-(void) configureData;
-(void)hideAnnotation:(CPTGraph *)graph;
-(CGFloat) defineYMaxBasedOnTypeOfQuestionnaire: (NSString *) graph;
-(NSUInteger) yMajorIncrement;
-(NSUInteger) yMinorIncrement;
-(void)barPlot:(CPTBarPlot *)plot resultForRecordIndex:(NSUInteger)index;
-(NSString *) configureAnswersWithIndex: (NSUInteger) index;

@end
