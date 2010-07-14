/*!
    @file	UnifiedTestCaseRunResult
	@brief	Declares the UnifiedTestCaseRunResult class.
*/

#ifdef IPHONEOS_PLATFORM
#import <UIKit/UIKit.h>
#endif

#import <libxml/tree.h>

extern const xmlChar *kXUnit_TestCaseElementName;
extern const xmlChar *kXUnit_TestCaseNameAttribute;
extern const xmlChar *kXUnit_TestCaseClassNameAttribute;
extern const xmlChar *kXUnit_TestCaseRunTimeAttribute;

extern const xmlChar *kXUnit_TestCaseFailureElementName;
extern const xmlChar *kXUnit_TestCaseErrorElementName;

/*!
	UnifiedTestCaseRunResult collects the results of running an individual
	test case and can generate an XML node for reporting those results
*/
@interface UnifiedTestCaseRunResult : NSObject {
	NSString *testName;
	NSString *className;
	float	 runTime;

	NSArray *failures;
	NSArray *errors;
}

@property (nonatomic, readonly) NSString *testName;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, assign) float	 runTime;

@property (nonatomic, readonly) BOOL succeeded;
@property (nonatomic, readonly) NSArray	 *failures;
@property (nonatomic, readonly) NSArray	 *errors;


- (id) initWithTestName: (NSString *) newTestName;

/*! Add a notification that this test case failed with the given reason */
- (void) addFailure: (NSString *) failureReason;

/*! Add a notification if running the test case represented by this result
	experienced an unexpected error */
- (void) addError: (NSString *) errorString;

/*! Generates an XML node that represents this test case result. */
- (xmlNodePtr) createXUnitNode;
@end
