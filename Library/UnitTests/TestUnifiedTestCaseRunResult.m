//
//  TestUnifiedTestCaseRunResult.mm
//  UnitTestRunner
//
//  Created by Scott Thompson on 7/10/08.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import "TestUnifiedTestCaseRunResult.h"
#include <libxml/debugXML.h>

NSString *kTestCaseRunResultName = @"testCaseRunResult";

@implementation TestUnifiedTestCaseRunResult

- (void) setUp
{
	testRunResult = [[UnifiedTestCaseRunResult alloc] initWithTestName: kTestCaseRunResultName];
}

- (void) tearDown
{
	[testRunResult release];
	testRunResult = nil;
}

- (void) testProperties
{
	STAssertEquals(testRunResult.testName, kTestCaseRunResultName, nil);

	testRunResult.className = @"FindThisClassName";
	STAssertEquals(@"FindThisClassName", testRunResult.className, nil);

	testRunResult.runTime = 42.0;
	STAssertTrue( 42.0 == testRunResult.runTime, nil);
}

- (void) testAddFailure
{
	STAssertTrue([testRunResult.failures count] == 0, nil);
	[testRunResult addFailure: @"The test failed for this reason"];
	STAssertTrue([testRunResult.failures count] == 1, nil);
}

- (void) testAddError
{
	STAssertTrue([testRunResult.errors count] == 0, nil);
	[testRunResult addError: @"An unexpected error occurred"];
	STAssertTrue([testRunResult.errors count] == 1, nil);
}

- (void) testGenerateXML
{
	// Create a node that does not have a class name yet and make sure that
	// the class name comes back empty
	xmlNodePtr xunitNode = [testRunResult createXUnitNode];

	STAssertTrueNoThrow(NULL != xunitNode, nil);
	STAssertTrue(xmlStrcmp(xunitNode->name, kXUnit_TestCaseElementName) == 0, nil);

	xmlChar *classNameAttribute = xmlGetNoNsProp(xunitNode, kXUnit_TestCaseClassNameAttribute);
	STAssertTrue(NULL != classNameAttribute, nil);
	if(classNameAttribute)
	{
		STAssertTrue(xmlStrcmp(classNameAttribute, (xmlChar *) "") == 0, nil);
		xmlFree(classNameAttribute); classNameAttribute = NULL;
	}

	xmlChar *runTime = xmlGetNoNsProp(xunitNode, kXUnit_TestCaseRunTimeAttribute);
	STAssertTrue(NULL != runTime, nil);
	if(runTime)
	{
		STAssertTrue(atof((const char *) runTime) == 0.0f, nil);
		xmlFree(runTime); runTime = NULL;
	}

	xmlFreeNode(xunitNode); xunitNode = NULL;

	// assign some interesting values, regenerate the node, and test that
	// we get back the values we've added
	testRunResult.className = @"FindThisClassName";
	testRunResult.runTime = 42.0;

	xunitNode = [testRunResult createXUnitNode];
	STAssertTrueNoThrow(NULL != xunitNode, nil);
	STAssertTrue(xmlStrcmp(xunitNode->name, kXUnit_TestCaseElementName) == 0, nil);

	xmlChar *nameAttribute = xmlGetNoNsProp(xunitNode, kXUnit_TestCaseNameAttribute);
	STAssertTrue(NULL != nameAttribute, nil);
	if(nameAttribute) {
		STAssertTrue(xmlStrcmp(nameAttribute, (xmlChar *) "testCaseRunResult") == 0, nil);
		xmlFree(nameAttribute);
	}

	classNameAttribute = xmlGetNoNsProp(xunitNode, kXUnit_TestCaseClassNameAttribute);
	STAssertTrue(NULL != classNameAttribute, nil);
	if(classNameAttribute) {
		STAssertTrue(xmlStrcmp(classNameAttribute, (xmlChar *) "FindThisClassName") == 0, nil);
		xmlFree(classNameAttribute);
	}

	runTime = xmlGetNoNsProp(xunitNode, kXUnit_TestCaseRunTimeAttribute);
	STAssertTrue(NULL != runTime, nil);
	if(runTime) {
		STAssertTrue(atof((const char *) runTime) == 42.0f, nil);
		xmlFree(runTime);
	}

	// No failures or errors have been added to the test result so there should be
	// no children on the XML node.
	STAssertTrue(0 == xmlLsCountNode(xunitNode), nil);

	xmlFreeNode(xunitNode); xunitNode = NULL;
}

- (void) testGenerateXMLWithFailures
{
	// add a failure to the test node and generate an XML node from it.
	[testRunResult addFailure: @"The test failed for this reason"];
	xmlNodePtr xunitNode = [testRunResult createXUnitNode];
	if(xunitNode)
	{
		STAssertTrue(1 == xmlLsCountNode(xunitNode), nil);
		xmlNodePtr failureNode = xunitNode->children;

		STAssertTrue(xmlStrcmp(failureNode->name, kXUnit_TestCaseFailureElementName) == 0, nil);

		// ensure that the failure node has a child.  This should be a text node
		// with the text of the failure
		STAssertTrue(NULL != failureNode->children, nil);
        if(NULL != failureNode->children)
        {
            xmlNodePtr textNode = failureNode->children;
            STAssertTrue(XML_TEXT_NODE == textNode->type, nil);
            STAssertTrue(NULL != textNode->content, nil);
            STAssertTrue(xmlStrcmp(textNode->content, (xmlChar *) "The test failed for this reason") == 0, nil);            
        }

		xmlFreeNode(xunitNode); xunitNode = NULL;
	}
}

- (void) testGenerateXMLWithErrors
{
	// Add an error and generate an XML node.
	[testRunResult addError: @"An unexpected error occurred"];
	xmlNodePtr xunitNode = [testRunResult createXUnitNode];
	if(NULL != xunitNode) 
	{
		STAssertTrue(1 == xmlLsCountNode(xunitNode), nil);
		xmlNodePtr errorNode = xunitNode->children;

		STAssertTrue(xmlStrcmp(errorNode->name, kXUnit_TestCaseErrorElementName) == 0, nil);

		// ensure that the failure node has a child.  This should be a text node
		// with the text of the failure
		STAssertTrue(NULL != errorNode->children, nil);
        if(NULL != errorNode->children)
        {
            xmlNodePtr textNode = errorNode->children;
            STAssertTrue(XML_TEXT_NODE == textNode->type, nil);
            STAssertTrue(NULL != textNode->content, nil);
            STAssertTrue(xmlStrcmp(textNode->content, (xmlChar *) "An unexpected error occurred") == 0, nil);            
        }

		xmlFreeNode(xunitNode); xunitNode = NULL;
	}
}

@end