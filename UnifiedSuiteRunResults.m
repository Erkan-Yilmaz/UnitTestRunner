//
//  UnifiedSuiteRunResults.mm
//  UnitTestRunner
//
//  Created by Scott Thompson on 7/10/08.
//  Copyright 2008 Scott Thompson. All rights reserved.
//

#import "UnifiedSuiteRunResults.h"
#import "UnifiedTestCaseRunResult.h"

#import "libxmlHelpers.h"

const xmlChar *kXUnit_TestSuiteElementName = (xmlChar *) "testsuite";
const xmlChar *kXUnit_TestSuiteNameAttribute = (xmlChar *) "name";
const xmlChar *kXUnit_TestSuiteNumTestsAttribute = (xmlChar *) "tests";
const xmlChar *kXUnit_TestSuiteNumFailuresAttribute = (xmlChar *) "failures";
const xmlChar *kXUnit_TestSuiteNumErrorsAttribute = (xmlChar *) "errors";
const xmlChar *kXUnit_TestSuiteRunTimeAttribute = (xmlChar *) "time";

@implementation UnifiedSuiteRunResults

@synthesize suiteName;

- (NSArray *) testCaseResults
{
	return (NSArray *) testCaseResults;
}

- (id) initWithSuiteName: (NSString *) newSuiteName
{
	self = [super init];
	if(self)
	{
		suiteName = [newSuiteName copy];

		testCaseResults = [[NSMutableArray array] retain];
	}

	return self;
}

- (void) dealloc
{
	[testCaseResults release];
	[super dealloc];
}

- (int) numTests
{
	return [testCaseResults count];
}

- (int) numFailures
{
	int retVal = 0;
	for(UnifiedTestCaseRunResult *testCaseResult in testCaseResults)
	{
		retVal += [testCaseResult.failures count];
	}

	return retVal;
}

- (int) numErrors
{
	int retVal = 0;
	for(UnifiedTestCaseRunResult *testCaseResult in testCaseResults)
	{
		retVal += [testCaseResult.errors count];
	}

	return retVal;
}

- (NSTimeInterval) runTime
{
	float retVal = 0;
	for(UnifiedTestCaseRunResult *testCaseResult in testCaseResults)
	{
		retVal += testCaseResult.runTime;
	}

	return retVal;
}

- (void) addTestCaseResult: (UnifiedTestCaseRunResult *) testCaseResult
{
	[testCaseResults addObject: testCaseResult];
}

- (xmlDocPtr) createXUnitDoc
{
	xmlDocPtr xmlDocument = xmlNewDoc((xmlChar *)"1.0");
	xmlNodePtr resultsNode = [self createXUnitNode];

	xmlDocSetRootElement(xmlDocument, resultsNode);

	return xmlDocument;
}

- (xmlNodePtr) createXUnitNode
{
	xmlNodePtr result = NULL;
	result = xmlNewNode(NULL, kXUnit_TestSuiteElementName);
	if(NULL != result)
	{
		xmlChar *xmlString = CreateXMLStringFromNSString(suiteName);
		xmlSetProp(result, kXUnit_TestSuiteNameAttribute, xmlString);
		xmlFree(xmlString); xmlString = NULL;

		xmlChar xmlStringBuffer[15];
		sprintf((char *) xmlStringBuffer, "%d", self.numTests);
		xmlSetProp(result, kXUnit_TestSuiteNumTestsAttribute, xmlStringBuffer);

		sprintf((char *) xmlStringBuffer, "%d", self.numFailures);
		xmlSetProp(result, kXUnit_TestSuiteNumFailuresAttribute, xmlStringBuffer);

		sprintf((char *) xmlStringBuffer, "%d", self.numErrors);
		xmlSetProp(result, kXUnit_TestSuiteNumErrorsAttribute, xmlStringBuffer);

		sprintf((char *) xmlStringBuffer, "%f", self.runTime);
		xmlSetProp(result, kXUnit_TestSuiteRunTimeAttribute, xmlStringBuffer);

		for(UnifiedTestCaseRunResult *testResult in testCaseResults)
		{
			xmlNodePtr newChild = [testResult createXUnitNode];
			xmlAddChild(result, newChild);
		}
	}

	return result;
}
@end
