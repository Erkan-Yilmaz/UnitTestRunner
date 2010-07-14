//
//  TestRunResultCell.h
//  MXServerConnect
//
//  Created by Scott Thompson on 5/1/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestRunResultCell : UITableViewCell
{
	UILabel *testNameLabel;
	UILabel *classNameLabel;
	UIImageView *statusImageView;
}

@property (nonatomic, retain) IBOutlet UILabel *testNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *classNameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *statusImageView;

@end
