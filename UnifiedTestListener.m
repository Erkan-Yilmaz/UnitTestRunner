//
//  UnifiedTestListener.mm
//  QuickAccess
//
//  Created by Scott Thompson on 7/9/08.
//  Copyright 2008 Scott Thompson. All rights reserved.
//

#import <libxml/xmlversion.h>
#import <libxml/tree.h>
#import <libxml/xmlIO.h>

#import "UnifiedTestListener.h"
#import "UnifiedSuiteRunResults.h"

#import <SenTestingKit/SenTestSuiteRun.h>
#import <SenTestingKit/SenTestCaseRun.h>
#import <SenTestingKit/NSException_SenTestFailure.h>

#import "UnifiedSuiteRunResults.h"
#import "UnifiedTestCaseRunResult.h"

@implementation UnifiedTestListener

@synthesize runResults;

+ (UnifiedTestListener *) sharedUnifiedListener
{
	static UnifiedTestListener *gListenerSingleton = nil;
	if(nil == gListenerSingleton)
	{
		gListenerSingleton = [[UnifiedTestListener alloc] init];
	}

	return gListenerSingleton;
}

- (id) init
{
	self = [super init];
	if(self)
	{
		runResults = [[UnifiedSuiteRunResults alloc] initWithSuiteName: @"Test Results"];
	}

	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter]
		removeObserver: self];

	[currentTestCaseResult release];
	[runResults release];

	[super dealloc];
}

- (void) senTestCaseDidStart: (NSNotification *) notification
{
	[currentTestCaseResult release];

	SenTestCaseRun *testThatStarted = [notification object];

	NSString *testName = nil;
	NSString *testClass = nil;

	// Split out the class name and the test name into separate bits.
	if([testThatStarted.test.name hasPrefix: @"-["] && [testThatStarted.test.name hasSuffix: @"]"])
	{
		// This should be something like '-[SomeTestClass testSomethingInteresting]'.. we try to break it up
		NSString *testClassAndTestName = [testThatStarted.test.name substringWithRange: NSMakeRange(2, [testThatStarted.test.name length] - 3)];
		NSArray *parts = [testClassAndTestName componentsSeparatedByString: @" "];

		testClass = [parts objectAtIndex: 0];
		testName = [parts objectAtIndex: 1];
	} else {
		testName = testThatStarted.test.name;
		testClass = NSStringFromClass([[testThatStarted test] class]);
	}

	currentTestCaseResult =
		[[UnifiedTestCaseRunResult alloc] initWithTestName: testName];
	currentTestCaseResult.className = testClass;
}

- (void) senTestCaseDidStop: (NSNotification *) notification
{
	SenTestCaseRun *testThatFinished = [notification object];
	currentTestCaseResult.runTime = [testThatFinished totalDuration];
	[runResults addTestCaseResult: currentTestCaseResult];
}

- (void) senTestCaseDidFail: (NSNotification *) notification
{
	SenTestCaseRun *testThatFailed = [notification object];
	NSArray *exceptions = [testThatFailed exceptions];

	for(NSException *anException in exceptions)
	{
		if([[anException name] isEqualToString: SenTestFailureException])
		{
			[currentTestCaseResult addFailure: [anException reason]];
		} else {
			[currentTestCaseResult addError: [anException reason]];
		}
	}
}

- (void) observeSenTestResults
{
	[[NSNotificationCenter defaultCenter]
	    addObserver: self
		   selector: @selector(senTestCaseDidStart:)
			   name: SenTestCaseDidStartNotification
			 object: nil];

	[[NSNotificationCenter defaultCenter]
		addObserver: self
		   selector: @selector(senTestCaseDidStop:)
			   name: SenTestCaseDidStopNotification
			 object: nil];

	[[NSNotificationCenter defaultCenter]
		addObserver: self
		   selector: @selector(senTestCaseDidFail:)
			   name: SenTestCaseDidFailNotification
			 object: nil];
}

- (void) stopObservingSenTestResults
{
	[[NSNotificationCenter defaultCenter]
	    removeObserver: self
			      name: SenTestCaseDidStartNotification
			    object: nil];

	[[NSNotificationCenter defaultCenter]
		removeObserver: self
			      name: SenTestCaseDidStopNotification
			     object: nil];

	[[NSNotificationCenter defaultCenter]
		removeObserver: self
			      name: SenTestCaseDidFailNotification
			    object: nil];
}

@end
