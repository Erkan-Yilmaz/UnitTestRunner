//
//  TestCaseFiles.h
//  UnitTestRunner
//
//  Created by Scott Thompson on 6/30/08.
//  Copyright 2008 Scott Thompson. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>

#ifdef __OBJC__
@interface TestCaseFiles : NSObject {
	NSString *rootPath;
}

@property (readonly) NSString *rootPath;

+ (TestCaseFiles *) sharedTestCaseFiles;

- (NSString *) pathToSubdirectory: (NSString *) whichSubdirectory;
- (NSString *) pathToFile: (NSString *) fileName inSubdirectory: (NSString *) whichSubdirectory;

- (NSData *) dataWithContentsOfFile: (NSString *) fileName inSubdirectory: (NSString *) whichSubdirectory;
- (NSString *) stringWithContentsOfFile: (NSString *) fileName inSubdirectory: (NSString *) whichSubdirectory encoding: (NSStringEncoding) encoding;
@end
#endif

CFStringRef CopyPathToTestFileSubdirectory(CFStringRef whichSubdirectory);
CFStringRef CopyPathToTestFile(CFStringRef whichFile, CFStringRef whichSubdirectory);