/*
 *  libxmlHelpers.mm
 *  QuickAccess
 *
 *  Created by Scott Thompson on 7/11/08.
 *  Copyright 2008 Scott Thompson. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>
#import "libxmlHelpers.h"

xmlChar *CreateXMLStringFromNSString(NSString *stringToConvert)
{
	NSData *stringData = [stringToConvert dataUsingEncoding: NSUTF8StringEncoding];
	return xmlStrndup((xmlChar *)[stringData bytes], [stringData length]);
}