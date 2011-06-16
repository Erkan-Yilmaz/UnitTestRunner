//
//  SampleApp_iOSAppDelegate.m
//  SampleApp_iOS
//
//  Created by Scott Thompson on 6/15/11.
//  Copyright 2011 SoftLayer Technologies, Inc. All rights reserved.
//

#import "SampleApp_iOSAppDelegate.h"

#import "SampleApp_iOSViewController.h"

@implementation SampleApp_iOSAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[SampleApp_iOSViewController alloc] initWithNibName:@"SampleApp_iOSViewController_iPhone" bundle:nil]; 
    } else {
        self.viewController = [[SampleApp_iOSViewController alloc] initWithNibName:@"SampleApp_iOSViewController_iPad" bundle:nil]; 
    }

    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    TestRunResultsDialog *runResultsDialog = [TestRunResultsDialog createRunResultsDialogWithDelegate: self];
    [self.viewController presentModalViewController: runResultsDialog animated: YES];
    [runResultsDialog runAllUnitTests: self];
    
    return YES;
}

- (void) testRunDialogBeganTests: (TestRunResultsDialog *) dialogThatisDone
{
}

- (void) testRunDialogFinishedTests: (TestRunResultsDialog *) dialogThatisDone
{
}

- (void) testRunResultsDialogDone: (TestRunResultsDialog *) dialogThatisDone
{
    [self.viewController dismissModalViewControllerAnimated: YES];
}


@end
