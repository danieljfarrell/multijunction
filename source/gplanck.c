/*
 *  gplanck.c
 *  PC-model
 *
 *  Created by Daniel J Farrell on 20/04/2009.
 *  Copyright 2009 Daniel J Farrell. All rights reserved.
 *
 */

#include "gplanck.h"
#include "pvconstants.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#pragma mark General background
/* 
 Returns, by numerical integration using the trapezium rule, the area under the curve
 defined by two arrays of doubles 'x' and 'y' each with 'count' elements.
*/

double integrate (double *x, double *y, unsigned count)
{
  double  accumulator = 0.0;
  if (count > 1) 
    {   
      unsigned i;
      for (i=0; i<(count-1); i++)
        {
          double  dx = fabs(x[i+1] - x[i]);
          double  y1 = y[i];
          double  y2 = y[i+1];
          double element = (y1 + y2) * dx * 0.5;
          accumulator = accumulator + element;
      }
  }
  return accumulator;
}

/* Returns the solidangle (Sr) of a given concentration factor, X, which must be
number bewtween zero and 46200 otherwise an error is thrown.
*/
double solidangleFromConcentrationFactor (double X)
{
  if ((X>0.0) && (X<=46200.0))
    {
      return X*fs;
    }
  else
    {
      printf("Concentration cannot exceed 46200x.\n");
      exit(1);
    }
  return 0.0;
}

double concentrationFactorFromSolidangle (double omega)
{
   if ((omega>0.0) && (omega<=pi))
    {
      return fs/omega;
    }
  else
    {
      printf("Error using function concentrationFactorFromSolidangle. Solidangle subtended by the sun cannot exceed pi Sr.\n");
      exit(1);
    }
  return 0.0;
}


#pragma mark Generalised Planck
/*
  This returns the value of the generalised Planck as the specific values of energy E (J). 
  No integration is performed.
*/
double generalisedPlanckValue (double E, double T, double mu, double omega, unsigned P)
{
  //tests
  double value = 0.0;
  if ((mu < E))
    {
      double prefactor = (2*omega/(c*c*h*h*h));
      double E_P = pow(E,(double)P);
      double denom = (exp((E-mu)/(k*T)) - 1.0);
      value = prefactor * E_P / denom;
      return value;
    }
  else
    {
      return 0.0;
    }
  
  return 0.0;
}


/*
  Return the value of the generalised Planck (photons/m^2/s) or (J/m^2/s), without 
  simplification i.e. including the minus one in the denominator, integrated 
  beween Eg and inf. Numberical integration is used and splits the specificed 
  range up into 1000 points between Eg and infinity.
*/
double generalisedPlanck (double Eg, double T, double mu, double omega, unsigned P)
{
  /* 
     Make and array to hold the values, always of 1000 elements.
     Energy ranges from Eg to 10eV, which is chosen as our infinity value.
  */
  unsigned steps = 1000;
  double x[steps];
  double y[steps];
  double dx = (10.0*q - Eg)/((double)steps);
  unsigned i;
  for (i=0; i<steps; i++)
    {
      double xval = Eg + i*dx;
      x[i] = xval;
      double yval = generalisedPlanckValue(x[i], T, mu, omega, P);
      y[i] = yval;
    }
    
  return integrate (x,y,steps);
}


double analyticalSimplifiedGeneralisedPlanck(double Eg, double T, double mu, double omega, unsigned P)
{
    /* Performing the calculation in eV is more accurate that in J */
    Eg = Eg/q;
    double C = 2*omega/(c*c*h_ev*h_ev*h_ev);
    double kT = k_ev*T;
    mu = mu/q;
    
    if (P==2)
        return C * (2*kT*kT*kT + 2*Eg*kT*kT + Eg*Eg*kT) * exp(mu/kT - Eg/kT);
    
    if(P==3)
        return q * C * (6*(kT*kT*kT*kT) + 6*Eg*(kT*kT*kT) + 3*(Eg*Eg)*(kT*kT) + (Eg*Eg*Eg)*kT) * exp(mu/kT - Eg/kT);
    
    return 0.0;
    
}

double analyticalSimplifiedIncompleteGeneralisedPlanck(double Eg, double Ej, double T, double mu, double omega, unsigned P)
{
    /* Performing the calculation in eV is more accurate that in J */
    Eg = Eg/q;
    Ej = Ej/q;
    double C = 2*omega/(c*c*h_ev*h_ev*h_ev);
    double kT = k_ev*T;
    mu = mu/q;
    
    if (P==2)
        return C * (((2*kT*kT*kT + 2*Eg*kT*kT + Eg*Eg*kT) * exp(mu/kT - Eg/kT))  -  ((2*kT*kT*kT + 2*Ej*kT*kT + Ej*Ej*kT) * exp(mu/kT - Ej/kT)));
    
    if(P==3)
        return q * C * (((6*(kT*kT*kT*kT) + 6*Eg*(kT*kT*kT) + 3*(Eg*Eg)*(kT*kT)  +  (Eg*Eg*Eg)*kT) * exp(mu/kT - Eg/kT)) - ((6*(kT*kT*kT*kT) + 6*Ej*(kT*kT*kT) + 3*(Ej*Ej)*(kT*kT) + (Ej*Ej*Ej)*kT) * exp(mu/kT - Ej/kT)));
    
    return 0.0;
    
}
