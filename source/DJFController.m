//
//  DJFController.m
//  Drag tracking area
//
//  Created by Daniel Farrell on 26/04/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import "DJFController.h"
#import "DJFView.h"
#import "DJFSplitDataBar.h"
#import "DJFConcentration.h"
#import "MJSingle.h"
#import "MJTandem.h"
#import "MJTriple.h"
#import "pvconstants.h"

@implementation DJFController

@dynamic concentration;

- (DJFConcentration*) concentration
{
  return concentration;
}

- (void) setConcentration: (DJFConcentration*) newConcentration
{
  NSLog(@"Setting conc.");
  [newConcentration retain];
  [concentration release];
  concentration = newConcentration;
}

- (IBAction)updateConcentration:(id)sender {
  NSLog(@"selected cell %@", [radioButtons selectedCell]);
    concentration.value = [concentrationSlider doubleValue];
    if([[radioButtons cells] indexOfObject:[radioButtons selectedCell]] == 0)
      [self setEg1:Eg1];
    
    if([[radioButtons cells] indexOfObject:[radioButtons selectedCell]] == 1)
      [self setEg1:Eg1 Eg2:Eg2];
}

@synthesize Eg1;
@synthesize Eg2;
@synthesize Eg3;

- (id) init
{
  self = [super init];
  if (self != nil) {
      
  concentration = [[DJFConcentration alloc] init];
  concentration.value = [concentrationSlider doubleValue];
  single = [[MJSingle alloc] init];
  tandem = [[MJTandem alloc] init];
  triple = [[MJTriple alloc] init];
  }
  return self;
}

-(void) awakeFromNib
{
  [radioButtons selectCell:0];
  [view setJunctions:0];
  [radioButtons selectCell:[[radioButtons cells] objectAtIndex:0]];
  view.controller = self;
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *rtfDocPath = [bundle pathForResource:@"currentLabel" ofType:@"rtf"];
  NSData *rtfData = [NSData dataWithContentsOfFile:rtfDocPath];
  [currentUnits setAttributedStringValue:[[NSAttributedString alloc] initWithRTF:rtfData documentAttributes:NULL]];
  [self setEg1:[view selectedDataPoint]];
  NSLog(@"[view selectedDataPoint] = %g",[view selectedDataPoint]); 
  NSLog(@"[view selectedViewPoint] = %g",[view selectedViewPoint]);  
  [view setNeedsDisplay:YES];
}

- (IBAction)updateJunctions:(id)sender
{
  unsigned selectedIndex = [[radioButtons cells] indexOfObject:[radioButtons selectedCell]];
  if (selectedIndex == 0)
    [self setEg1:Eg1];
  else
    [self setEg1:Eg1 Eg2:Eg2];
  
}


- (void) setEg1:(double) newEg1
{

  Eg1 = newEg1;
  single.concentration = concentration.value;
  single.Eg = Eg1;
  NSLog(@"-setEg1 in controller");
  NSLog(@"Eg = %g",single.efficiency);
  NSLog(@"Concentration %g",single.concentration);
  
  efficiency.isSplit = NO;
  current.isSplit = NO;
  voltage.isSplit = NO;
  power.isSplit = NO;
  [efficiencyLabel setStringValue:[NSString stringWithFormat:@"%.1f%%",single.efficiency*100]];
  [efficiency setFillLevel:single.efficiency];
  [powerLabel setStringValue:[NSString stringWithFormat:@"%.0f (W)", single.Jm * single.Vm]];
  [currentLabel setStringValue:[NSString stringWithFormat:@"%.0f (A)", single.Jm]];
  [voltageLabel setStringValue:[NSString stringWithFormat:@"%.2f (V)", single.Vm]];
  [current setFillLevel:single.Jm/(q*analyticalSolarConstantFlux)];
  [power setFillLevel:single.efficiency];
  [voltage setFillLevel:single.Vm/2.8]; 
  [efficiency setNeedsDisplay:YES];
  [current setNeedsDisplay:YES];
  [voltage setNeedsDisplay:YES];
  [power setNeedsDisplay:YES];
  
}


- (void) setEg1: (double) newEg1 Eg2: (double) newEg2
{
  Eg1 = newEg1;
  Eg2 = newEg2;
  tandem.concentration = concentration.value;
  NSLog(@"conc value = %g",concentration.value);
  tandem.Eg1 = Eg1;
  tandem.Eg2 = Eg2;
  NSLog(@"-setEg1:%g Eg2:%g in controller",Eg1, Eg2);
  
  
  
  //[efficiencyLabel setStringValue:[NSString stringWithFormat:@"%g",tandem.efficiency*100]];
  //[currentLabel setStringValue:[NSString stringWithFormat:@"%g", tandem.Jm]];
  //[voltageLabel setStringValue:[NSString stringWithFormat:@"%g", tandem.Vm]];
  //[currentLabel setHidden:YES];
  //[voltageLabel setHidden:YES];
  
  [efficiencyLabel setStringValue:[NSString stringWithFormat:@"%.1f%%",tandem.efficiency*100]];
  [powerLabel setStringValue:[NSString stringWithFormat:@"%.0f (W)", tandem.efficiency*analyticalSolarConstant]];
  [currentLabel setStringValue:[NSString stringWithFormat:@"%.0f (A)", tandem.efficiency*analyticalSolarConstant/tandem.Vm]];
  [voltageLabel setStringValue:[NSString stringWithFormat:@"%.2f (V)", tandem.Vm]];
  
  efficiency.isSplit = YES;
  current.isSplit = YES;
  voltage.isSplit = YES;
  power.isSplit = YES;
  
  //[efficiency setFillLevel:tandem.efficiency];
  efficiency.lowerFillLevel = (tandem.Vm1 * tandem.Jm1)/(analyticalSolarConstant);
  efficiency.upperFillLevel = (tandem.Vm2 * tandem.Jm2)/(analyticalSolarConstant);
  [voltage setLowerFillLevel:tandem.Vm1/6.0];
  [voltage setUpperFillLevel:tandem.Vm2/6.0];
  [current setLowerFillLevel:tandem.Jm1/(q*analyticalSolarConstantFlux)];
  [current setUpperFillLevel:tandem.Jm2/(q*analyticalSolarConstantFlux)];
  [power setLowerFillLevel:(tandem.Vm1 * tandem.Jm1)/(analyticalSolarConstant)];
  [power setUpperFillLevel:(tandem.Vm2 * tandem.Jm2)/(analyticalSolarConstant)];
  //[current setFillLevel:tandem.Jm/(q*analyticalSolarConstantFlux)];
  //[voltage setFillLevel:tandem.Vm/4.2]; 
  [efficiency setNeedsDisplay:YES];
  [current setNeedsDisplay:YES];
  [voltage setNeedsDisplay:YES];
  [power setNeedsDisplay:YES];
}

- (void) setEg1: (double) newEg1 Eg2: (double) newEg2 Eg3: (double) newEg3
{
  Eg1 = newEg1;
  Eg2 = newEg2;
  Eg3 = newEg3;
  triple.Eg1 = Eg1;
  triple.Eg2 = Eg2;
  triple.Eg3 = Eg3;
  NSLog(@"-setEg1:%g Eg2:%g Eg3:%g in controller",Eg1, Eg2, Eg3);

  [efficiencyLabel setStringValue:[NSString stringWithFormat:@"%g",triple.efficiency*100]];
  [currentLabel setStringValue:[NSString stringWithFormat:@"%g", triple.Jm]];
  [voltageLabel setStringValue:[NSString stringWithFormat:@"%g", triple.Vm]];
  
  [efficiency setFillLevel:triple.efficiency];
  [current setFillLevel:triple.Jm/(q*analyticalSolarConstantFlux)];
  [voltage setFillLevel:triple.Vm/6.2]; 
  [efficiency setNeedsDisplay:YES];
  [current setNeedsDisplay:YES];
  [voltage setNeedsDisplay:YES];
}

@end
