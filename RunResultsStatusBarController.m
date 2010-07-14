//
//  RunResultsStatusBarController.mm
//  MXServerConnect
//
//  Created by Scott Thompson on 5/8/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import "RunResultsStatusBarController.h"

@implementation RunResultsStatusBarController

@synthesize passedLabel;
@synthesize failedLabel;

@synthesize numberOfPassedTests;
@synthesize numberOfFailedTests;

- (void) setNumberOfPassedTests: (NSUInteger) newNumber
{
	numberOfPassedTests = newNumber;
	passedLabel.text = [NSString stringWithFormat: @"%d Passed", numberOfPassedTests];
}

- (void) setNumberOfFailedTests: (NSUInteger) newNumber
{
	numberOfFailedTests = newNumber;
	failedLabel.text = [NSString stringWithFormat: @"%d Failed", numberOfFailedTests];
}

@end
