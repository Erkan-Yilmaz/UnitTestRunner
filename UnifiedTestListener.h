//
//  UnifiedTestListener.h
//
// The Unified test listener collects the results of running both Objective-C
// and CXX unit tests and spools those results out at JUnit compatible XML.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#endif

#import <libxml/tree.h>

@class UnifiedSuiteRunResults;
@class UnifiedTestCaseRunResult;

/*!
	The UnifiedTestListener is an aggregator. It collects the results of running
	both Objective-C tests (through SenTestingKit) and allows you to generate an
	XUnit description of the results.
*/
@interface UnifiedTestListener : NSObject {
	UnifiedSuiteRunResults *runResults;
	UnifiedTestCaseRunResult *currentTestCaseResult;
}

/*! The collected results of all tests seen to-date. */
@property (nonatomic, readonly, retain) UnifiedSuiteRunResults *runResults;

/*! returns the shared instance of the unified test listener */
+ (UnifiedTestListener *) sharedUnifiedListener;

/*! Add observers so that the test listener is notified when a test or suite
	begins or ends */
- (void) observeSenTestResults;

/*! Stop listening to the notification center and ignore test and suite events */
- (void) stopObservingSenTestResults;

/*! Notification that the SenTestingKit has started a test. */
- (void) senTestCaseDidStart: (NSNotification *) notification;

/*! Notification that the SenTestingKit has finished a test. */
- (void) senTestCaseDidStop: (NSNotification *) notification;

/*! Notification that the last test started by the SenTestingKit failed. */
- (void) senTestCaseDidFail: (NSNotification *) notification;

@end
