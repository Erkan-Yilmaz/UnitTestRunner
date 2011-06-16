//
//  TestCaseFiles.mm
//  UnitTestRunner
//
//  Created by Scott Thompson on 6/30/08.
//  Copyright 2008 Scott Thompson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestCaseFiles.h"

@implementation TestCaseFiles

@synthesize rootPath;

+ (TestCaseFiles *) sharedTestCaseFiles
{
	static TestCaseFiles *gTestCaseFiles = nil;

	if(nil == gTestCaseFiles)
	{
		gTestCaseFiles = [[TestCaseFiles alloc] init];
	}

	return gTestCaseFiles;
}

- (id) init
{
	self = [super init];
	if(self)
	{
		rootPath = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"TestCaseFiles"] retain];
		BOOL isDirectory = false;
		BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath: rootPath isDirectory: &isDirectory];
		if(!fileExists || !isDirectory)
		{
			NSLog(@"The test case files directory could not be found.  Many unit tests may fail because they can't find their resources.");
		}
	}

	return self;
}

- (NSString *) pathToSubdirectory: (NSString *) whichSubdirectory
{
	return [rootPath stringByAppendingPathComponent: whichSubdirectory];
}

- (NSString *) pathToFile: (NSString *) fileName inSubdirectory: (NSString *) whichSubdirectory
{
	NSString *directory = [rootPath stringByAppendingPathComponent: whichSubdirectory];
	NSString *filePath = [directory stringByAppendingPathComponent: fileName];

	BOOL isDirectory = false;
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath: filePath isDirectory: &isDirectory];
	if(!fileExists || isDirectory)
	{
		NSLog(@"The test file requested at path %@ does not exist or is a directory and not a file.  This may yield unexpected test results", filePath);
	}

	return filePath;
}

- (NSData *) dataWithContentsOfFile: (NSString *) fileName inSubdirectory: (NSString *) whichSubdirectory
{
	NSString *filePath = [self pathToFile: fileName inSubdirectory: whichSubdirectory];
	NSData *fileData = [NSData dataWithContentsOfFile: filePath];

	return fileData;
	
}

- (NSString *) stringWithContentsOfFile: (NSString *) fileName inSubdirectory: (NSString *) whichSubdirectory encoding: (NSStringEncoding) encoding
{
	NSString *filePath = [self pathToFile: fileName inSubdirectory: whichSubdirectory];
	NSData *fileData = [NSData dataWithContentsOfFile: filePath];

	return [[[NSString alloc] initWithData: fileData encoding: encoding] autorelease];
}
@end

CFStringRef CopyPathToTestFileSubdirectory(CFStringRef whichSubdirectory)
{
	return (CFStringRef) [[[TestCaseFiles sharedTestCaseFiles] pathToSubdirectory: (NSString *) whichSubdirectory] copy];
}

CFStringRef CopyPathToTestFile(CFStringRef whichFile, CFStringRef whichSubdirectory)
{
	return (CFStringRef) [[[TestCaseFiles sharedTestCaseFiles] pathToFile: (NSString *) whichFile
								inSubdirectory: (NSString *) whichSubdirectory] copy];
}