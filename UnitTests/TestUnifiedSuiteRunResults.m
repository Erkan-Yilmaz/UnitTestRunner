//
//  TestUnifiedSuiteRunResults.mm
//  QuickAccess
//
//  Created by Scott Thompson on 7/10/08.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#include <libxml/debugXML.h>

#import "TestUnifiedSuiteRunResults.h"
#import <SenTestingKit/SenTestCase.h>
#import <SenTestingKit/SenTestSuiteRun.h>

#import "UnifiedSuiteRunResults.h"
#import "UnifiedTestCaseRunResult.h"

NSString *kTestSuiteRunName = @"testSuiteRun";

@interface MockSenTestSuiteRun  : SenTestSuiteRun
- (NSArray *) testRuns;
- (unsigned int) failureCount;
- (unsigned int) unexpectedExceptionCount;
- (NSTimeInterval) testDuration;
@end;

@implementation TestUnifiedSuiteRunResults

- (void) setUp
{
	testSuiteRun = [[UnifiedSuiteRunResults alloc] initWithSuiteName: kTestSuiteRunName];
	mockSenTestRun = [[MockSenTestSuiteRun alloc] init];
}

- (void) tearDown
{
	[testSuiteRun release];
}

- (void) testProperties
{
	STAssertEquals([testSuiteRun suiteName], kTestSuiteRunName, nil);
	STAssertTrue(0 == [testSuiteRun.testCaseResults count], nil);
}

- (void) testAddTestCaseResult
{
	UnifiedTestCaseRunResult *testCaseResult = [[UnifiedTestCaseRunResult alloc] initWithTestName: @"testResult"];
	[testSuiteRun addTestCaseResult: testCaseResult];
	[testCaseResult release];

	STAssertTrue(1 == [testSuiteRun.testCaseResults count], nil);
	STAssertTrue(1 == testSuiteRun.numTests, nil);
}

- (void) testGenerateXML
{

	UnifiedTestCaseRunResult *testCaseResult = [[UnifiedTestCaseRunResult alloc] initWithTestName: @"testResult"];
	[testCaseResult addFailure: @"Some failure"];
	[testCaseResult addError: @"Some Error"];
	testCaseResult.runTime = 42.0;
	[testSuiteRun addTestCaseResult: testCaseResult];
	[testCaseResult release];

	xmlNodePtr xunitNode = [testSuiteRun createXUnitNode];

	STAssertTrueNoThrow(NULL != xunitNode, nil);
	STAssertTrue(xmlStrcmp(xunitNode->name, kXUnit_TestSuiteElementName) == 0, nil);

	xmlChar *nameAttribute = xmlGetNoNsProp(xunitNode, kXUnit_TestSuiteNameAttribute);
	STAssertTrue(NULL != nameAttribute, nil);
	if(nameAttribute) {
		STAssertTrue(xmlStrcmp(nameAttribute, (xmlChar *) "testSuiteRun") == 0, nil);
		xmlFree(nameAttribute); nameAttribute = NULL;
	}

	xmlChar *numTestsAttribute = xmlGetNoNsProp(xunitNode, kXUnit_TestSuiteNumTestsAttribute);
	STAssertTrue(NULL != numTestsAttribute, nil);
	if(numTestsAttribute) {
		STAssertTrue(xmlStrcmp(numTestsAttribute, (xmlChar *) "1") == 0, nil);
		xmlFree(numTestsAttribute); numTestsAttribute = NULL;
	}

	xmlChar *numFailures = xmlGetNoNsProp(xunitNode, kXUnit_TestSuiteNumFailuresAttribute);
	STAssertTrue(NULL != numFailures, nil);
	if(numFailures)
	{
		STAssertTrue(xmlStrcmp(numFailures, (xmlChar *) "1") == 0, nil);
		xmlFree(numFailures); numFailures = NULL;
	}

	xmlChar *numErrors = xmlGetNoNsProp(xunitNode, kXUnit_TestSuiteNumErrorsAttribute);
	STAssertTrue(NULL != numErrors, nil);
	if(numErrors)
	{
		STAssertTrue(xmlStrcmp(numErrors, (xmlChar *) "1") == 0, nil);
		xmlFree(numErrors); numErrors = NULL;
	}

	xmlChar *runTime = xmlGetNoNsProp(xunitNode, kXUnit_TestSuiteRunTimeAttribute);
	STAssertTrue(NULL != runTime, nil);
	if(runTime)
	{
		STAssertTrue(atof((const char *) runTime) == 42.0f, nil);
		xmlFree(runTime); runTime = NULL;
	}

	xmlFreeNode(xunitNode); xunitNode = NULL;
}

- (void) testGenerateXMLWithTestCase
{
	UnifiedTestCaseRunResult *testCaseResult = [[UnifiedTestCaseRunResult alloc] initWithTestName: @"testResult"];
	
	[testSuiteRun addTestCaseResult: testCaseResult];
	[testCaseResult release]; testCaseResult = NULL;

	xmlNodePtr xunitNode = [testSuiteRun createXUnitNode];
	STAssertTrueNoThrow(NULL != xunitNode, nil);

	// Make sure there is a child element from the test case
	STAssertTrue(1 == xmlLsCountNode(xunitNode), nil);
	STAssertTrue(0 == xmlStrcmp(xunitNode->children->name, kXUnit_TestCaseElementName), nil);

	xmlFreeNode(xunitNode); xunitNode = NULL;
}

- (void) testFailing
{
}
@end

@implementation MockSenTestSuiteRun
- (NSArray *) testRuns
{
	return [NSArray arrayWithObjects:
				[NSNumber numberWithInt: 0],
				[NSNumber numberWithInt: 1],
				nil];
}

- (unsigned int) failureCount
{
	return 42;
}

- (unsigned int) unexpectedExceptionCount
{
	return 84;
}

- (NSTimeInterval) testDuration
{
	return 42.0;
}
@end