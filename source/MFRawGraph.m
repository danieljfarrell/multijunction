//
//  rawGraph.m
//  EL Lab
//
//  Created by Markus Führer on 24/02/2009.
//  Copyright 2009 Imperial College. All rights reserved.
//

#import "MFRawGraph.h"
#import <math.h>
#define margin 50
#define SHIFT 20

void logRect(NSRect theRect) {
	NSLog(@"rect x:%f->%f,y:%f->%f, width: %f, height: %f",
	theRect.origin.x, theRect.size.width +theRect.origin.x,
	theRect.origin.y, theRect.origin.y+theRect.size.height,
		  theRect.size.width, theRect.size.height);
}


@implementation MFRawGraph

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
		hasData = NO;
//		NSRect canvas = [self bounds];
		
		displayedDataBounds = NSMakeRect(0,0,0,0);
		fullDataBounds = NSMakeRect(0,0,0,0);
		
		customDataRange = NO;

		leftMargin = 10;
		rightMargin = 10;
		topMargin = 10;
		bottomMargin = 40;

		[self updatePlotRect];
		
		data = [[[NSMutableDictionary alloc]init]retain];
		
    NSColor *bkgrd = [NSColor colorWithCalibratedWhite:1.0 alpha:1.0];
		[self setBackgroundColour:bkgrd];
		[self setAxesColour: [NSColor blackColor]];
		[self setLabelsColour: [NSColor grayColor]];
		[self setTitle:@"untitled"];
		[self setXLabel:@"x label"];
		[self setYLabel: @"y label"];
		
		logx = NO;
		logy = NO;
		
		[self setXTickFormatString: @"%.2f"];
		[self setYTickFormatString: @"%.2f"];

		
		[self setXLabelAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[NSFontManager sharedFontManager]
							fontWithFamily:@"Arial"
							traits:NSNarrowFontMask | NSUnboldFontMask
							weight:2 size:12], NSFontAttributeName,
							[NSColor blackColor], NSForegroundColorAttributeName, nil]];
		
		[self setYLabelAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[[NSFontManager sharedFontManager]
																	   fontWithFamily:@"Arial"
																	   traits:NSNarrowFontMask | NSUnboldFontMask
																	   weight:2 size:12], NSFontAttributeName,
							[NSColor blackColor], NSForegroundColorAttributeName, nil]];
		
		[self setTitleAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[[NSFontManager sharedFontManager]
																			 fontWithFamily:@"Arial"
																			 traits:NSNarrowFontMask | NSUnboldFontMask
																			 weight:2 size:20], NSFontAttributeName,
								  [NSColor blackColor], NSForegroundColorAttributeName, nil]];
		
		[self setSimpleSinPlot];
		

    }
    return self;
}

#pragma mark add and remove data


- (void) setSimpleSinPlot {
	
	[self clear];
	
	NSMutableData * newDataset = [MFRawGraph NSMutableDataWithCoordinates: 100] ;
	double ** temp = [newDataset mutableBytes];
	
	
	double * x = temp[0];
	double * y = temp[1];
	int i; 
	
	for (i=0; i< y-x; i++) {
		x[i] = 0.1*i;
		y[i] = 10*sin(x[i]);
	}
	//		logy = YES;
	//		logx = NO;
	
	[self addDataWithLegendEntry:@"sin" andDataObject:newDataset andColour:[NSColor blueColor] andLinewidth:1];
	[self setTitle:@"10 * sin (x)"];
	[self estimateMargins];

}


- (void) clear {
	hasData = NO;
	[data release];
	data = [[[NSMutableDictionary alloc]init]retain];
}


- (void) addDataWithLegendEntry: (NSString *) theName andDataObject: (NSMutableData *) theData andColour: (NSColor *) theColour andLinewidth: (double) theLW {

	[data setValue:
			[NSDictionary dictionaryWithObjectsAndKeys:
				[theData retain], @"data",
				[theName retain], @"title",
				[theColour retain], @"colour",
				[NSNumber numberWithDouble:theLW],@"linewidth", 
			 nil]
			forKey: [theName retain]
	];
	hasData = YES;
	
	if (!customDataRange)
		[self updateDataRect];

}


- (void) deleteDataWithLegendEntry: (NSString *) theName {
	[data removeObjectForKey: theName];
	if (!customDataRange)
		[self updateDataRect];
}

- (void) setLogX: (BOOL) newlogx logY: (BOOL) newlogy {
	logx = newlogx;
	logy = newlogy;
	[self updateDataRect];
}

- (void) shade1WithBoundary: (double) xCutoff andColour: (NSColor *) colour {
  shade1 = YES;
  colour1 = colour;
  x1cutoff = xCutoff;
  shade2 = NO;
  shade3 = NO;
}

- (void) shade2WithBoundary: (double) xCutoff andColour: (NSColor *) colour {
  shade2 = YES;
  colour2 = colour;
  x2cutoff = xCutoff;
  shade3 = NO;
}

- (void) shade3WithBoundary: (double) xCutoff andColour: (NSColor *) colour {
  shade3 = YES;
  colour3 = colour;
  x3cutoff = xCutoff;
}


#pragma mark deal with data bounds

- (void) overrideAutomaticDataRect: (NSRect) newDataRect{
	displayedDataBounds = newDataRect;
	customDataRange = YES;
	[self updateAffineTransform];
}


- (void) updateDataRect {
	[self calculateDataBounds];
	
	logRect(fullDataBounds);
	displayedDataBounds = [self growRectToNiceBounds:fullDataBounds];
	
	[self updateAffineTransform];
}


- (void) calculateDataBounds {
	
	float minx, maxx,miny, maxy;
	NSMutableData * tempDataObject;
	double ** cDataObject;
	double *x, *y;
	int nPoints;
	
	BOOL firstRun = YES;
	
	
	for (NSString * dataString in [data keyEnumerator]) {
		NSLog(@"%@", dataString);
		NSDictionary * dataSet = [data objectForKey:dataString];
		tempDataObject = [dataSet valueForKey:@"data"];
		cDataObject = (double **) [tempDataObject bytes];
		x = cDataObject[0];
		y = cDataObject[1];
		nPoints = y-x;
		
		if (firstRun) {
			minx = x[0];
			maxx = x[0];
			miny = y[0];
			maxy = y[0];
			
			firstRun = NO;
		}		
		int j;
		
		
		// find good values for minimum and maximum. 
		// if plotting logs, you cannot have negative or zero as these values, 
		// so if one of min values is negative, replace it even if the new value
		// is larger: (miny<=0 && logy)
		// otherwise, even if the new value is smaller, and you're plotting logs, 
		// only replace the min if the value is positive: &&(x[j]>0 || !logx)
		
		
		for (j=0;j<nPoints; j++) {
			if (y[j] > maxy && (y[j]>0 || !logy))
				maxy = y[j];
			if ((miny<=0 && logy) || (y[j] < miny && (y[j]>0 || !logy))) 
				miny = y[j];
			if ((minx<=0 && logx) || (x[j] < minx && (x[j]>0 || !logx)))
				minx = x[j];
			if (x[j] > maxx && (x[j]>0 || !logx))
				maxx = x[j];
		}
	}
	
	fullDataBounds = NSMakeRect(minx,miny, maxx-minx, maxy-miny);
	logRect(fullDataBounds);
}


- (NSRect) growRectToNiceBounds: (NSRect) oldRect {
	NSLog(@"Growing from:");
	logRect (oldRect);

	float xmin, xmax, ymin, ymax, xMagnitude, yMagnitude;
	
	xmin = oldRect.origin.x;
	ymin = oldRect.origin.y;	
	xmax = oldRect.size.width+oldRect.origin.x;
	ymax = oldRect.size.height+oldRect.origin.y;	
	
	
	if (logx) {
		xmin = floor (log10(xmin));
		xmax = ceil (log10(xmax));
	}else{
	
		xMagnitude = pow(10,floor(log10(oldRect.size.width)));
		xmin = floor(xmin/xMagnitude)*xMagnitude;;
		xmax = ceil(xmax/xMagnitude)*xMagnitude;;
	}
	
	if (logy) {
		ymin = floor (log10(ymin));
		ymax = ceil (log10(ymax));
	}else{
		yMagnitude = pow(10,floor(log10(oldRect.size.height)));	
		ymin = floor(ymin/yMagnitude)*yMagnitude;
		ymax = ceil(ymax/yMagnitude)*yMagnitude;;
	}
	
	NSLog(@"To:");
	logRect (NSMakeRect(xmin, ymin, xmax-xmin, ymax-ymin));

	return NSMakeRect(xmin, ymin, xmax-xmin, ymax-ymin);

}

- (void) updateAffineTransform {
	
	CGAffineTransform shiftToPlotRect = CGAffineTransformMakeTranslation(plotRect.origin.x, plotRect.origin.y);
	CGAffineTransform scaleToScreen = CGAffineTransformScale(shiftToPlotRect, plotRect.size.width/(displayedDataBounds.size.width), plotRect.size.height/(displayedDataBounds.size.height)); // rescale to screen
	dataToPlot = CGAffineTransformTranslate (scaleToScreen, -displayedDataBounds.origin.x, -displayedDataBounds.origin.y); // data to origin
}	

#pragma mark draw the data onto the screen

- (NSPoint) canvasCoordinatesOfDataPointWithX: (float) x andY: (float) y {

	float X,Y;
	
	if (logy)
		Y = log10(y);
	else
		Y = y;
	
	if (logx)
		X = log10(x);
	else
		X = x;
	
	return NSPointFromCGPoint ( CGPointApplyAffineTransform(CGPointMake(X,Y), dataToPlot));		
}

- (int) estimateNumberOfPrettyXTicks {
	return 10;	
}
- (int) estimateNumberOfPrettyYTicks {
	return 10;	
}

- (void)drawRect:(NSRect)rect {

    if ([self inLiveResize])
		[self updatePlotRect];
	
	NSRect canvas = [self bounds];
	
	[backgroundColour set];
	NSRectFill(canvas);

	[axesColour set];
	NSFrameRectWithWidth(plotRect,1.0);
	

	NSBezierPath * path = [NSBezierPath bezierPath];
	/*

	 CGPoint bottomLeft = CGPointApplyAffineTransform(CGPointMake(displayedDataBounds.origin.x, displayedDataBounds.origin.y),dataToPlot);
	 CGPoint topRight = CGPointApplyAffineTransform(CGPointMake(displayedDataBounds.origin.x+displayedDataBounds.size.width, displayedDataBounds.origin.y+displayedDataBounds.size.height),dataToPlot);
	 
	[path moveToPoint:[self canvasCoordinatesOfDataPointWithX:displayedDataBounds.origin.x andY:displayedDataBounds.origin.y]];
	[path lineToPoint:[self canvasCoordinatesOfDataPointWithX:displayedDataBounds.origin.x+displayedDataBounds.size.width andY:displayedDataBounds.origin.y]];
	[path lineToPoint:[self canvasCoordinatesOfDataPointWithX:displayedDataBounds.origin.x+displayedDataBounds.size.width andY:displayedDataBounds.origin.y+displayedDataBounds.size.height]];
	[path lineToPoint:[self canvasCoordinatesOfDataPointWithX:displayedDataBounds.origin.x andY:displayedDataBounds.origin.y+displayedDataBounds.size.height]];
	[path lineToPoint:[self canvasCoordinatesOfDataPointWithX:displayedDataBounds.origin.x andY:displayedDataBounds.origin.y]];

	[axesColour set];
	[path stroke];
	[path stroke];*/
	
	NSMutableData * tempDataObject;
	double ** cDataObject;
	double *x, *y;
	int nPoints,j;


	
	double tickDataValue, tickPlotValue, min, max, step;
	
	double miny = plotRect.origin.y;
	double maxy = plotRect.origin.y+plotRect.size.height;
	double minx = plotRect.origin.x;
	double maxx = plotRect.origin.x+plotRect.size.width;
	
	[axesColour set];
	
	NSSize xTickTextSize;
	NSSize yTickTextSize;
	
	// x:
	min = displayedDataBounds.origin.x;
	max = displayedDataBounds.size.width+displayedDataBounds.origin.x;
	step = displayedDataBounds.size.width/[self estimateNumberOfPrettyXTicks];
	
	if (logx)
		step =1;
	
	for (tickDataValue=min; tickDataValue<= max && hasData; tickDataValue+= step) {
		tickPlotValue = CGPointApplyAffineTransform(CGPointMake(tickDataValue, miny),dataToPlot).x;

		if (tickDataValue != min && tickDataValue != max) {
			path = [NSBezierPath bezierPath];
			[path moveToPoint:NSMakePoint(tickPlotValue, miny)];
			[path lineToPoint:NSMakePoint(tickPlotValue, miny+10)];
			[path stroke];
			
			[path moveToPoint:NSMakePoint(tickPlotValue, maxy)];
			[path lineToPoint:NSMakePoint(tickPlotValue, maxy-10)];
			[path stroke];
		
		}
		if (logx) {
			xTickTextSize = [[NSString stringWithFormat:xTickFormatString,pow(10,tickDataValue)] sizeWithAttributes:xLabelAttributes];
			[[NSString stringWithFormat:xTickFormatString,pow(10,tickDataValue)] drawAtPoint:NSMakePoint(tickPlotValue-xTickTextSize.width/2, miny-10-xTickTextSize.height) withAttributes:xLabelAttributes];

		} else {
		
			xTickTextSize = [[NSString stringWithFormat:xTickFormatString,tickDataValue] sizeWithAttributes:xLabelAttributes];
			[[NSString stringWithFormat:xTickFormatString,tickDataValue] drawAtPoint:NSMakePoint(tickPlotValue-xTickTextSize.width/2, miny-10-xTickTextSize.height) withAttributes:xLabelAttributes];
		}
	}

	
	// y:
	min = displayedDataBounds.origin.y;
	max = displayedDataBounds.size.height+displayedDataBounds.origin.y;
	step = displayedDataBounds.size.height/[self estimateNumberOfPrettyYTicks];
	if (logy)
		step = 1;
	
	for (tickDataValue=min; tickDataValue<= max && hasData; tickDataValue+= step) {
		tickPlotValue = CGPointApplyAffineTransform(CGPointMake(minx,tickDataValue),dataToPlot).y;		
		if (tickDataValue != min && tickDataValue != max) {

			path = [NSBezierPath bezierPath];

			[path moveToPoint:NSMakePoint(minx, tickPlotValue)];
			[path lineToPoint:NSMakePoint(minx+10, tickPlotValue)];
			[path stroke];
			
			[path moveToPoint:NSMakePoint(maxx, tickPlotValue)];
			[path lineToPoint:NSMakePoint(maxx-10, tickPlotValue)];
			[path stroke];
		}
		
		if (logy) {
			yTickTextSize = [[NSString stringWithFormat:yTickFormatString,pow(10,tickDataValue)] sizeWithAttributes:yLabelAttributes];
			[[NSString stringWithFormat:yTickFormatString,pow(10,tickDataValue)] drawAtPoint:NSMakePoint(minx-yTickTextSize.width-10,tickPlotValue- yTickTextSize.height/2) withAttributes:yLabelAttributes];
		} else {
			yTickTextSize = [[NSString stringWithFormat:yTickFormatString,tickDataValue] sizeWithAttributes:yLabelAttributes];
			[[NSString stringWithFormat:yTickFormatString,tickDataValue] drawAtPoint:NSMakePoint(minx-yTickTextSize.width-10,tickPlotValue- yTickTextSize.height/2) withAttributes:yLabelAttributes];

		}
	}
	
	
  NSBezierPath * Area1 = [NSBezierPath bezierPath];
  NSBezierPath * Area2 = [NSBezierPath bezierPath];
  NSBezierPath * Area3 = [NSBezierPath bezierPath];
	
	for (NSString * dataString in [data keyEnumerator]) {
//		NSLog(@"%@", dataString);
		NSDictionary * dataSet = [data objectForKey:dataString];
		path = [NSBezierPath bezierPath];
		tempDataObject = [dataSet objectForKey:@"data"];
		cDataObject = (double **) [tempDataObject bytes];

		[path setLineWidth: [[dataSet valueForKey:@"linewidth"] floatValue]];
		[[dataSet valueForKey:@"colour"] set];
		
		x = cDataObject[0];
		y = cDataObject[1];
		nPoints = y-x;
		[path  moveToPoint: [self canvasCoordinatesOfDataPointWithX:x[0] andY:y[0]]];
    
    //top cell
    [Area1  moveToPoint: [self canvasCoordinatesOfDataPointWithX:x1cutoff andY:0]];
		[Area1  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x1cutoff andY:y[0]]];
    
    //middle cell
    [Area2  moveToPoint: [self canvasCoordinatesOfDataPointWithX:x2cutoff andY:0]];
		[Area2  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x2cutoff andY:y[0]]];
    
    //bottom cell
    [Area3  moveToPoint: [self canvasCoordinatesOfDataPointWithX:x3cutoff andY:0]];
		[Area3  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x3cutoff andY:y[0]]];
    
    /*
    //top cell
    [Area1  moveToPoint: [self canvasCoordinatesOfDataPointWithX:x[0] andY:0]];
		[Area1  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x[0] andY:y[0]]];
    
    //middle cell
    [Area2  moveToPoint: [self canvasCoordinatesOfDataPointWithX:x1cutoff andY:0]];
		[Area2  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x1cutoff andY:y[0]]];
    
    //bottom cell
    [Area3  moveToPoint: [self canvasCoordinatesOfDataPointWithX:x2cutoff andY:0]];
		[Area3  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x2cutoff andY:y[0]]];
    
    */
    
		for (j=1; j < nPoints; j++) {
      
      if ( x[j] < (displayedDataBounds.origin.x))
          continue;
      
      if ( x[j] > (displayedDataBounds.size.width+displayedDataBounds.origin.x))
          break;
          
			[path lineToPoint:[self canvasCoordinatesOfDataPointWithX:x[j] andY:y[j]]];
      
      if ( x[j] >= x1cutoff)
        [Area1  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x[j] andY:y[j]]];
        
      if ( (x[j] >= x2cutoff) && (x[j] < x1cutoff))
        [Area2  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x[j] andY:y[j]]];
        
      if ( (x[j] >= x3cutoff) && (x[j] < x2cutoff))
        [Area3  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x[j] andY:y[j]]];
      
		}
/*
    [Area1  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x1cutoff andY:0]];
    [Area1  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x[0] andY:0]];
    
    [Area2  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x2cutoff andY:0]];
    [Area2  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x1cutoff andY:0]];
    
    [Area3  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x3cutoff andY:0]];
    [Area3  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x2cutoff andY:0]];
		
*/    
    
  //  [Area1  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x1cutoff andY:0]];
  //  [Area1  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x[0] andY:0]];
    
    [Area2  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x1cutoff andY:0]];
  //  [Area2  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x1cutoff andY:0]];
    
    [Area3  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x2cutoff andY:0]];
  //  [Area3  lineToPoint: [self canvasCoordinatesOfDataPointWithX:x2cutoff andY:0]];
		
    
    [path stroke];
    
    [colour1 set];
    if (shade1)
      [Area1 fill];
    [colour2 set];
    if (shade2)
      [Area2 fill];
    [colour3 set];
    if (shade3)
      [Area3 fill];

	}
	
	NSSize xLabelTextSize = [xLabel sizeWithAttributes:xLabelAttributes];
	NSSize yLabelTextSize = [yLabel sizeWithAttributes:yLabelAttributes];
	NSSize titleTextSize = [title sizeWithAttributes:titleAttributes];

	[xLabel drawAtPoint:NSMakePoint(plotRect.size.width/2+plotRect.origin.x-xLabelTextSize.width/2, plotRect.origin.y-20-yTickTextSize.height-xLabelTextSize.height) withAttributes:xLabelAttributes];
	[yLabel drawAtPoint:NSMakePoint(plotRect.origin.x-yLabelTextSize.width-20 - yTickTextSize.width, plotRect.origin.y+plotRect.size.height/2) withAttributes:yLabelAttributes];
	[title drawAtPoint:NSMakePoint(plotRect.size.width/2+plotRect.origin.x - titleTextSize.width/2, plotRect.origin.y+ plotRect.size.height +20) withAttributes:titleAttributes];
	
}

#pragma mark deal with plot bounds

- (void) estimateMargins {
	
	
	NSSize xLabelTextSize = [xLabel sizeWithAttributes:xLabelAttributes];
	NSSize yLabelTextSize = [yLabel sizeWithAttributes:yLabelAttributes];
	NSSize titleTextSize = [title sizeWithAttributes:titleAttributes];
	NSSize xTickTextSize, yTickTextSize;
	
	if (logx) {
		xTickTextSize = [[NSString stringWithFormat:xTickFormatString,pow(10,displayedDataBounds.origin.x)] sizeWithAttributes:xLabelAttributes];
	} else {
		xTickTextSize = [[NSString stringWithFormat:xTickFormatString,displayedDataBounds.origin.x] sizeWithAttributes:xLabelAttributes];
	}
	
	if (logy) {
		yTickTextSize = [[NSString stringWithFormat:yTickFormatString,pow(10,displayedDataBounds.origin.y)] sizeWithAttributes:yLabelAttributes];
	} else {
		yTickTextSize = [[NSString stringWithFormat:yTickFormatString,displayedDataBounds.origin.y] sizeWithAttributes:yLabelAttributes];
	}
	
	bottomMargin = 20 + xTickTextSize.height + xLabelTextSize.height;
	
	leftMargin = 40 + yTickTextSize.width + yLabelTextSize.width;
	
	topMargin = 20 +titleTextSize.height;
	rightMargin = 10 + xTickTextSize.width/2;
	
	[self updatePlotRect];
}


- (void) setMarginsTop: (int) tm bottom: (int) bm left: (int) lm right: (int) rm{
	leftMargin = lm;
	rightMargin = rm;
	topMargin = tm;
	bottomMargin = bm;
	[self updatePlotRect];
}

- (void) updatePlotRect {
	NSRect canvas = [self bounds];
	plotRect = NSMakeRect ( canvas.origin.x+leftMargin,
						   canvas.origin.y+bottomMargin,
						   canvas.size.width-leftMargin - rightMargin,
						   canvas.size.height-topMargin -bottomMargin);
	[self updateAffineTransform];
	
}



#pragma mark support functions to allocate and deallocate data sets


+ (NSMutableData *) NSMutableDataWithCoordinates: (int) nPoints {
	return [NSMutableData dataWithBytes:[self mallocDatasetWithCoordinates:nPoints] length:nPoints*sizeof(double)+2*sizeof(double *)];
}

+ (double **) mallocDatasetWithCoordinates: (int) nPoints {
	// create 2d dataset result[x=0 y=1][i]
	// so: double * x = result[0]
	//     double * y = result[1]
	// and things like the n-th x-coordinate double nx = result[0][n]
	// the number of points in the dataset = y-x
	
	// we need space for n x-coordinates, n y-coordinates 
	// as well as 1 pointer to the start of the x-array, and one to the start of the y array.
	// as this is only one malloc, you only need one free.
	double ** result = (double **) malloc (2*nPoints*sizeof (double) + 2 * sizeof (double *));
	
	// create the pointers to the beginning of the individual coordinate sets:
	 // start of x-coordinates: dataset pointer plus 2 * size of coordinate-set pointer 
	result[0] = (double *) (result+2); 
	 // start of y-coordinates: dataset pointer plus 2 * size of coordinate-set pointer + skip the n x-coordinates
	result[1] = (double *) (result+2) + nPoints; 

	return result;
}

+ (void) freeDataset: (double **) theDatasetToFree {
	// frees stuff passed to it, must be able to cope with datasets from mallocDatasetWithCoordinates
	free(theDatasetToFree);
}
	
#pragma mark synthesize properties

@synthesize backgroundColour;
@synthesize axesColour;
@synthesize labelsColour;
@synthesize title;
@synthesize xLabel;
@synthesize yLabel;
@synthesize xTickFormatString;
@synthesize yTickFormatString;
@synthesize xLabelAttributes;
@synthesize yLabelAttributes;
@synthesize titleAttributes;
@synthesize leftMargin;
@synthesize rightMargin;
@synthesize topMargin;
@synthesize bottomMargin;
@synthesize plotRect;

@end
