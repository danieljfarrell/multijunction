//
//  DJFConcentration.m
//  Drag tracking area
//
//  Created by Daniel Farrell on 09/07/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "DJFConcentration.h"


@implementation DJFConcentration
@dynamic value;

- (void) setValue:(double)newValue
{
  value = newValue;
}

/* Here we can implement custom scaling of the scroll bar.*/
- (double) value
{
  NSLog(@"slider value %g",value);
  //value = ceil(value*50.0)/50.0;
  if (value <= 0.5)
    {
      double xval = round((1.0 + (1000.0-1.0)*(value/0.5))/10.0)*10.0;
      if (xval < 1.0)
        xval = 1.0;
      return xval;
    }
  else if (value <= 0.75)
    {
      //re-scale to be in range 0->1
      double sval = (value - 0.5)/0.25;
      return round((1000.0 + (10000.0-1000.0)*sval)/100.0)*100.0;
    }
  else
    { 
      double sval = (value - 0.75)/0.25;
      double xval = round((10000.0 + (pi/6.8e-5 - 10000.0)*sval)/100.0)*100.0;
      if (xval > (pi/6.8e-5))
        xval = (pi/6.8e-5);
      return xval;
    }
  return 1.0;
}

@end
