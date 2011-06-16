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

@interface TestRunResultsDialog ()
@property (nonatomic, readwrite, retain) TestSuiteResultViewController *testResultsViewController;
@end

@implementation TestRunResultsDialog

@synthesize delegate;
@synthesize doneButton;
@synthesize testResultsViewController;

+ (TestRunResultsDialog *) createRunResultsDialogWithDelegate: (id <NSObject, TestRunResultsDialogDelegate>) delegate
{
	TestSuiteResultViewController *testResultsViewController = [[TestSuiteResultViewController alloc] initWithNibName: @"TestSuiteRunResults" bundle: [UnitTestRunnerResources resourceBundle]];    
	TestRunResultsDialog *testResultsDialog = [[TestRunResultsDialog alloc] initWithRootViewController: testResultsViewController];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: testResultsDialog action: @selector(closeDialog:)];
    testResultsViewController.navigationItem.rightBarButtonItem = doneButton;
    testResultsViewController.navigationItem.title = @"Unit Test Runner";

    testResultsDialog.testResultsViewController = testResultsViewController;
    testResultsDialog.doneButton = doneButton;

    [testResultsViewController release];
    [doneButton release];

	testResultsDialog.delegate = delegate;

	return [testResultsDialog autorelease];
}

- (void) dealloc
{
	self.doneButton = nil;
    self.testResultsViewController = nil;

    [super dealloc];
}

- (void) viewDidLoad
{
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
{
    return YES;
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
	self.testResultsViewController.runResults = runResults;
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
