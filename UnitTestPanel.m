//
//  UnitTestPanel.m
//  TopicSpace
//
//  Created by Scott Thompson on 7/10/09.
//  Copyright 2009 Turing Complete, LLC. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "UnitTestPanel.h"
#import "UnifiedTestListener.h"
#import "UnifiedTestCaseRunResult.h"
#import "UnifiedSuiteRunResults.h"

@interface UnitTestCollectionItem : NSCollectionViewItem
@end

@implementation UnitTestPanel
@synthesize collectionView;
@synthesize successButton;
@synthesize failureButton;
@synthesize runResults;

+ (UnitTestPanel *) sharedUnitTestPanel
{
	static UnitTestPanel *sharedPanel = nil;
	if(nil == sharedPanel)
	{
		sharedPanel = [[UnitTestPanel alloc] initWithWindowNibName: @"UnitTestPanel"];
	}

	return sharedPanel;
}

- (void) dealloc
{
	self.collectionView = nil;
	self.runResults = nil;

	[super dealloc];
}

- (void) awakeFromNib
{
	[collectionView setMaxNumberOfColumns: 1];
}

- (void) runTests: (id) sender
{
	UnifiedTestListener *testListener = [UnifiedTestListener sharedUnifiedListener];
	[testListener observeSenTestResults];

	SenTestSuite *defaultSuite = [SenTestSuite defaultTestSuite];
	[defaultSuite run];

	[testListener stopObservingSenTestResults];

	self.runResults = testListener.runResults.testCaseResults;
}

- (void) setRunResults: (NSArray *) _runResults
{
	[runResults release];
	runResults = [_runResults retain];

	if(nil != _runResults)
	{
		NSUInteger successful = 0;
		NSUInteger failed = 0;

		for(UnifiedTestCaseRunResult *runResult in _runResults)
		{
			runResult.succeeded ? ++successful : ++failed;
		}


		NSString *successTitle = [NSString stringWithFormat: @"Successful: %d", successful];

		NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		[paragraphStyle setAlignment: NSCenterTextAlignment];

		NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSColor colorWithCalibratedRed: 0.0 green: 0.5 blue: 0.0 alpha: 1.0], NSForegroundColorAttributeName,
				[NSFont fontWithName: @"LucidaGrande-Bold" size: 12], NSFontAttributeName,
				paragraphStyle, NSParagraphStyleAttributeName,
				nil ];

		NSAttributedString *successString = [[NSAttributedString alloc] initWithString: successTitle
																			attributes: attributes];

		[successButton setAttributedTitle: successString];
		[successString release];



		NSString *failedTitle = [NSString stringWithFormat: @"Failed: %d", failed];
		NSDictionary *failedAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSColor colorWithCalibratedRed: 0.5 green: 0.0 blue: 0.0 alpha: 1.0], NSForegroundColorAttributeName,
				[NSFont fontWithName: @"LucidaGrande-Bold" size: 12], NSFontAttributeName,
				paragraphStyle, NSParagraphStyleAttributeName,
				nil ];

		[paragraphStyle release];

		NSAttributedString *failedString = [[NSAttributedString alloc] initWithString: failedTitle
																			attributes: failedAttributes];

		[failureButton setAttributedTitle: failedString];
		[failedString release];

	}
}


@end
