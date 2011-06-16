//
//  RunResultsStatusBar.h
//
//  Created by Scott Thompson on 3/5/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RunResultsStatusBar : UIView
{
	UILabel *passedLabel;
	UILabel *failedLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *passedLabel;
@property (nonatomic, retain) IBOutlet UILabel *failedLabel;

@end
