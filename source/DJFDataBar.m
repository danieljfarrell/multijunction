//
//  DJFDataBar.m
//  Drag tracking area
//
//  Created by Daniel Farrell on 31/05/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "DJFDataBar.h"

@implementation DJFDataBar

@synthesize fillLevel;
@synthesize fillColour;
@synthesize fullRect;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        fillLevel = 1.0;
        fillColour = [NSColor blackColor];
        fullRect = NSMakeRect(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
    return self;
}

- (void)drawRect:(NSRect)rect {

    // Drawing code here.
//    NSRect bounds = [self bounds];

    NSRect fillRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height*fillLevel);
    [[NSColor blueColor] set];
    //[NSBezierPath fillRect:fillRect];
    NSBezierPath *fillPath = [NSBezierPath bezierPathWithRect:fillRect];
    [fillPath fill];
    
    
    [[NSColor blackColor] set];
    [NSBezierPath strokeRect:fillRect];

}

@end
