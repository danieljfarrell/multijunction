/*
 *  gplanck.h
 *  PC-model
 *
 *  Created by Daniel J Farrell on 20/04/2009.
 *  Copyright 2009 Daniel J Farrell. All rights reserved.
 *
 */

/* General purpose numberical integration using the trapezium rule */
double integrate (double *x, double *y, unsigned count);


/* Returns the solidangle (Sr) of a given concentration factor, X, which must be
number bewtween zero and 46200 otherwise an error is thrown.
*/
double solidangleFromConcentrationFactor (double X);


double concentrationFactorFromSolidangle (double omega);




/*
  Returns the value of the generalised Planck as the 
  specific values of energy E (J) (no integration is performed):
                    P
  2 omega          E
 -------   ------------------- 
   2   3     
  c  h       exp((E-mu)/kT)-1
            
*/

double generalisedPlanckValue (double E, double T, double mu, double omega, unsigned P);



/*
  Return the value of the generalised Planck without simplification: 
                inf
             /          P
 2 omega     |         E
 -------     | --------------------  dE
   2   3     |   
  c  h      /     exp((E-mu)/kT)-1
             Eg
Eg and mu must be in Joules, T in Kelvin, P=2 for 
he particle flux (photon/m^2/s), and, P=3 for the 
energy flux (J/m^2/s). Numberical integration is 
used and splits the specifiedrange up into 1000 
points between Eg and infinity (10eV).
*/
double generalisedPlanck (double Eg, double T, double mu, double omega, unsigned P);



/*
  Return the value of the generalised Planck without simplification: 
                inf
             /          P
 2 omega     |         E
 -------     | --------------------  dE
   2   3     |   
  c  h      /     exp((E-mu)/kT)-1
             Eg
Eg and mu must be in Joules, T in Kelvin, P=2 for 
he particle flux (photon/m^2/s), and, P=3 for the 
energy flux (J/m^2/s). Adaptive quadrature with
known siguarlity is use to find the values to known
error. 
*/

double generalisedPlanckQAGS (double Eg, double T, double mu, double omega, unsigned P);

/* Don't use this function, it is called from the QAGS Generalised Planck function. */
double f_GPValue (double x, void * params);


/* 
Returns the value of the simiplified generalised planck integral:
              inf
             /          P
 2 omega     |         E
 -------     | ------------------  dE
   2   3     |   
  c  h      /     exp((E-mu)/kT)
             Eg
Eg and mu must be in Joules, T in Kelvin, P=2 for 
he particle flux (photon/m^2/s), and, P=3 for the 
energy flux (J/m^2/s). This form of the equation
has an analytical solution as shown in the code.
*/

double analyticalSimplifiedGeneralisedPlanck(double Eg, double T, double mu, double omega, unsigned P);


/*

Returns the value of the simiplified generalised incomplete planck integral:
              Ej
             /          P
  2 omega    |         E
 -------     | ------------------  dE
   2   3     |   
  c  h      /     exp((E-mu)/kT)
             Eg
Eg, Ej, and mu must be in Joules, T in Kelvin, P=2 for 
the particle flux (photon/m^2/s), and, P=3 for the 
energy flux (J/m^2/s). This form of the equation
has an analytical solution as shown in the code.
*/

double analyticalSimplifiedIncompleteGeneralisedPlanck(double Eg, double Ej, double T, double mu, double omega, unsigned P);


