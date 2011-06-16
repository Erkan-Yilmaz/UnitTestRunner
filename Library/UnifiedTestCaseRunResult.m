//
//  UnifiedTestCaseRunResult.mm
//  UnitTestRunner
//
//  Created by Scott Thompson on 7/10/08.
//  Copyright 2008 Scott Thompson. All rights reserved.
//

#import "UnifiedTestCaseRunResult.h"
#import "libxmlHelpers.h"
#import "UnitTestRunnerResources.h"

const xmlChar *kXUnit_TestCaseElementName = (xmlChar *) "testcase";
const xmlChar *kXUnit_TestCaseNameAttribute = (xmlChar *) "name";
const xmlChar *kXUnit_TestCaseClassNameAttribute = (xmlChar *) "classname";
const xmlChar *kXUnit_TestCaseRunTimeAttribute = (xmlChar *) "time";

const xmlChar *kXUnit_TestCaseFailureElementName = (xmlChar *) "failure";
const xmlChar *kXUnit_TestCaseErrorElementName = (xmlChar *) "error";


@implementation UnifiedTestCaseRunResult

@synthesize className;
@synthesize testName;
@synthesize runTime;
@synthesize failures;
@synthesize errors;

- (id) initWithTestName: (NSString *) newTestName
{
	self = [super init];
	if(self)
	{
		testName = [newTestName copy];
		failures = [[NSMutableArray array] retain];
		errors = [[NSMutableArray array] retain];
		runTime = 0;
	}

	return self;
}

- (void) dealloc
{
	[className release];
	[testName release];
	[failures release];
	[errors release];

	[super dealloc];
}

- (void) addFailure: (NSString *) failureReason
{
	[(NSMutableArray *)failures addObject: failureReason];
}

- (void) addError: (NSString *) errorString
{
	[(NSMutableArray *)errors addObject: errorString];
}

- (BOOL) succeeded
{
	return [failures count] == 0 && [errors count] == 0;
}

- (xmlNodePtr) createXUnitNode
{
	xmlNodePtr result = NULL;
	result = xmlNewNode(NULL, kXUnit_TestCaseElementName);
	if(NULL != result)
	{
		xmlChar *nameString = CreateXMLStringFromNSString(testName);
		xmlSetProp(result, kXUnit_TestCaseNameAttribute, nameString);
		xmlFree(nameString); nameString = NULL;

		xmlChar *classNameString = CreateXMLStringFromNSString(className);
		xmlSetProp(result, kXUnit_TestCaseClassNameAttribute, classNameString);
		xmlFree(classNameString); classNameString = NULL;

		xmlChar xmlStringBuffer[15];
		sprintf((char *)xmlStringBuffer, "%f", runTime);
		xmlSetProp(result, kXUnit_TestCaseRunTimeAttribute, xmlStringBuffer);

		for(NSString *failure in failures)
		{
			xmlChar *failureString = CreateXMLStringFromNSString(failure);
			xmlNewChild(result, NULL, kXUnit_TestCaseFailureElementName, failureString);
			xmlFree(failureString); failureString = NULL;
		}

		for(NSString *anError in errors)
		{
			xmlChar *errorString = CreateXMLStringFromNSString(anError);
			xmlNewChild(result, NULL, kXUnit_TestCaseErrorElementName, errorString);
			xmlFree(errorString); errorString = NULL;
		}
	}

	return result;
}
@end

#if TARGET_OS_MAC
@implementation SuccessToImage
+ (BOOL)allowsReverseTransformation
{
	return NO;
}

- (id)transformedValue:(id)value
{
	if([value boolValue])
	{
		return [UnitTestRunnerResources imageNamed: @"TestSucceeded.png"];
	} else {
		return [UnitTestRunnerResources imageNamed: @"TestFailed.png"];
	}
}

@end
#endif // TARGET_OS_MAC