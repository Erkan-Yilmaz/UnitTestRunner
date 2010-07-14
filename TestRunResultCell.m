//
//  TestRunResultCell.mm
//  MXServerConnect
//
//  Created by Scott Thompson on 5/1/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import "TestRunResultCell.h"


@implementation TestRunResultCell

@synthesize testNameLabel;
@synthesize classNameLabel;
@synthesize statusImageView;

- (void) dealloc
{
	self.testNameLabel = nil;
	self.classNameLabel = nil;
	self.statusImageView = nil;

	[super dealloc];
}
@end
