//
//  UnitTestRunnerResources.m
//  iPhone_UnitTestRunner
//
//  Created by Scott Thompson on 7/1/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitTestRunnerResources.h"


@implementation UnitTestRunnerResources

+ (NSBundle *) resourceBundle
{
	static NSBundle *sharedTestRunnerResourceBundle = nil;
	
	if(nil == sharedTestRunnerResourceBundle)
	{
#if TARGET_OS_IPHONE
		// Look in the main bundle for a bundle named "UnitTestRunnerResources.bundle"
		NSString *myBundlePath = [[NSBundle mainBundle] pathForResource: @"UnitTestRunnerResources" ofType: @"bundle"];
		if(myBundlePath)
		{
			sharedTestRunnerResourceBundle = [NSBundle bundleWithPath: myBundlePath];
		}
#else
	sharedTestRunnerResourceBundle = [NSBundle bundleForClass: self];
#endif
	}
	
	return sharedTestRunnerResourceBundle;
}

#if TARGET_OS_IPHONE
+ (UIImage *) imageNamed: (NSString *) imageName
{
	UIImage *retVal = nil;
	NSBundle *resourceBundle = [self resourceBundle];
	
	if(nil != resourceBundle)
	{
		NSString *imagePath = [resourceBundle pathForResource: [imageName stringByDeletingPathExtension] ofType: [imageName pathExtension]];
		if(nil != imagePath)
		{
			retVal = [UIImage imageWithContentsOfFile: imagePath];
		}
	}
	
	return retVal;
}
#else
+ (NSImage *) imageNamed: (NSString *) imageName
{
	NSImage *retVal = nil;
	NSBundle *resourceBundle = [self resourceBundle];
	
	if(nil != resourceBundle)
	{
		NSString *imagePath = [resourceBundle pathForResource: [imageName stringByDeletingPathExtension] ofType: [imageName pathExtension]];
		if(nil != imagePath)
		{
			retVal = [[[NSImage alloc] initWithContentsOfFile: imagePath] autorelease];
		}
	}
	
	return retVal;
}
#endif
@end
