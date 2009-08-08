//
//  rawGraph.h
//  EL Lab
//
//  Created by Markus Führer on 24/02/2009.
//  Copyright 2009 Imperial College. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MFRawGraph : NSView {
	
	NSRect displayedDataBounds;
	NSRect plotRect;
	NSRect fullDataBounds;
	
	float leftMargin, rightMargin, topMargin, bottomMargin;
	
	BOOL hasData;
	NSMutableDictionary * data;
	
	NSColor * backgroundColour;
	NSColor * axesColour;
	NSColor * labelsColour;

	NSString * title;
	NSString * xLabel;
	NSString * yLabel;
	
	BOOL logy;
	BOOL logx;
	BOOL customDataRange;

  BOOL shade1;
  NSColor *colour1;
  double x1cutoff;
  
  BOOL shade2;
  NSColor *colour2;
  double x2cutoff;
  
  BOOL shade3;
  NSColor *colour3;
  double x3cutoff;

	CGAffineTransform dataToPlot; // data to origin
	
	NSDictionary * xLabelAttributes;
	NSDictionary * yLabelAttributes;
	NSDictionary * titleAttributes;

	
	NSString * xTickFormatString;
	NSString * yTickFormatString;
	
}

@property (retain) NSColor * backgroundColour;
@property (retain) NSColor * axesColour;
@property (retain) NSColor * labelsColour;
@property (retain) NSString * title;
@property (retain) NSString * xLabel;
@property (retain) NSString * yLabel;
@property (retain) NSDictionary * xLabelAttributes;
@property (retain) NSDictionary * yLabelAttributes;
@property (retain) NSDictionary * titleAttributes;
@property (retain) NSString * xTickFormatString;
@property (retain) NSString * yTickFormatString;
@property (assign) float leftMargin;
@property (assign) float rightMargin;
@property (assign) float topMargin;
@property (assign) float bottomMargin;
@property (assign) NSRect plotRect;

- (id)initWithFrame:(NSRect)frame;
- (void) drawRect:(NSRect)rect;
- (int) estimateNumberOfPrettyXTicks; // erm. 10.
- (int) estimateNumberOfPrettyYTicks; // also 10.

- (void) clear;
- (void) addDataWithLegendEntry: (NSString *) theName andDataObject: (NSMutableData *) theData andColour: (NSColor *) theColour andLinewidth: (double) theLW;
- (void) deleteDataWithLegendEntry: (NSString *) theName;
- (void) overrideAutomaticDataRect: (NSRect) newDataRect;
- (void) setSimpleSinPlot;


- (void) calculateDataBounds;
- (void) updateDataRect;
- (NSRect) growRectToNiceBounds: (NSRect) oldRect;
- (void) updateAffineTransform;

- (void) updatePlotRect;	
- (void) estimateMargins;
- (void) setMarginsTop: (int) tm bottom: (int) bm left: (int) lm right: (int) rm;

+ (NSMutableData *) NSMutableDataWithCoordinates: (int) nPoints;
+ (double **) mallocDatasetWithCoordinates: (int) nPoints;
+ (void) freeDataset: (double **) theDatasetToFree;


@end
