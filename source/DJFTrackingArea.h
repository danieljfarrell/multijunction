//
//  DJFTrackingArea.h
//  Drag tracking area
//
//  Created by Daniel Farrell on 31/03/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//


/*
  A tracking area that can respond to mouse events; 
  it can be dragged to a new position.

*/
#import <Cocoa/Cocoa.h>


@interface DJFTrackingArea : NSView {
  NSTrackingArea *trackingArea;
  NSView *parentView;
  BOOL mouseIsDown;
  BOOL isVerticalDisplacementIgnored;
  NSColor *color;
}



@property (assign) NSView * parentView;
@property (retain) NSColor * color;
@property (assign) BOOL isVerticalDisplacementIgnored;
@property (assign) BOOL mouseIsDown;
@property (assign) NSRect rect;
@property (assign) NSTrackingArea *trackingArea;
@property (assign) NSRect frame;

- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseExited:(NSEvent *)theEvent;
- (void)mouseMoved:(NSEvent *)theEvent;
- (void)cursorUpdate:(NSEvent *)theEvent;

@end
