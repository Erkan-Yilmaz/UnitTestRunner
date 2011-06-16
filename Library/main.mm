//
//  main.m
//  UnitTestRunner
//
//  Created by Scott Thompson on 5/19/08.
//  Copyright Scott Thompson 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, nil);
	[pool release];
	return retVal;
}
