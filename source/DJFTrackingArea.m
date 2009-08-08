//
//  DJFTrackingArea.m
//  Drag tracking area
//
//  Created by Daniel Farrell on 31/03/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "DJFTrackingArea.h"


@implementation DJFTrackingArea
@synthesize color;
@synthesize isVerticalDisplacementIgnored;
@synthesize rect;
@synthesize mouseIsDown;
@synthesize parentView;
@synthesize trackingArea;
@synthesize frame;

- (id) init
{
  self = [super init];
  if (self != nil) {
    trackingArea = nil;
    parentView = nil;
    mouseIsDown = NO;
    isVerticalDisplacementIgnored = YES;
  }
  return self;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
   [self setPostsFrameChangedNotifications:YES];  
    unsigned opts = NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow|NSTrackingEnabledDuringMouseDrag|NSTrackingCursorUpdate;
    trackingArea = [[NSTrackingArea alloc] initWithRect:frame options:opts owner:self userInfo:nil];
    //Can't add the tracking area to the parent view here because it's not initalised in the initWithFrame:
    //[parentView addTrackingArea:trackingArea];
        
      }
  return self;
}

/*- (id) initWithRect:(NSRect) aRect inView:(NSView*) aView
{
  self = [self init];
 if (self != nil) {
    parentView = aView;
    unsigned opts = NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow|NSTrackingEnabledDuringMouseDrag|NSTrackingCursorUpdate;
    trackingArea = [[NSTrackingArea alloc] initWithRect:aRect options:opts owner:self userInfo:nil];
    [parentView addTrackingArea:trackingArea];
  }
  return self;
}
*/

- (void) setRect:(NSRect) aRect
{
   unsigned opts = NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInKeyWindow|NSTrackingEnabledDuringMouseDrag|NSTrackingCursorUpdate;
   [parentView removeTrackingArea:trackingArea];
   [trackingArea release];
   NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:trackingArea, @"trackingArea", nil];
   [info autorelease];
   trackingArea = [[NSTrackingArea alloc] initWithRect:aRect options:opts owner:self userInfo:info];
   [parentView addTrackingArea:trackingArea];
   [self setFrame:aRect];
}

- (NSRect) rect
{
  return [trackingArea rect];
}


- (void) setFrame: (NSRect) aRect
{
  [super setFrame:aRect];

}

- (NSRect) frame
{
  return [super frame];
}

- (void) setParentView:(NSView*) aView
{
  //Add the trackingArea to the parent view
  if (parentView != nil)
    {
      [parentView removeTrackingArea:trackingArea];
    }
  parentView = aView;
  [parentView addTrackingArea:trackingArea];
}

- (NSView*) parentView
{
  return parentView;
}

- (void) setMouseIsDown: (BOOL) flag
{
  NSLog(@"mouseIsDown = %u",(unsigned)flag);
  mouseIsDown = flag;
}


- (BOOL) mouseIsDown
{
  return mouseIsDown;
}


- (void)mouseEntered:(NSEvent *)theEvent
{
  NSLog(@"-mouseEntered:");
  [[NSCursor openHandCursor] set];
  //[[super animator] setAlphaValue:0.95];
}

- (void)mouseExited:(NSEvent *)theEvent
{
  NSLog(@"-mouseExited:");
  [[NSCursor arrowCursor] set];
  //[[super animator] setAlphaValue:0.05];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
  NSLog(@"-mouseMoved:");
  if (!mouseIsDown)
    [[NSCursor openHandCursor] set];
  else
    [[NSCursor closedHandCursor] set];
  
  //[super setAlphaValue:0.95];
}

- (void)cursorUpdate:(NSEvent *)theEvent
{
  NSLog(@"-curosrUpdate:");
}

- (void) drawRect: (NSRect) aRect
{
  [self.color set];
  [NSBezierPath fillRect:self.rect];
  //[[super animator] setAlphaValue:0.05];
}

@end
