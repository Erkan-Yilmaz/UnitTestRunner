/*
 *  desktop_main.mm
 *  MXServerConnect
 *
 *  Created by Scott Thompson on 5/11/09.
 *  Copyright 2009 Scott Thompson. All rights reserved.
 *
 */

#import <AppKit/AppKit.h>

#import <SenTestingKit/SenTestSuite.h>
#import <SenTestingKit/SenTestObserver.h>

#import <libxml/xmlsave.h>
#import "UnifiedTestListener.h"
#import "UnifiedSuiteRunResults.h"

int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	// Install our own observer
	UnifiedTestListener *testListener = [UnifiedTestListener sharedUnifiedListener];
	[testListener observeSenTestResults];

	SenTestSuite *defaultSuite = [SenTestSuite defaultTestSuite];
	[defaultSuite run];

	[testListener stopObservingSenTestResults];

	xmlDocPtr xmlDoc = [testListener.runResults createXUnitDoc];
	if(NULL != xmlDoc)
	{
		xmlSaveCtxtPtr saveContext = xmlSaveToFd(STDOUT_FILENO,
												xmlGetCharEncodingName(XML_CHAR_ENCODING_UTF8),
												0);

		xmlSaveDoc(saveContext, xmlDoc);
		xmlSaveClose(saveContext); saveContext = NULL;
		xmlFreeDoc(xmlDoc);
	}

	[pool release];
	pool = nil;

	exit(0);
}