//
//  DJFView.h
//  Drag tracking area
//
//  Created by Daniel Farrell on 31/03/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MFRawGraph.h"
@class DJFView;
@class DJFTrackingArea;
@class DJFController;

@interface DJFView : MFRawGraph {
  NSArray *trackingAreas;
  DJFTrackingArea* activeRect;
  NSUInteger junctions;
  DJFController *controller;
}

@property (assign) DJFController *controller;
@property (assign) NSUInteger junctions;

- (DJFTrackingArea*) activeTrackingArea:(NSEvent*)theEvent;
- (NSPoint) convertToViewPoint:(NSPoint) dataPoint;
- (NSPoint) convertToDataPoint:(NSPoint) viewPoint;

@end
