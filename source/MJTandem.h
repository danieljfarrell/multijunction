//
//  MJTandem.h
//  Drag tracking area
//
//  Created by Daniel J Farrell on 01/06/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MJTandem : NSObject {
  double Eg1;
  double Eg2;
  double Jm;
  double Vm;
  double Jm1, Vm1;
  double Jm2, Vm2;
}
@property (assign) double Eg1;
@property (assign) double Eg2;
@property (readonly) double Vm;
@property (readonly) double Jm;
@property (readonly) double Jm1;
@property (readonly) double Vm1;
@property (readonly) double Jm2;
@property (readonly) double Vm2;
@property (readonly) double efficiency;
- (void) calculateJVForJunction:(unsigned) junction;
@end
