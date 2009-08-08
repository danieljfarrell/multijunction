//
//  MJTriple.m
//  Drag tracking area
//
//  Created by Daniel Farrell on 22/06/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "MJTriple.h"
#import "gplanck.h"
#import "pvconstants.h"

@implementation MJTriple

@synthesize Eg1;
@synthesize Eg2;
@synthesize Eg3;
@synthesize Vm;
@synthesize Jm;
@dynamic efficiency;
#define STEPS 500

- (id) init
{
  self = [super init];
  if (self != nil) {
    Eg1 = 1.8;
    Eg2 = 1.1;
    Eg3 = 0.6;
    Jm1 = 0.0;
    Jm2 = 0.0;
    Jm3 = 0.0;
    Vm1 = 0.0;
    Vm2 = 0.0;
    Vm3 = 0.0;
    Jm  = 0.0;
    Vm  = 0.0;
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
      [self calculateJVForJunction:3];
      Jm = Jm1 + Jm2 + Jm3;
      Vm = Vm1 + Vm2 + Vm3;
    }
}

- (void) setEg2: (double) newEg2;
{
  if ((Eg2 != newEg2))
    {
      Eg2 = newEg2;
      [self calculateJVForJunction:2];
      [self calculateJVForJunction:3];
      Jm = Jm1 + Jm2 + Jm3;
      Vm = Vm1 + Vm2 + Vm3;
    }
}

- (void) setEg3: (double) newEg3;
{
  if ((Eg3 != newEg3))
    {
      Eg3 = newEg3;
      [self calculateJVForJunction:3];
      Jm = Jm1 + Jm2 + Jm3;
      Vm = Vm1 + Vm2 + Vm3;
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
          J[i] = q*(analyticalSimplifiedIncompleteGeneralisedPlanck(Eg2*q, Eg1*q, Ts, 0.0, fs, 2) - 0.5*analyticalSimplifiedIncompleteGeneralisedPlanck(Eg2*q, 10*q, Tearth, q*V[i], pi, 2));
        }
        
      if ((junction == 3))
        {
          J[i] = q*(analyticalSimplifiedIncompleteGeneralisedPlanck(Eg3*q, Eg2*q, Ts, 0.0, fs, 2) - 0.5*analyticalSimplifiedIncompleteGeneralisedPlanck(Eg3*q, 10*q, Tearth, q*V[i], pi, 2));
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
 
  if ((junction == 2))
    {
      Vm2 = V[Pindex];
      Jm2 = J[Pindex];
      NSLog(@"Calculating J2, efficiency = %g",(Vm2 * Jm2)/analyticalSolarConstant);
    }
    
  if ((junction == 3))
    {
      Vm3 = V[Pindex];
      Jm3 = J[Pindex];
      NSLog(@"Calculating J2, efficiency = %g",(Vm3 * Jm3)/analyticalSolarConstant);
    }

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
  return ((Vm1 * Jm1)+(Vm2*Jm2)+(Vm3*Jm3))/analyticalSolarConstant;
}

@end
