/*!
    @file	UnifiedSuiteRunResults
    @brief	Contains the declaration of the UnifiedSuiteRunResults class.

*/

#ifdef IPHONEOS_PLATFORM
#import <UIKit/UIKit.h>
#endif

#import <SenTestingKit/SenTestSuiteRun.h>
#import <libxml/tree.h>


@class UnifiedTestCaseRunResult;

extern const xmlChar *kXUnit_TestSuiteElementName;
extern const xmlChar *kXUnit_TestSuiteNameAttribute;
extern const xmlChar *kXUnit_TestSuiteNumTestsAttribute;
extern const xmlChar *kXUnit_TestSuiteNumFailuresAttribute;
extern const xmlChar *kXUnit_TestSuiteNumErrorsAttribute;
extern const xmlChar *kXUnit_TestSuiteRunTimeAttribute;

/*!
    @class    UnifiedSuiteRunResults
    @brief    Collects the results of running many tests

	This class collects the results of running C++ and Objective-C
	unit tests into a unified format.  It also has the ability
	to generate an XML document (for libxml2) that reports those
	results in XUnit format.
*/
@interface UnifiedSuiteRunResults : NSObject
{
	NSString *suiteName;
	NSMutableArray *testCaseResults;
}

@property (nonatomic, readonly, copy) NSString *suiteName;
@property (nonatomic, readonly) NSTimeInterval runTime;
@property (nonatomic, readonly) int numTests;
@property (nonatomic, readonly) int numFailures;
@property (nonatomic, readonly) int numErrors;

@property (nonatomic, readonly) NSArray *testCaseResults;

/*! Create a new suite results object with the given name */
- (id) initWithSuiteName: (NSString *) suiteName;

/*! adds a test case result to the run results of this suite */
- (void) addTestCaseResult: (UnifiedTestCaseRunResult *) testCaseResult;

/*! Generate a fully formed libxml2 document that contains the results
	of this run */
- (xmlDocPtr) createXUnitDoc;

/*!
	Generate a an individual libxml2 element node object that describes the
	results of this run. The element is formatted as XUnit XML.
*/
- (xmlNodePtr) createXUnitNode;

@end
