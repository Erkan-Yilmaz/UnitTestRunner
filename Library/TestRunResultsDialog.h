//
//  TestRunResultsDialog.h
//  UnitTestRunner
//
//  Created by Scott Thompson on 7/2/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestSuiteResultViewController;
@class TestRunResultsDialog;

@protocol TestRunResultsDialogDelegate
@optional
- (void) testRunDialogBeganTests: (TestRunResultsDialog *) dialogThatisDone;
- (void) testRunDialogFinishedTests: (TestRunResultsDialog *) dialogThatisDone;
- (void) testRunResultsDialogDone: (TestRunResultsDialog *) dialogThatisDone;
@end

@interface TestRunResultsDialog : UINavigationController

@property (nonatomic, assign) id <NSObject, TestRunResultsDialogDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIBarButtonItem	*doneButton;

+ (TestRunResultsDialog *) createRunResultsDialogWithDelegate: (id <NSObject, TestRunResultsDialogDelegate>) delegate;

- (IBAction) closeDialog: (id) sender;
- (IBAction) runAllUnitTests: (id) sender;
@end
