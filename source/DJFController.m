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
    concentration.value = [concentrationSlider doubleValue];
    [self setEg1:Eg1];
}

@synthesize Eg1;
@synthesize Eg2;
@synthesize Eg3;

- (id) init
{
  self = [super init];
  if (self != nil) {
      
  concentration = [[DJFConcentration alloc] init];
  concentration.value = 1.0;
  }
  return self;
}

-(void) awakeFromNib
{
  [radioButtons selectCell:0];
  [view setJunctions:0];
  [radioButtons selectCell:[[radioButtons cells] objectAtIndex:0]];
  single = [[MJSingle alloc] init];
  tandem = [[MJTandem alloc] init];
  triple = [[MJTriple alloc] init];
  view.controller = self;
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *rtfDocPath = [bundle pathForResource:@"currentLabel" ofType:@"rtf"];
  NSData *rtfData = [NSData dataWithContentsOfFile:rtfDocPath];
  [currentUnits setAttributedStringValue:[[NSAttributedString alloc] initWithRTF:rtfData documentAttributes:NULL]];


  
}

- (void) junctionChanged:(NSNotification *)notification
{

}


- (void) setEg1:(double) newEg1
{

  Eg1 = newEg1;
  single.Eg1 = Eg1;
  single.concentration = concentration.value;
  NSLog(@"-setEg1 in controller");
  NSLog(@"Eg = %g",single.efficiency);
  NSLog(@"Concentration %g",concentration.value);
  
  efficiency.isSplit = NO;
  current.isSplit = NO;
  voltage.isSplit = NO;
  power.isSplit = NO;
  [efficiencyLabel setStringValue:[NSString stringWithFormat:@"%.0f%%",single.efficiency*100]];
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
  tandem.Eg1 = Eg1;
  tandem.Eg2 = Eg2;
  NSLog(@"-setEg1:%g Eg2:%g in controller",Eg1, Eg2);
  
  
  
  //[efficiencyLabel setStringValue:[NSString stringWithFormat:@"%g",tandem.efficiency*100]];
  //[currentLabel setStringValue:[NSString stringWithFormat:@"%g", tandem.Jm]];
  //[voltageLabel setStringValue:[NSString stringWithFormat:@"%g", tandem.Vm]];
  //[currentLabel setHidden:YES];
  //[voltageLabel setHidden:YES];
  
  [efficiencyLabel setStringValue:[NSString stringWithFormat:@"%.0f%%",tandem.efficiency*100]];
  [powerLabel setStringValue:[NSString stringWithFormat:@"%.0f (W)", tandem.efficiency*analyticalSolarConstant]];
  [currentLabel setStringValue:[NSString stringWithFormat:@"%.0f (A)", tandem.efficiency*analyticalSolarConstant/tandem.Vm]];
  [voltageLabel setStringValue:[NSString stringWithFormat:@"%.2f (V)", tandem.Vm]];
  
  efficiency.isSplit = YES;
  current.isSplit = YES;
  voltage.isSplit = YES;
  power.isSplit = YES;
  
  //[efficiency setFillLevel:tandem.efficiency];
  efficiency.lowerFillLevel = (tandem.Vm1 * tandem.Jm1)/analyticalSolarConstant;
  efficiency.upperFillLevel = (tandem.Vm2 * tandem.Jm2)/analyticalSolarConstant;
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
