//
//  DJFDataBarSplit.h
//  Drag tracking area
//
//  Created by Daniel Farrell on 29/06/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "DJFDataBar.h"
#import <Cocoa/Cocoa.h>

@interface DJFSplitDataBar : DJFDataBar {
  double lowerFillLevel;
  double upperFillLevel;
  NSColor *lowerFillColor;
  NSColor *upperFillColor;
  BOOL isSplit;
}


@property (assign) double lowerFillLevel;
@property (assign) double upperFillLevel;
@property (retain) NSColor *lowerFillColor;
@property (retain) NSColor *upperFillColor;
@property (assign) BOOL isSplit;



@end
