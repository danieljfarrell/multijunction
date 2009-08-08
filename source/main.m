//
//  main.m
//  Drag tracking area
//
//  Created by Daniel Farrell on 31/03/2009.
//  Copyright Daniel J Farrell 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "pvconstants.h"
#import "gplanck.h"

int main(int argc, char *argv[])
{
    NSLog(@"%e",analyticalSimplifiedGeneralisedPlanck(0.0, Ts, 0.0, fs, 2));
    NSLog(@"%e",generalisedPlanck(0.0, Ts, 0.0, fs, 2));
    return NSApplicationMain(argc,  (const char **) argv);
}
