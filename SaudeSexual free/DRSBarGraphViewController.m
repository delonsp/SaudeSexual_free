//
//  DRSBarGraphViewController.m
//  SaudeSexual
//
//  Created by Alain Dutra on 30/06/12.
//  Copyright (c) 2012 DrSolution. All rights reserved.
//

#import "DRSBarGraphViewController.h"

@interface DRSBarGraphViewController ()

@end

@implementation DRSBarGraphViewController

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 0.25f;

@synthesize hostView    = hostView_;
@synthesize myPlot = myPlot_;
@synthesize resultAnnotation = resultAnnotation_;
@synthesize graphName = graphName_;
@synthesize lastThreeResultsArray;
@synthesize lastThreeDatesArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - UIViewController lifecycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:SELECTED_SPECIFIC_ANTERIOR_RESULT_IN_IPHONE];
    self.navigationItem.title = @"Comparativo";
	if (self.graphName) {
        [self initPlot];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.hostView    = nil;
    self.myPlot = nil;
    self.resultAnnotation = nil;
    self.graphName = nil;
    self.lastThreeResultsArray = nil;
    self.lastThreeDatesArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Chart behavior
-(void)initPlot {
    self.hostView.allowPinchScaling = NO;
    [self configureData];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];    
}

- (void) configureData {
    model = [AppModel sharedModel];
    [model getObjectsFromDataStore];
    if (self.graphName) {
        
        // Get the last three objects from dataStore which correspond to the self.graphName (name of questionnaire),
        // using NSPredicate
        
        NSMutableArray *rawArray;
        NSMutableArray *filteredArray;
        filteredArray = [[NSMutableArray alloc] initWithCapacity:3];
        rawArray = [[NSMutableArray alloc] initWithArray:model.listOfAnswers];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quest == %@",self.graphName];
        [rawArray filterUsingPredicate:predicate];
        
        int i=0;
        if (rawArray.count < 3)
            i=rawArray.count;
        else i=3;
        
        for (int j=0; j<i; j++) {
            [filteredArray insertObject:[rawArray lastObject] atIndex:j];
            [rawArray removeLastObject];
        }
        
        if (filteredArray.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Você nunca fez este questionário antes !"
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }

                
        
        // Get the filteredArray with the last three or less questionnaires objects and extract 2 new arrays:
        // 1- Array with only numbers for posterior plotting
        // 2- Array with the dates for putting in X axis
        
        NSMutableArray *numbersArray = [[NSMutableArray alloc] initWithCapacity:filteredArray.count];
        NSMutableArray *datesArray = [[NSMutableArray alloc] initWithCapacity:filteredArray.count];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/YY"];
        
        for (Quest *quest in filteredArray) {
            [numbersArray addObject: [NSNumber numberWithInt:[quest.result integerValue]]];
            [datesArray addObject:[dateFormat stringFromDate:quest.data]];
        }
        
        self.lastThreeResultsArray = numbersArray;
        self.lastThreeDatesArray = datesArray;
        
        

                
        NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc] init];
        
        [dateFormat2 setTimeStyle:NSDateFormatterShortStyle];
    }
}

-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    graph.plotAreaFrame.masksToBorder = NO;
    self.hostView.hostedGraph = graph;    
    // 2 - Configure the graph    
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];    
    graph.paddingBottom = 30.0f;      
    graph.paddingLeft  = 30.0f;
    graph.paddingTop    = -1.0f;
    graph.paddingRight  = -5.0f;
    // 3 - Set up styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    // 4 - Set up title
    NSString *title = [NSString stringWithFormat:@"%@ - Últimos três resultados.",self.graphName];
    graph.title = title;  
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -16.0f);
    // 5 - Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xMax = 3.0f;
    CGFloat yMin = 0.0f;
    CGFloat yMax = [self defineYMaxBasedOnTypeOfQuestionnaire:self.graphName];  // should determine dynamically based on type of questionnaire (graph)
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin) length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin) length:CPTDecimalFromFloat(yMax)];
}

-(CGFloat) defineYMaxBasedOnTypeOfQuestionnaire: (NSString *) graph {
    CGFloat result;
    if (self.graphName) {
        if ([self.graphName isEqualToString:IIEF]) {
            result = kMaxIIEF +3 ;
        } else if ([self.graphName isEqualToString:HSDD]) {
            result = kMaxHSDD +1;
        } else if ([self.graphName isEqualToString:OVP]) {
            result = kMaxOVP +3 ;
        } else {
            result = kMaxGENERIC +5;
        }
    }
    
    return result;
}

-(void)configurePlots {
    // 1 - Set up the plot
    self.myPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    self.myPlot.identifier = self.graphName;
    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5;
    CPTGraph *graph = self.hostView.hostedGraph;
    CGFloat barX = CPDBarInitialX;
    self.myPlot.dataSource = self;
    self.myPlot.delegate = self;
    self.myPlot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
    self.myPlot.barOffset = CPTDecimalFromDouble(barX);
    self.myPlot.lineStyle = barLineStyle;
    [graph addPlot:self.myPlot toPlotSpace:graph.defaultPlotSpace];
    barX += CPDBarWidth;
}

-(void)configureAxes {
    
    // 1 - Configure styles
    
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1];
    CPTMutableTextStyle *axisTextStyle =[[CPTMutableTextStyle alloc] init];
    axisTextStyle.color =[CPTColor whiteColor];
    axisTextStyle.fontName =@"Helvetica-Bold";    
    axisTextStyle.fontSize = 12.0f;
    CPTMutableLineStyle *tickLineStyle =[CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor =[CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle =[CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor =[CPTColor blackColor];
    tickLineStyle.lineWidth = 1.0f;
    
    // 2 - Get the graph's axis set
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
   
    
    // 3 - Configure the x-axis
    
    CPTAxis *x = axisSet.xAxis;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.title = @"Datas";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 17.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    CGFloat dateCount =[self.lastThreeDatesArray count];
    NSMutableSet *xLabels =[NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *xLocations =[NSMutableSet setWithCapacity:dateCount];
    NSInteger i = 0;
    for(NSString *date in self.lastThreeDatesArray) {
        CPTAxisLabel *label =[[CPTAxisLabel alloc] initWithText:date  textStyle:x.labelTextStyle];
        CGFloat location = i++;
        location = location + 0.25;
        label.tickLocation = CPTDecimalFromCGFloat(location);
        label.offset = x.majorTickLength;
        if(label){
            [xLabels addObject:label];
            [xLocations addObject:[NSNumber numberWithFloat:location]];                        
        }
    }
    
    x.axisLabels = xLabels;    
    x.majorTickLocations = xLocations;
           
    
     
    // 4 - Configure the y-axis
    
    CPTAxis *y = axisSet.yAxis;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.title = @"Nota";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset =-35.0f;     
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelTextStyle = axisTextStyle; 
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 4.0f;
    y.minorTickLength = 2.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = [self yMajorIncrement];
    NSInteger minorIncrement = [self yMinorIncrement];
    CGFloat yMax = [self defineYMaxBasedOnTypeOfQuestionnaire:self.graphName];
    NSMutableSet*yLabels =[NSMutableSet set];
    NSMutableSet*yMajorLocations =[NSMutableSet set];
    NSMutableSet*yMinorLocations =[NSMutableSet set];
    for(NSInteger j = minorIncrement; j <= yMax; j += minorIncrement){
        NSUInteger mod = j % majorIncrement;
        if(mod ==0){
            CPTAxisLabel *label =[[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%i", j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j); 
            label.tickLocation = location;
            label.offset =-y.majorTickLength - y.labelOffset;
            if(label){
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        }else{
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }}
    y.axisLabels = yLabels;    
    y.majorTickLocations = yMajorLocations; y.minorTickLocations = yMinorLocations;
}

-(NSUInteger) yMinorIncrement {
    NSUInteger y;
    if (self.graphName) {
        if ([self.graphName isEqualToString:IIEF] ||
            [self.graphName isEqualToString:HSDD] ||
            [self.graphName isEqualToString:OVP]) {
            y = 1 ;
        } else {
            y = 2;
        }
    }
    return y;
}

-(NSUInteger) yMajorIncrement {
    NSUInteger y;
    if (self.graphName) {
        if ([self.graphName isEqualToString:HSDD] ||
            [self.graphName isEqualToString:OVP]) {
            y = 2 ;
        } else {
            y = 5;
        }
    }
    return y;

}


-(void)hideAnnotation:(CPTGraph *)graph {
    if ((graph.plotAreaFrame.plotArea) && (self.resultAnnotation)) {
        [graph.plotAreaFrame.plotArea removeAnnotation:self.resultAnnotation];
        self.resultAnnotation = nil;
    }
}

#pragma mark - CPTPlotDataSource methods
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [self.lastThreeDatesArray count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    if ((fieldEnum == CPTBarPlotFieldBarTip) && (index < [self.lastThreeResultsArray count])) {
        
        [self barPlot:(CPTBarPlot *)plot resultForRecordIndex:index] ;
        return [self.lastThreeResultsArray objectAtIndex:index];
        
    }

    return [NSDecimalNumber numberWithUnsignedInteger:index];
}

//#pragma mark - CPTBarPlotDelegate methods
//-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
//    
//    // 1 - Is the plot hidden?
//    if (plot.isHidden == YES) {
//        return;
//    }
//    // 2 - Create style, if necessary
//   
//    static CPTMutableTextStyle *style = nil;
//    if (!style) {
//        style = [CPTMutableTextStyle textStyle];    
//        style.color= [CPTColor yellowColor];
//        style.fontSize = 16.0f;
//        style.fontName = @"Helvetica-Bold";
//        
//    }
//    // 3 - Create annotation, if necessary
//    NSNumber *note = [self numberForPlot:plot field:CPTBarPlotFieldBarTip recordIndex:index];
//    
//    if (!self.resultAnnotation) {
//        NSNumber *x = [NSNumber numberWithInt:0];
//        NSNumber *y = [NSNumber numberWithInt:0];
//        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
//        self.resultAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
//        
//    }
//    // 4 - Create number formatter, if needed
//    static NSNumberFormatter *formatter = nil;
//    if (!formatter) {
//        formatter = [[NSNumberFormatter alloc] init];
//        [formatter setMaximumFractionDigits:2];
//        
//    }
//    // 5 - Create text layer for annotation
//    NSString *noteValue = [formatter stringFromNumber:note];
//    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:noteValue style:style];
//    self.resultAnnotation.contentLayer = textLayer;
//    
//    // 6 - Get plot index based on identifier
//    // ** BY THE MOMENT ONLY ONE PLOT INDEX **
//    NSInteger plotIndex = 0;
//    
//    // 7 - Get the anchor point for annotation
//    CGFloat x = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
//    
//    NSNumber *anchorX = [NSNumber numberWithFloat:x];    
//    CGFloat y = [note floatValue] +2.0f;
//    
//    NSNumber *anchorY = [NSNumber numberWithFloat:y];    
//    self.resultAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
//    
//    
//    // 8 - Add the annotation 
//    [plot.graph.plotAreaFrame.plotArea addAnnotation:self.resultAnnotation];
//   
//    
//}

#pragma mark - CPTBarPlotDelegate methods

-(void)barPlot:(CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index {
    if (self.graphName) {
        if ([self.graphName isEqualToString:IIEF] ||
            [self.graphName isEqualToString:OVP] ||
            [self.graphName isEqualToString:HSDD]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:[self configureAnswersWithIndex:index]
                                                           delegate:nil cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

#pragma mark - If result equals zero

-(void) barPlot:(CPTBarPlot *)plot resultForRecordIndex:(NSUInteger)index {
    
    // 1 - Is the plot hidden?
    if (plot.isHidden == YES) {
        return;
    }
    // 2 - Create style, if necessary
    
    static CPTMutableTextStyle *style = nil;
    if (!style) {
        style = [CPTMutableTextStyle textStyle];
        style.color= [CPTColor yellowColor];
        style.fontSize = 16.0f;
        style.fontName = @"Helvetica-Bold";
        
    }
    // 3 - Create annotation, if necessary
    NSNumber *note = [self.lastThreeResultsArray objectAtIndex:index];
    NSNumber *x = [NSNumber numberWithInt:0];
    NSNumber *y = [NSNumber numberWithInt:0];
    NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
    CPTPlotSpaceAnnotation *resultAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint];
        
    
    
    // 4 - Create number formatter, if needed
    static NSNumberFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:2];
        
    }
    // 5 - Create text layer for annotation
    NSString *noteValue = [formatter stringFromNumber:note];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:noteValue style:style];
    resultAnnotation.contentLayer = textLayer;
    
    // 6 - Get plot index based on identifier
    // ** BY THE MOMENT ONLY ONE PLOT INDEX **
    NSInteger plotIndex = 0;
    
    // 7 - Get the anchor point for annotation
    CGFloat cx = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
    
    NSNumber *anchorX = [NSNumber numberWithFloat:cx];
    CGFloat cy = [note floatValue] +2.0f;
    
    NSNumber *anchorY = [NSNumber numberWithFloat:cy];
    resultAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    
    
    // 8 - Add the annotation
    [plot.graph.plotAreaFrame.plotArea addAnnotation:resultAnnotation];
}

-(NSString *) configureAnswersWithIndex: (NSUInteger) index {
   
    NSString *str, *str2;
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path =[bundle pathForResource:@"Resultados" ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    NSUInteger num = [[self.lastThreeResultsArray objectAtIndex:index] integerValue];
    NSDictionary *myDict;
    NSString *quest = self.graphName;
    
    if ([quest isEqualToString: OVP]) {
        myDict = [array objectAtIndex:2];
        if (num > 10)
            str2 = [myDict objectForKey:@"organ"];
        else
            str2 = [myDict objectForKey:@"psico"];
        str = [NSString stringWithFormat:@"O resultado foi de %@ pontos. Isto significa %@",
               [[self.lastThreeResultsArray objectAtIndex:index] stringValue], str2];
            
    } else if ([quest isEqualToString:IIEF]) {
        myDict = [array objectAtIndex:1];
        if (num <= 7) {
            str2 = [myDict objectForKey:@"severa"];
        } else if (num >= 8 && num <= 11){
            str2 = [myDict objectForKey:@"moderada"];
        } else if (num >=12 && num <= 16) {
            str2 = [myDict objectForKey:@"leve a moderada"];
        } else if (num >=17 && num <=21) {
            str2 = [myDict objectForKey:@"leve"];
        } else {
            str2 = [myDict objectForKey:@"ausência"];
        }
        str = [NSString stringWithFormat:@"O resultado foi de %@ pontos. Isto significa %@",
               [[self.lastThreeResultsArray objectAtIndex:index] stringValue], str2];
        
    } else if ([quest isEqualToString:HSDD]) {
        myDict = [array objectAtIndex:0];
        
        if (num <= 6) {
            str2 = [myDict objectForKey:@"normal"];
        } else {
            str2 = [myDict objectForKey:@"anormal"];
        }
        str = [NSString stringWithFormat:@"O resultado foi de %@ pontos. Isto significa %@",
               [[self.lastThreeResultsArray objectAtIndex:index] stringValue], str2];
    }
   
    return str;
            
}



@end
