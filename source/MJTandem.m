//
//  MJTandem.m
//  Drag tracking area
//
//  Created by Daniel J Farrell on 01/06/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "MJTandem.h"
#import "gplanck.h"
#import "pvconstants.h"

@implementation MJTandem
@synthesize Eg1;
@synthesize Eg2;
@synthesize Vm;
@synthesize Jm;
@synthesize Vm1;
@synthesize Jm1;
@synthesize Vm2;
@synthesize Jm2;
@dynamic efficiency;
#define STEPS 1000

- (id) init
{
  self = [super init];
  if (self != nil) {
    Eg1 = 1.8;
    Eg2 = 1.1;
    Jm1 = 0.0;
    Jm2 = 0.0;
    Vm1 = 0.0;
    Vm2 = 0.0;
    Jm = 0.0;
    Vm = 0.0;
  }
  return self;
}

- (void) setEg1: (double) newEg1;
{
  if ((Eg1 != newEg1))
    {
      Eg1 = newEg1;
      [self calculateJVForJunction:1];
      [self calculateJVForJunction:2];
      Jm = Jm1 + Jm2;
      Vm = Vm1 + Vm2;
    }
}

- (void) setEg2: (double) newEg2;
{
  if ((Eg2 != newEg2))
    {
      Eg2 = newEg2;
      [self calculateJVForJunction:2];
      Jm = Jm1 + Jm2;
      Vm = Vm1 + Vm2;
    }
}

- (void) calculateJVForJunction:(unsigned) junction
{
 //For the given values find the the value of the maximum power point and return the carrier temperature
  double VRange[2];
  VRange[0] = 0.0;
  VRange[1] = 10;
  double V[STEPS];
  double J[STEPS];
  double VStep = (VRange[1] - VRange[0])/((double)STEPS);
  unsigned i;
  for (i=0; i<STEPS; i++)
    {
      V[i] = VRange[0] + i*VStep;
      if ((junction == 1))
        {
          J[i] = q*(analyticalSimplifiedGeneralisedPlanck(Eg1*q, Ts, 0.0, fs, 2) - analyticalSimplifiedGeneralisedPlanck(Eg1*q, Tearth, q*V[i], pi, 2));
        }
      
      if ((junction == 2))
        {
          J[i] = q*(analyticalSimplifiedIncompleteGeneralisedPlanck(Eg2*q, Eg1*q, Ts, 0.0, fs, 2) - 1.0*analyticalSimplifiedIncompleteGeneralisedPlanck(Eg2*q, 10*q, Tearth, q*V[i], pi, 2));
        }

    }
    
  //find maximum power point and return the corresponding temperature
  double Pold = 0.0;
  double Pnew = 0.0;
  unsigned Pindex = 0;
  for (i=0; i<STEPS; i++)
    {
      Pnew = V[i]*J[i];
      if (Pnew > Pold)
        {
          Pold = Pnew;
          Pindex = i;
        }
    }

  if ((junction == 1))
    {
      Vm1 = V[Pindex];
      Jm1 = J[Pindex];
      NSLog(@"Calculating J1, efficiency = %g",(Vm1 * Jm1)/analyticalSolarConstant);
    }
  else
    {
      Vm2 = V[Pindex];
      Jm2 = J[Pindex];
      NSLog(@"Calculating J2, efficiency = %g",(Vm2 * Jm2)/analyticalSolarConstant);
    }

  NSLog(@"Eg1 = %g, Eg2 = %g", Eg1, Eg2);
}

- (double) Vm
{
  return Vm1 + Vm2;
}

- (double) Jm
{
  return Jm1 + Jm2;
}

- (double) efficiency
{
  return ((Vm1 * Jm1)+(Vm2*Jm2))/analyticalSolarConstant;
}

@end
