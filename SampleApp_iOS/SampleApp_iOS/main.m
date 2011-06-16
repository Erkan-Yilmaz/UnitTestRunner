//
//  main.m
//  SampleApp_iOS
//
//  Created by Scott Thompson on 6/15/11.
//  Copyright 2011 SoftLayer Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SampleApp_iOSAppDelegate.h"

int main(int argc, char *argv[])
{
    int retVal = 0;

    NSAutoreleasePool *autoreleasePool = [[NSAutoreleasePool alloc] init];
    retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([SampleApp_iOSAppDelegate class]));
    [autoreleasePool release];

    return retVal;
}
