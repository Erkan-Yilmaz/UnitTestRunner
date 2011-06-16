//
//  SampleApp_iOSAppDelegate.h
//  SampleApp_iOS
//
//  Created by Scott Thompson on 6/15/11.
//  Copyright 2011 SoftLayer Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UnitTestRunner/UnitTestRunner.h>

@class SampleApp_iOSViewController;

@interface SampleApp_iOSAppDelegate : UIResponder <UIApplicationDelegate, TestRunResultsDialogDelegate>

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) SampleApp_iOSViewController *viewController;

@end
