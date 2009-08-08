//
//  DJFController.h
//  Drag tracking area
//
//  Created by Daniel Farrell on 26/04/2009.
//  Copyright 2009 Daniel J Farrell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class DJFView;
@class DJFSplitDataBar;
@class DJFConcentration;
@class MJSingle;
@class MJTandem;
@class MJTriple;


@interface DJFController : NSObject {
  IBOutlet NSMatrix *radioButtons;
  IBOutlet NSButtonCell *initialButton;
  IBOutlet DJFView *view;
  IBOutlet DJFSplitDataBar *current;
  IBOutlet DJFSplitDataBar *voltage;
  IBOutlet DJFSplitDataBar *efficiency;
  IBOutlet DJFSplitDataBar *power;
  IBOutlet NSTextField *currentLabel;
  IBOutlet NSTextField *voltageLabel;
  IBOutlet NSTextField *efficiencyLabel;
  IBOutlet NSTextField *powerLabel;
  IBOutlet NSTextField *currentUnits;
  IBOutlet NSTextField *currentBottomLabel;
  IBOutlet NSTextField *voltageBottomLabel;
  IBOutlet NSTextField *efficiencyBottomLabel;
  IBOutlet NSSlider *concentrationSlider;
  IBOutlet NSObjectController *concentrationController;
  DJFConcentration *concentration;
  double Eg1, Eg2, Eg3;
  MJSingle *single;
  MJTandem *tandem;
  MJTriple *triple;
}

@property (retain) DJFConcentration * concentration;
- (IBAction)updateConcentration:(id)sender;
@property (assign) double Eg1;
@property (assign) double Eg2;
@property (assign) double Eg3;
- (void) setEg1: (double) newEg1 Eg2: (double) newEg2;
- (void) setEg1: (double) newEg1 Eg2: (double) newEg2 Eg3: (double) newEg3;
@end
