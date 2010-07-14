//
//  RunResultsStatusBarController.h
//  MXServerConnect
//
//  Created by Scott Thompson on 5/8/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunResultsStatusBarController : NSObject
{
	@private
	NSUInteger numberOfPassedTests;
	NSUInteger numberOfFailedTests;

	UILabel *passedLabel;
	UILabel *failedLabel;
}

@property (nonatomic, assign) NSUInteger numberOfPassedTests;
@property (nonatomic, assign) NSUInteger numberOfFailedTests;

@property (nonatomic, retain) IBOutlet UILabel *passedLabel;
@property (nonatomic, retain) IBOutlet UILabel *failedLabel;

@end
