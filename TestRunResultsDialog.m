//
//  TestRunResultsDialog.m
//  UnitTestRunner
//
//  Created by Scott Thompson on 7/2/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import "TestRunResultsDialog.h"

#import "TestSuiteResultViewController.h"
#import "UnitTestRunnerResources.h"
#import "UnifiedTestListener.h"
#import "ThreadedTestKitSuite.h"

@implementation TestRunResultsDialog

@synthesize delegate;
@synthesize navBar;
@synthesize doneButton;

+ (TestRunResultsDialog *) createRunResultsDialogWithDelegate: (id <NSObject, TestRunResultsDialogDelegate>) delegate
{
	TestRunResultsDialog *testResultsViewer = [[TestRunResultsDialog alloc] initWithNibName: @"TestRunResultsDialog"
																					 bundle: [UnitTestRunnerResources resourceBundle]];
	testResultsViewer.delegate = delegate;
	return [testResultsViewer autorelease];
}

- (void) viewDidLoad
{
	testResultsViewController =
		[[TestSuiteResultViewController alloc] initWithNibName: @"TestSuiteRunResults" bundle: [UnitTestRunnerResources resourceBundle]];

	testResultsViewController.view.frame = CGRectMake(	CGRectGetMinX(self.view.frame),
														CGRectGetMaxY(navBar.frame),
														self.view.frame.size.width,
														self.view.frame.size.height - navBar.frame.size.height);

	[self.view addSubview: testResultsViewController.view];
}


- (void)dealloc
{
	self.doneButton = nil;
	self.navBar = nil;

    [super dealloc];
}

- (IBAction) closeDialog: (id) sender
{
	if(delegate && [delegate respondsToSelector: @selector(testRunResultsDialogDone:)])
	{
		[delegate testRunResultsDialogDone: self];
	}
}

- (IBAction) runAllUnitTests: (id) sender
{
	[self performSelectorInBackground: @selector(runTests) withObject: nil];
}

- (void) runTests
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	[self performSelectorOnMainThread: @selector(threadedTestRunHasBegun) withObject: nil waitUntilDone: NO];

	// Install our own observer
	UnifiedTestListener *testListener = [UnifiedTestListener sharedUnifiedListener];
	[testListener observeSenTestResults];

	ThreadedTestKitSuite *defaultSuite = [ThreadedTestKitSuite defaultTestSuite];
	[defaultSuite run];

	[testListener stopObservingSenTestResults];

	[self performSelectorOnMainThread: @selector(threadedTestRunFinishedWithResults:) withObject: testListener.runResults waitUntilDone: NO];

	[pool release];
	pool = nil;

	[[NSRunLoop currentRunLoop] run];
}

- (void) threadedTestRunHasBegun
{
	doneButton.enabled = NO;
	if(self.delegate && [self.delegate respondsToSelector: @selector(testRunDialogBeganTests:)])
	{
		[self.delegate testRunDialogBeganTests: self];
	}
}

- (void) threadedTestRunFinishedWithResults: (UnifiedSuiteRunResults *) runResults
{
	testResultsViewController.runResults = runResults;
#if 0
	// Put the XML doc out to stdout
	xmlDocPtr outputDoc = [runResults createXUnitDoc];
	if(nil != outputDoc)
	{
		xmlSaveCtxtPtr saveContext = xmlSaveToFd(
												 STDOUT_FILENO,
												 xmlGetCharEncodingName(XML_CHAR_ENCODING_UTF8),
												 0);
		xmlSaveDoc(saveContext, outputDoc);
		xmlSaveClose(saveContext); saveContext = NULL;

		xmlFreeDoc(outputDoc);
		outputDoc = NULL;
	}
#endif

	if(self.delegate && [self.delegate respondsToSelector: @selector(testRunDialogFinishedTests:)])
	{
		[self.delegate testRunDialogFinishedTests: self];
	}

	doneButton.enabled = YES;
}


@end
