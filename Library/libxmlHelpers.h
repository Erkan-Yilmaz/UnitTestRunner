/*
 *  libxmlHelpers.h
 *  UnitTestRunner
 *
 *  Created by Scott Thompson on 7/11/08.
 *  Copyright 2008 Scott Thompson. All rights reserved.
 *
 */

#import <libxml/xmlstring.h>

/// Returns a newly allocated xml string with the contents of the given
/// string.  The results must be xmlFree'ed by the caller!
extern xmlChar *CreateXMLStringFromNSString(NSString *stringToConvert);