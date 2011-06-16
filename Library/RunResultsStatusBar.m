//
//  RunResultsStatusBar.mm
//
//  Created by Scott Thompson on 3/5/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import "RunResultsStatusBar.h"


@implementation RunResultsStatusBar

@synthesize passedLabel;
@synthesize failedLabel;

- (void)dealloc 
{
	self.passedLabel = nil;
	self.failedLabel = nil;

    [super dealloc];
}

- (BOOL) autoresizesSubviews
{
	return NO;
}

- (void) layoutSubviews
{
	passedLabel.center = CGPointMake(
							self.bounds.origin.x + 0.25 * self.bounds.size.width,
							CGRectGetMidY(self.bounds));

	failedLabel.center = CGPointMake(
							self.bounds.origin.x + 0.75 * self.bounds.size.width,
							CGRectGetMidY(self.bounds));

}

- (void)drawRect: (CGRect) rect
{
	CGContextRef cgContext = UIGraphicsGetCurrentContext();

	CGFloat colorLocations[] = { 0, 1.0 };
	CGFloat greenGradientColors [] = {
		0.0, 0.5, 0.0, 1.0,
		0.0, 0.4, 0.0, 1.0
	};

	CGFloat redGradientColors [] = {
		0.5, 0.0, 0.0, 1.0,
		0.4, 0.0, 0.0, 1.0
	};

	CGFloat separatorColor[] = { 0.3, 0.3, 0.3, 1.0};
	CGFloat shadowColor[] = { 0.2, 0.2, 0.2, 1.0 };

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	CGContextSaveGState(cgContext);
	CGContextAddRect(cgContext, CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width / 2.0, self.bounds.size.height));
	CGContextClip(cgContext);

	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, greenGradientColors, colorLocations, 2);
	CGContextDrawRadialGradient(cgContext, gradient,
		CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)),
		0,
		CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)),
		self.bounds.size.width / 2.0, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CFRelease(gradient);
	gradient = NULL;
	CGContextRestoreGState(cgContext);

	CGContextSaveGState(cgContext);
	CGContextAddRect(cgContext, CGRectMake(
		self.bounds.origin.x + self.bounds.size.width / 2.0,
		self.bounds.origin.y,
		self.bounds.size.width / 2.0,
		self.bounds.size.height));

	CGContextClip(cgContext);

	gradient = CGGradientCreateWithColorComponents(colorSpace, redGradientColors, colorLocations, 2);
	CGContextDrawRadialGradient(cgContext, gradient,
								CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds)),
								0,
								CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds)),
								self.bounds.size.width / 2.0, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	CFRelease(gradient);
	gradient = NULL;
	CGContextRestoreGState(cgContext);


	CGColorRef shadowColorObject = CGColorCreate(colorSpace, shadowColor);
	CGContextSetShadowWithColor(cgContext, CGSizeMake(1,1), 3, shadowColorObject);
	CFRelease(shadowColorObject);
	CGContextMoveToPoint(cgContext, 0.5, 0.5);
	CGContextAddLineToPoint(cgContext, CGRectGetMaxX(self.bounds) - 0.5, CGRectGetMinY(self.bounds) + 0.5);

	CGContextMoveToPoint(cgContext, CGRectGetMidX(self.bounds), CGRectGetMinY(self.bounds) + 0.5);
	CGContextAddLineToPoint(cgContext, CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5);

	CGContextSetStrokeColorSpace(cgContext, colorSpace);
	CGContextSetStrokeColor(cgContext, separatorColor);
	CGContextSetLineWidth(cgContext, 1.0);
	CGContextSetLineCap(cgContext, kCGLineCapSquare);

	CGContextStrokePath(cgContext);
	CFRelease(colorSpace);
}

@end
