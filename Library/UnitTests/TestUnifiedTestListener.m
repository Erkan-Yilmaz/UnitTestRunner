//
//  TestUnifiedTestListener.mm
//  UnitTestRunner
//
//  Created by Scott Thompson on 7/11/08.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#include <libxml/debugXML.h>

#import "TestUnifiedTestListener.h"
#import "UnifiedTestListener.h"
#import "UnifiedSuiteRunResults.h"
#import <SenTestingKit/SenTestCaseRun.h>

@interface MockSenTest : SenTestCase
- (NSString *) name;
@end

@implementation TestUnifiedTestListener

- (void) setUp
{		
	testListener = [[UnifiedTestListener alloc] init];
}

- (void) tearDown
{
	[testListener release];
}

- (void) testSingleton
{
	UnifiedTestListener *singletonInstance = [UnifiedTestListener sharedUnifiedListener];
	STAssertNotNil(singletonInstance, nil);
}

- (void) testGenerateBasicXML
{
	xmlDocPtr resultsDoc = [testListener.runResults createXUnitDoc];
	STAssertTrue(NULL != resultsDoc, nil);

	if(NULL != resultsDoc)
	{
		// Get the root node which should be a testsuite element
		xmlNodePtr rootNode = xmlDocGetRootElement(resultsDoc);
		STAssertTrue(NULL != rootNode, nil);
		if(NULL != rootNode) 
		{
			STAssertTrue(XML_ELEMENT_NODE == rootNode->type, nil);
			STAssertTrue(0 == xmlStrcmp(kXUnit_TestSuiteElementName, rootNode->name), nil);
		}

		xmlFreeDoc(resultsDoc);
	}
}

- (void) testGenerateXMLWithSenTestResult
{
	// add a sen test result to the listener
	MockSenTest *mockTest = [[MockSenTest alloc] init];
	SenTestCaseRun *mockTestRun = [SenTestCaseRun testRunWithTest: mockTest];
	[mockTest release];

	NSNotification *mockStartNotification = 
		[NSNotification notificationWithName: SenTestCaseDidStartNotification 
									  object: mockTestRun];

	NSNotification *mockStopNotification = 
		[NSNotification notificationWithName: SenTestCaseDidStopNotification 
									  object: mockTestRun];

	// pretend that the test started and stopped.
	[testListener senTestCaseDidStart: mockStartNotification];
	[testListener senTestCaseDidStop: mockStopNotification];

	// generate XML
	xmlDocPtr resultsDoc = [testListener.runResults createXUnitDoc];
	if(NULL != resultsDoc)
	{
		// verify that the root node has one test result
		xmlNodePtr rootNode = xmlDocGetRootElement(resultsDoc);
		if(NULL != rootNode) 
		{
			STAssertTrue(1 == xmlLsCountNode(rootNode), nil);
		}

		xmlFreeDoc(resultsDoc);
	}
}

@end

@implementation MockSenTest
- (NSString *) name
{
	return @"MockSenTest";
}
@end
