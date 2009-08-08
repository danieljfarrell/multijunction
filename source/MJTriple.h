//
//  MJTriple.h
//  Drag tracking area
//
//  Created by Daniel Farrell on 22/06/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MJTriple : NSObject {
  double Eg1;
  double Eg2;
  double Eg3;
  double Jm;
  double Vm;
  double Jm1, Vm1;
  double Jm2, Vm2;
  double Jm3, Vm3;
}

@property (assign) double Eg1;
@property (assign) double Eg2;
@property (assign) double Eg3;
@property (readonly) double Vm;
@property (readonly) double Jm;
@property (readonly) double efficiency;
- (void) calculateJVForJunction:(unsigned) junction;
@end
