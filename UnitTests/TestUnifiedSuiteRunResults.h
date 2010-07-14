//
//  TestUnifiedSuiteRunResults.h
//  QuickAccess
//
//  Created by Scott Thompson on 7/10/08.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SenTestingKit/SenTestCase.h>

@class UnifiedSuiteRunResults;
@class MockSenTestSuiteRun;

@interface TestUnifiedSuiteRunResults : SenTestCase {
	UnifiedSuiteRunResults *testSuiteRun;
	MockSenTestSuiteRun *mockSenTestRun;
}

@end
