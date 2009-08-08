//
//  DJFDataBar.h
//  Drag tracking area
//
//  Created by Daniel Farrell on 31/05/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DJFDataBar : NSView {
  double fillLevel;
  NSColor *fillColour;
  NSRect fullRect;
}

@property (assign) double fillLevel;
@property (retain) NSColor * fillColour;
@property (readonly) NSRect fullRect;

@end
