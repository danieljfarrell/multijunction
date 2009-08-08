//
//  DJFView.m
//  Drag tracking area
//
//  Created by Daniel Farrell on 31/03/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "DJFView.h"
#import "DJFTrackingArea.h"
#import "DJFController.h"

@implementation DJFView

@synthesize controller;
- (NSUInteger) junctions
{
  return junctions;
}

- (void) setJunctions: (NSUInteger) newValue
{
    newValue = newValue + 1;

  NSLog(@"Number of junctions set to %u",newValue);
  /* When the number of junctions is changed we must change the contents of the tracking area array*/
  if ((newValue == 1))
    {
      NSRect j1 = [[trackingAreas objectAtIndex:0] rect];
      [trackingAreas release];
      //trackingAreas = [[NSArray alloc] initWithObjects: [[DJFTrackingArea alloc] initWithRect:j1 inView:self], nil];
      DJFTrackingArea *t1 = [[DJFTrackingArea alloc] initWithFrame:j1];
      t1.parentView = self;
      t1.color = [NSColor blueColor];
      trackingAreas = [[NSArray alloc] initWithObjects:t1, nil];
    }
    
  if ((newValue == 2))
    {
      NSRect j1, j2;
      if ([trackingAreas count] >= 2)
        {
          j1 = [[trackingAreas objectAtIndex:0] rect];
          j2 = [[trackingAreas objectAtIndex:1] rect];
        }
      else
        {
          j1 = [[trackingAreas objectAtIndex:0] rect];
          j2 = NSMakeRect(j1.origin.x - 100, j1.origin.y, j1.size.width, j1.size.height);
        }
        
        [trackingAreas release];
        DJFTrackingArea *t1 = [[DJFTrackingArea alloc] initWithFrame:j1];
        t1.parentView = self;
        t1.color = [NSColor blueColor];
        DJFTrackingArea *t2 = [[DJFTrackingArea alloc] initWithFrame:j2];
        t2.parentView = self;
        t2.color = [NSColor greenColor];
        trackingAreas = [[NSArray alloc] initWithObjects:t1, t2, nil];
    }
  
    if ((newValue == 3))
      {
        NSRect j1, j2, j3;
      if ([trackingAreas count] == 3)
        {
          j1 = [[trackingAreas objectAtIndex:0] rect];
          j2 = [[trackingAreas objectAtIndex:1] rect];
          j3 = [[trackingAreas objectAtIndex:2] rect];
        }
      else if ([trackingAreas count] == 2)
        {
          j1 = [[trackingAreas objectAtIndex:0] rect];
          j2 = [[trackingAreas objectAtIndex:1] rect];
          j3 = NSMakeRect(j2.origin.x - 100, j2.origin.y, j2.size.width, j2.size.height);
        }
      else
        {
          j1 = [[trackingAreas objectAtIndex:0] rect];
          j2 = NSMakeRect(j1.origin.x - 100, j1.origin.y, j1.size.width, j1.size.height);
          j3 = NSMakeRect(j2.origin.x - 100, j2.origin.y, j2.size.width, j2.size.height);
        }
        
        [trackingAreas release];
        DJFTrackingArea *t1 = [[DJFTrackingArea alloc] initWithFrame:j1];
        t1.parentView = self;
        t1.color = [NSColor blueColor];
        DJFTrackingArea *t2 = [[DJFTrackingArea alloc] initWithFrame:j2];
        t2.parentView = self;
        t2.color = [NSColor greenColor];
        DJFTrackingArea *t3 = [[DJFTrackingArea alloc] initWithFrame:j3];
        t3.parentView = self;
        t3.color = [NSColor redColor];
        trackingAreas = [[NSArray alloc] initWithObjects:t1, t2, t3, nil];
      }
      
  junctions = newValue;
  [self setNeedsDisplay:YES];
  [super setNeedsDisplay:YES];

}


- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        DJFTrackingArea *t1 = [[DJFTrackingArea alloc] initWithFrame:NSMakeRect( 50, 57, 5, 527)];
        t1.parentView = self;
        t1.color = [NSColor blueColor];
        
        /*DJFTrackingArea *t2 = [[DJFTrackingArea alloc] initWithFrame:NSMakeRect( 50, 57, 5, 527)];
        t2.parentView = self;
        t2.color = [NSColor greenColor];
        DJFTrackingArea *t3 = [[DJFTrackingArea alloc] initWithFrame:NSMakeRect( 50, 57, 5, 527)];
        t3.parentView = self;
        t3.color = [NSColor redColor];
        */
        trackingAreas = [[NSArray alloc] initWithObjects:t1, nil];
        
      }
    return self;
}

- (void) awakeFromNib
{

  //delete the test sign plot
  [self deleteDataWithLegendEntry:@"sin"];  
  
  //Read AM1.5 dataset into data instance variable
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *spectraPath = [bundle pathForResource:@"AM1.5-direct-flux-per-eV-interpolated" ofType:@"xy"];
  NSString *spectraContents = [NSString stringWithContentsOfFile:spectraPath usedEncoding:NULL error:NULL];
  NSArray  *lines       = [spectraContents componentsSeparatedByString:@"\n"];
  NSMutableData * newDataset = [MFRawGraph NSMutableDataWithCoordinates: [lines count]];
	double ** newDatasetPointer = [newDataset mutableBytes];
  double * x = newDatasetPointer[0];
	double * y = newDatasetPointer[1];
	unsigned i; 
	
  //Very clever way of filling the array Markus :o)
	for (i=0; i< y-x; i++) {
    NSArray *components = [[lines objectAtIndex:i] componentsSeparatedByString:@"\t"];
		x[i] = [[components objectAtIndex:0] doubleValue];
		y[i] = [[components objectAtIndex:1] doubleValue];
	}

  [self addDataWithLegendEntry:@"spectrum" andDataObject:newDataset andColour:[NSColor blackColor] andLinewidth:1.5];
	[self setTitle:@"AM1.5g"];
	[self estimateMargins];
  
  //labels and niceities
  [self setXTickFormatString: @"%.1f"];
  [self setYTickFormatString: @"%.2g"];
  [self setTitle:@""];
  [self setXLabel:@"Photon energy (eV)"];
  [self setYLabel: @"Flux"];
  
  [self setXLabelAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[[NSFontManager sharedFontManager]
							fontWithFamily:@"Optima"
							traits:NSNarrowFontMask | NSUnboldFontMask
							weight:1 size:12], NSFontAttributeName,
							[NSColor blackColor], NSForegroundColorAttributeName, nil]];
		
  [self setYLabelAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[[NSFontManager sharedFontManager]
																	   fontWithFamily:@"Optima"
																	   traits:NSNarrowFontMask | NSUnboldFontMask
																	   weight:1 size:12], NSFontAttributeName,
							[NSColor blackColor], NSForegroundColorAttributeName, nil]];
		
  [self setTitleAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[[NSFontManager sharedFontManager]
																			 fontWithFamily:@"Optima"
																			 traits:NSNarrowFontMask | NSUnboldFontMask
																			 weight:1 size:20], NSFontAttributeName,
								  [NSColor blackColor], NSForegroundColorAttributeName, nil]];

//  [self overrideAutomaticDataRect:NSMakeRect(270,0,2500-270, 1.8)];
 [self overrideAutomaticDataRect:NSMakeRect(0.0,0.0, 4.0, 5e21)];
  
  
  NSPoint Eg1 = [self convertToViewPoint:NSMakePoint(2.0,0)];
  NSPoint Eg2 = [self convertToViewPoint:NSMakePoint(1.3,0)];
  NSPoint Eg3 = [self convertToViewPoint:NSMakePoint(0.6,0)];
  NSRect bounds = [self bounds];
  float heightOfBars = bounds.size.height - [super topMargin] - [super bottomMargin];
  float yOriginOfBars =  [super bottomMargin];
  
  DJFTrackingArea *t1 = [[DJFTrackingArea alloc] initWithFrame:NSMakeRect( Eg1.x, yOriginOfBars, 10, heightOfBars)];
  t1.parentView = self;
  t1.color      = [NSColor blueColor];
  
  /*
  DJFTrackingArea *t2 = [[DJFTrackingArea alloc] initWithFrame:NSMakeRect( Eg2.x, yOriginOfBars, 10, heightOfBars)];
  t2.parentView = self;
  t2.color      = [NSColor greenColor];
  
  DJFTrackingArea *t3 = [[DJFTrackingArea alloc] initWithFrame:NSMakeRect( Eg3.x, yOriginOfBars, 10, heightOfBars)];
  t3.parentView = self;
  t3.color      = [NSColor redColor];
  */
  trackingAreas = [[NSArray alloc] initWithObjects:t1,nil];
  activeRect = t1;
  [self setNeedsDisplay:YES];


}

- (NSPoint) convertToViewPoint:(NSPoint) dataPoint
{
  return  NSPointFromCGPoint(CGPointApplyAffineTransform(NSPointToCGPoint(dataPoint), dataToPlot));
}


- (NSPoint) convertToDataPoint:(NSPoint) viewPoint
{
  return NSPointFromCGPoint(CGPointApplyAffineTransform(NSPointToCGPoint(viewPoint), CGAffineTransformInvert(dataToPlot)));
}

- (double) selectedDataPoint
{
  NSPoint pt = [activeRect rect].origin;
  return [self convertToDataPoint:pt].x;
}

- (double) selectedViewPoint
{
  NSPoint pt = [activeRect rect].origin;
  return [self convertToViewPoint:pt].x;
}


- (void)drawRect:(NSRect)rect {
    // Drawing code here.
  NSUInteger item = 1;
  for (DJFTrackingArea *ta in trackingAreas) {
    NSPoint boundary = [self convertToDataPoint: NSMakePoint (ta.rect.origin.x, 0)];
    if ((item == 1))
      [super shade1WithBoundary:boundary.x andColour:ta.color];
    if ((item == 2))
      [super shade2WithBoundary:boundary.x andColour:ta.color];
    if ((item == 3))
      [super shade3WithBoundary:boundary.x andColour:ta.color];
    item++;
  }
      
    //NSLog(@"-drawRect:");
    [super drawRect:rect];

    
      for (DJFTrackingArea *obj in trackingAreas) {
        [[obj.color colorWithAlphaComponent:[obj alphaValue]] set];
        [NSBezierPath fillRect:obj.rect];
        [obj setNeedsDisplay:YES];
      }
      
}

- (void) mouseDown:(NSEvent*)theEvent
{
  //NSLog(@"-mouseDown:");
  //DJFTrackingArea *ta = [self activeTrackingArea:theEvent];
  //[ta setMouseIsDown:YES];
  //
  
  
  // When a mouse down is received, look to see if any control points are under
  // the mouse and drag them around if they are
  //
  

	//
	// Get the location of the mouse down even
	//
	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];

	//
	// Look to see if a point in the "points" array has a control point
	// rectangle at the mouse down location.
	//
	NSInteger match = NSNotFound;
	for (DJFTrackingArea *ta in trackingAreas) 
    {
      if (NSPointInRect(location, ta.rect))
        {
          activeRect = ta;
          match = 0;
        }
    }
    
	//
	// If no control point exists at the mouse down location, then return
	//
	if (match == NSNotFound)
	{
		return;
	}
	
    while (YES)
	{
		//
		// Begin modal mouse tracking, looking for mouse dragged and mouse
		// up events
		//
        NSEvent *trackingEvent =
			[[self window]
				nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
        
    //
		// Stop mouse tracking if a mouse up is received
		//
		if ([trackingEvent type] == NSLeftMouseUp)
		{
      activeRect = nil;
      break;
		}
		
		//
		// Convert the location of the new event to an NSValue and replace
		// the "match" NSValue with the new NSValue in the "points" array.
		//
		NSPoint trackingLocation =
			[self convertPoint:[trackingEvent locationInWindow] fromView:nil];
    // the x-offset with respect to the rect origin and the tracking location x value

    NSRect newRect = NSMakeRect(trackingLocation.x, ((NSRect)(activeRect.rect)).origin.y, ((NSRect)(activeRect.rect)).size.width, ((NSRect)(activeRect.rect)).size.height);
    
    

   BOOL rectsOverlapping = NO;
   DJFTrackingArea *altTrackingArea = nil;
   if (([trackingAreas count] == 1))
    {
       NSRect activeNSRect;
       NSRect altNSRect;

       DJFTrackingArea *blueTA = [trackingAreas objectAtIndex:0];
       activeNSRect = blueTA.rect;
       BOOL blueOutsideRight = (activeNSRect.origin.x + activeNSRect.size.width) > ([super plotRect].origin.x + [super plotRect].size.width);
       if (blueOutsideRight)
        {
          activeNSRect.origin.x = [super plotRect].origin.x + [super plotRect].size.width - 25.0;
          blueTA.rect = activeNSRect;
          [self setNeedsDisplay:YES];
          break;
        }
        
       BOOL blueOutsideLeft = activeNSRect.origin.x < ([super plotRect].origin.x +35);
       if (blueOutsideLeft)
        {
          activeNSRect.origin.x = [super plotRect].origin.x + 35.0;
          blueTA.rect = activeNSRect;
          [self setNeedsDisplay:YES];
          break;
        }
        
    }
   
   
   // Rect collisions and bounds checking section
   if (([trackingAreas count] == 2))
    {
     
        //Check if we are blue of green junction
        DJFTrackingArea *blueTA = [trackingAreas objectAtIndex:0];
        DJFTrackingArea *greenTA = [trackingAreas objectAtIndex:1];
        NSRect activeNSRect;
        NSRect altNSRect;
        
        if ((activeRect == blueTA))
          {
            //we are blue
            activeNSRect = blueTA.rect;
            altNSRect    = greenTA.rect;
            rectsOverlapping = (activeNSRect.origin.x < (altNSRect.origin.x + altNSRect.size.width));
            if (rectsOverlapping)
              {
                altNSRect.origin.x = activeNSRect.origin.x - altNSRect.size.width ;
                greenTA.rect = altNSRect;
              }

          }
        else
          {
            //we are green
            activeNSRect = greenTA.rect;
            altNSRect    = blueTA.rect;
            rectsOverlapping = ((activeNSRect.origin.x + activeNSRect.size.width) > altNSRect.origin.x);
            if (rectsOverlapping)
              {
                altNSRect.origin.x = activeNSRect.origin.x + activeNSRect.size.width;
                blueTA.rect = altNSRect;
              }
          }
               
        
        //check that the two junctions are in the graph bounds
         if ((activeRect == blueTA))
          {
            activeNSRect = blueTA.rect;
            altNSRect    = greenTA.rect;
            BOOL blueOutside = (activeNSRect.origin.x + activeNSRect.size.width) > ([super plotRect].origin.x + [super plotRect].size.width);
            if (blueOutside)
              {
                activeNSRect.origin.x = ([super plotRect].origin.x + [super plotRect].size.width) - (activeNSRect.size.width + 20.0);
                blueTA.rect = activeNSRect;
                [self setNeedsDisplay:YES];
                break;
              }
              
            BOOL greenOutside = (altNSRect.origin.x < [super plotRect].origin.x);
            if (greenOutside)
              {
                altNSRect.origin.x = [super plotRect].origin.x + 35.0;
                activeNSRect.origin.x = altNSRect.origin.x + altNSRect.size.width;
                blueTA.rect = activeNSRect;
                greenTA.rect = altNSRect;
                [self setNeedsDisplay:YES];
                break;
              }
              
          }
        else
          {
            //Green is the active tracking rect
            activeNSRect = greenTA.rect;
            altNSRect    = blueTA.rect;
            BOOL greenOutsideTheLeftEdge = (activeNSRect.origin.x < [super plotRect].origin.x);
            if (greenOutsideTheLeftEdge)
              {
                activeNSRect.origin.x = [super plotRect].origin.x + 35;
                greenTA.rect = activeNSRect;
                [self setNeedsDisplay:YES];
                break;
              }
            
      
            BOOL greenPushingBlueOutsideRightEdge = (altNSRect.origin.x + altNSRect.size.width) > ([super plotRect].origin.x + [super plotRect].size.width);
            if (greenPushingBlueOutsideRightEdge)
              {
                altNSRect.origin.x = ([super plotRect].origin.x + [super plotRect].size.width) - altNSRect.size.width - 20.0;
                activeNSRect.origin.x = altNSRect.origin.x - activeNSRect.size.width;
                greenTA.rect = activeNSRect;
                blueTA.rect  = altNSRect;
                [self setNeedsDisplay:YES];
                break;
              }
            
          }

            
    }
   
   
   // now collisions for 3 junctions (I'm sure there is a really general way of going this!)
   if (([trackingAreas count] == 3))
    {
       //Check if we are blue, green or red junction
        DJFTrackingArea *blueTA = [trackingAreas objectAtIndex:0];
        DJFTrackingArea *greenTA = [trackingAreas objectAtIndex:1];
        DJFTrackingArea *redTA = [trackingAreas objectAtIndex:2];
        NSRect activeNSRect = activeRect.rect;
        NSRect altBlueNSRect, altGreenNSRect, altRedNSRect;
               
        //Blue being dragged
        if ((activeRect == blueTA))
          {
            altGreenNSRect = greenTA.rect;
            altRedNSRect   = redTA.rect;
            rectsOverlapping = (activeNSRect.origin.x < (altGreenNSRect.origin.x + altGreenNSRect.size.width));
            if (rectsOverlapping)
              {
                altGreenNSRect.origin.x = activeNSRect.origin.x - altGreenNSRect.size.width ;
                greenTA.rect = altGreenNSRect;
                
                //now check that the red overlaps with the new green location
                rectsOverlapping = (altGreenNSRect.origin.x < (altRedNSRect.origin.x + altRedNSRect.size.width));
                if (rectsOverlapping)
                  {
                    altRedNSRect.origin.x = altGreenNSRect.origin.x - altGreenNSRect.size.width;
                    redTA.rect = altRedNSRect;
                  }
                  
                
                [self setNeedsDisplay:YES];
                break;
              }

          }
          
        //Green being dragged
        if ((activeRect == greenTA))
          {
          
          }
        
        //Red being dragged
        if ((activeRect == redTA))
          {
          
          }
        
   
    }
    
    

    
    /*
    NSLog(@"rectsOverlapping %u",rectsOverlapping);
    if (rectsOverlapping)
      {
        // here we use the position of the alt rect to check for the boundary collision
        // the left edge of the alt rect is inside the area
        NSRect altRect = altTrackingArea.rect;
        NSLog(@"plotRect %@\taltRect %@",NSStringFromRect([super plotRect]), NSStringFromRect(altRect));
        BOOL leftIsOutsidePlot = altRect.origin.x < [super plotRect].origin.x;
        if (leftIsOutsidePlot)
          {
            NSLog(@"leftIsOutsidePlot");
            altRect.origin.x = [super plotRect].origin.x;
            newRect.origin.x = altRect.origin.x + altRect.size.width;
            altTrackingArea.rect = altRect;
            activeRect.rect = newRect;
          }
        
      }
    else
      {
        //here we use the active rect as normal
      }
    
    */
    
    BOOL notInPlotRect = (NSPointInRect(trackingLocation, [super plotRect]) == NO) || (NSPointInRect(NSMakePoint(trackingLocation.x + ((NSRect)(activeRect.rect)).size.width, trackingLocation.y), [super plotRect]) == NO);
    //BOOL notInPlotRect = NSPointInRect(trackingLocation, [super plotRect]) == NO;
    if (notInPlotRect)
      {
        /*
         NSRect pRect = [super plotRect];
        if (trackingLocation.x < ((pRect.origin.x + pRect.size.width)*0.5))
          {
            //the tacking event is happening close to the left margin
            //newRect.origin.x = newRect.origin.x + 10;
          }
        else
          {
            //newRect.origin.x = newRect.origin.x - 10;
          }
        
        //activeRect = nil;
        //activeRect.rect = newRect;
        */
       // activeRect = nil;
       // break;
      }
    
    //if survived all the above tests the we can move he darn rect! 
    activeRect.rect = newRect;

		
		//
		// Redraw the view
		//
   // NSRect a = NSMakeRect([super plotRect].origin.x, [super plotRect].origin.y, [super plotRect].size.width, [super plotRect].size.height);

    if ((junctions == 1))
      {
        controller.Eg1 = [self convertToDataPoint:((NSRect)activeRect.rect).origin].x;
      }
      
    if ((junctions == 2))
      {
        NSPoint EG1 = [[trackingAreas objectAtIndex:0] rect].origin;
        NSPoint EG2 = [[trackingAreas objectAtIndex:1] rect].origin;
        EG1 = [self convertToDataPoint:EG1];
        EG2 = [self convertToDataPoint:EG2];
        NSLog(@"Eg1 %g\t Eg2 %g", EG1.x, EG2.x);
        [controller setEg1:EG1.x Eg2:EG2.x];
      }
      
  
		[self setNeedsDisplay:YES];
    
	}
}


- (void) mouseUp:(NSEvent*)theEvent
{
  NSLog(@"-mouseUp:");
  //get the tracking area containing the mouse
  [[self activeTrackingArea:theEvent] setMouseIsDown:NO];
  [[NSCursor openHandCursor] set];
}

- (void)mouseDragged:(NSEvent *)theEvent
{
/*
  NSLog(@"-mouseDragged:");
  DJFTrackingArea *ta = [self activeTrackingArea:theEvent];
  
  //if([ta mouseIsDown] && [self mouse:[self convertPoint:[theEvent locationInWindow] fromView:nil] inRect:[ta rect]])
  //  {
      double dx=0.0, dy=0.0;
      dx = [theEvent deltaX];
      dy = [theEvent deltaY];
      
      NSRect newRect;
      if (ta.isVerticalDisplacementIgnored)
        newRect = NSMakeRect([ta rect].origin.x + dx, [ta rect].origin.y, [ta rect].size.width, [ta rect].size.height);
      else
        newRect = NSMakeRect([ta rect].origin.x + dx, [ta rect].origin.y - dy, [ta rect].size.width, [ta rect].size.height);
      
      NSLog(NSStringFromRect(newRect));
      [ta setRect:newRect];
    
  //  }
   */
   
    //[self setNeedsDisplay:YES];
}

- (DJFTrackingArea*) activeTrackingArea:(NSEvent*)theEvent
{
  DJFTrackingArea *activeTrackingArea = nil;
  for (id ta in trackingAreas) {
    if ([self mouse:[self convertPoint:[theEvent locationInWindow] fromView:nil] inRect:[ta rect]])
        activeTrackingArea = ta;
  }
  return activeTrackingArea;
}

@end
