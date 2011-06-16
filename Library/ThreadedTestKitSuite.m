//
//  ThreadedTestKitSuite.mm
//  MXServerConnect
//
//  Created by Scott Thompson on 4/9/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

/*
	This class is simply a test suite that runs the current run loop for the
	thread that is executing the test suite between each test.  That way, if
	the test relies on run loop functionality, that test will run properly.
*/
#import "ThreadedTestKitSuite.h"
#import "SenTestingKit/SenTestSuiteRun.h"

@implementation ThreadedTestKitSuite

- (void) performTest:(SenTestRun *) aTestRun
{
    [self setUp];
    [aTestRun start];
	{
		NSEnumerator *testEnumerator = [[self valueForKey: @"tests"] objectEnumerator];
		SenTest *eachTest;
		while (nil != (eachTest = [testEnumerator nextObject])) 
		{
			NSAutoreleasePool *localPool = [[NSAutoreleasePool alloc] init];
			[(SenTestSuiteRun *) aTestRun addTestRun: [eachTest run]];

			// Sit in the run loop for a bit.
			[[NSRunLoop currentRunLoop] runUntilDate: [NSDate dateWithTimeIntervalSinceNow: 0.05]];
			[localPool release];
		}
	}

    [aTestRun stop];
    [self tearDown];
}

@end
