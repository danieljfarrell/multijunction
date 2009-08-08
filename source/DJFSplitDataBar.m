//
//  DJFDataBarSplit.m
//  Drag tracking area
//
//  Created by Daniel Farrell on 29/06/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "DJFSplitDataBar.h"


@implementation DJFSplitDataBar

@synthesize lowerFillLevel;
@synthesize upperFillLevel;
@synthesize lowerFillColor;
@synthesize upperFillColor;
@synthesize isSplit;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        upperFillLevel = 0.2;
        lowerFillLevel = 0.2;
        upperFillColor = [NSColor greenColor];
        lowerFillColor = [NSColor blueColor];
        isSplit = NO;

    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    NSLog(NSStringFromRect(rect));
    if (self.isSplit)
      {
        double lowerFracHeight =  rect.size.height*lowerFillLevel;
        double upperFracHeight = rect.size.height *upperFillLevel;
        double totalFracHeight = (lowerFillLevel + upperFillLevel) * rect.size.height;
        NSRect lowerRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, lowerFracHeight);
        NSRect upperRect = NSMakeRect(rect.origin.x, lowerRect.origin.y + lowerRect.size.height, rect.size.width, upperFracHeight);
        
        [lowerFillColor set];
        NSBezierPath *lowerFillPath = [NSBezierPath bezierPathWithRect:lowerRect];
        //[lowerFillPath fillGradientFrom: [NSColor white to:[NSColor colorWithCalibratedRed:0.0 green:0.0 blue:1.0 alpha:0.5] angle:0.0];
        [lowerFillPath fill];
        [upperFillColor set];
        NSBezierPath *upperFillPath = [NSBezierPath bezierPathWithRect:upperRect];
        //[upperFillPath fillGradientFrom: [NSColor whiteColor] to:upperFillColor angle:0.0];
        [upperFillPath fill];
        
        [[NSColor blackColor] set];
        [NSBezierPath strokeRect:lowerRect];
        [NSBezierPath strokeRect:upperRect];
        NSRect fillRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, totalFracHeight);
        //[NSBezierPath strokeRect:fillRect];
      }
    else
      {
        [super drawRect:rect];
      }
    

}


@end
