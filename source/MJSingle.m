//
//  MJSingle.m
//  MJs
//
//  Created by Daniel Farrell on 31/05/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "MJSingle.h"
#import "gplanck.h"
#import "pvconstants.h"

#define STEPS 2000

@implementation MJSingle
@synthesize Eg;
@synthesize concentration;
@synthesize Vm;
@synthesize Jm;
@dynamic efficiency;

- (id) init
{
  self = [super init];
  if (self != nil) {
    Eg = 1.1;
    concentration = 1.0;
    Vm = 0.0;
    Jm = 0.0;
  }
  return self;
}

- (void) setEg: (double) newEg1;
{
  Eg = newEg1;
  
  //For the given values find the the value of the maximum power point and return the carrier temperature
  double VRange[2];
  VRange[0] = 0.0;
  VRange[1] = Eg;
  double V[STEPS];
  double J[STEPS];
  double VStep = (VRange[1] - VRange[0])/((double)STEPS);
  unsigned i;
  for (i=0; i<STEPS; i++)
    {
      V[i] = VRange[0] + i*VStep;
      J[i] = q*(analyticalSimplifiedGeneralisedPlanck(Eg*q, Ts, 0.0, solidangleFromConcentrationFactor(concentration), 2) + analyticalSimplifiedGeneralisedPlanck(Eg*q, Tearth, 0.0, pi-solidangleFromConcentrationFactor(concentration), 2) - analyticalSimplifiedGeneralisedPlanck(Eg*q, Tearth, q*V[i], pi, 2));
      //J[i] = q*(generalisedPlanck(Eg1*q, Ts, 0.0, fs, 2) - generalisedPlanck(Eg1*q, Tearth, q*V[i], pi, 2));
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

  Vm = V[Pindex];
  Jm = J[Pindex];

}

- (double) efficiency
{
  //NSLog(@"Insolation %g",analyticalSimplifiedGeneralisedPlanck(0.0, Ts, 0.0, solidangleFromConcentrationFactor(concentration), 3));
  return (Vm*Jm)/(analyticalSolarConstant*self.concentration);
}

@end
