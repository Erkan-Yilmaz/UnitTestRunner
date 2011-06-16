//
//  UnitTestRunnerResources.h
//  iPhone_UnitTestRunner
//
//  Created by Scott Thompson on 7/1/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface UnitTestRunnerResources : NSObject {

}

+ (NSBundle *) resourceBundle;

#if TARGET_OS_IPHONE
+ (UIImage *) imageNamed: (NSString *) imageName;
#else
+ (NSImage *) imageNamed: (NSString *) imageName;
#endif
@end
