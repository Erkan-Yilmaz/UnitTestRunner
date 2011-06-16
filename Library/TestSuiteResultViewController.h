//
//  TestSuiteResultViewController.h
//  MXServerConnect
//
//  Created by Scott Thompson on 4/30/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UnifiedSuiteRunResults;
@class RunResultsStatusBarController;

@interface TestSuiteResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIActionSheetDelegate>
{
	UISearchBar *searchBar;
	UITableView *tableView;
	RunResultsStatusBarController *statusBar;

	UnifiedSuiteRunResults *runResults;

	NSArray *filteredResults;
}

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet RunResultsStatusBarController *statusBar;

@property (nonatomic, retain) UnifiedSuiteRunResults *runResults;
@property (nonatomic, retain) NSArray *filteredResults;

- (void) filterResultsWithString: (NSString *) searchText;
- (void) updateStatusBar;
@end
