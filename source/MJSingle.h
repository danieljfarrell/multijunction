//
//  MJSingle.h
//  MJs
//
//  Created by Daniel Farrell on 31/05/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MJSingle : NSObject {
  double Eg;
  double concentration;
  double Jm;
  double Vm;
}
@property (assign) double Eg;
@property (assign) double concentration;
@property (readonly) double Vm;
@property (readonly) double Jm;
@property (readonly) double efficiency;
@end
