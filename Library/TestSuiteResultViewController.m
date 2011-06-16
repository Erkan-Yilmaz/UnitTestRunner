//
//  TestSuiteResultViewController.mm
//  MXServerConnect
//
//  Created by Scott Thompson on 4/30/09.
//  Copyright 2009 Scott Thompson. All rights reserved.
//

#import "TestSuiteResultViewController.h"

#import "RunResultsStatusBarController.h"
#import "TestRunResultCell.h"
#import "UnifiedSuiteRunResults.h"
#import "UnifiedTestCaseRunResult.h"
#import "UnitTestRunnerResources.h"

@interface TestSuiteResultViewController ()
- (BOOL) searchTermIsKindSpecification: (NSString *) searchTerm;
@end

@implementation TestSuiteResultViewController

@synthesize searchBar;
@synthesize tableView;
@synthesize filteredResults;
@synthesize runResults;
@synthesize statusBar;

- (void) dealloc
{
	self.tableView = nil;
	self.runResults = nil;
	self.searchBar = nil;
	self.statusBar = nil;

	[super dealloc];
}

- (void) viewDidLoad
{
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	[self updateStatusBar];
}

- (void) setRunResults: (UnifiedSuiteRunResults *) _runResults
{
	if(_runResults != runResults)
	{
		[runResults release];
		runResults = [_runResults retain];

		self.filteredResults = [runResults testCaseResults];

		// when we get new run results, we reset the search bar.
		searchBar.text = @"";
		[searchBar endEditing: YES];
	}
}

- (void) setFilteredResults: (NSArray *) newResults
{
	if(newResults != filteredResults)
	{
		[filteredResults release];
		filteredResults = [newResults retain];
		[self.tableView reloadData];

		[self updateStatusBar];
	}
}

- (void) updateStatusBar
{
	if(NULL != statusBar)
	{
		NSUInteger numPassed = 0;
		NSUInteger numFailed = 0;

		for(UnifiedTestCaseRunResult *eachResult in filteredResults)
		{
			eachResult.succeeded ? ++numPassed : ++numFailed;
		}

		statusBar.numberOfPassedTests = numPassed;
		statusBar.numberOfFailedTests = numFailed;
	}
}

- (void) filterResultsWithString: (NSString *) searchText
{
	// Only bother with filtering if there are filter conditions.
	if(nil == searchText || [searchText length] == 0)
	{
		self.filteredResults = [runResults testCaseResults];
	} else {
		enum searchLimiations
		{
			kSearchAllTests = 0,
			kSearchPassedTests,
			kSearchFailedTests
		} searchLimitation;

		searchLimitation = kSearchAllTests;

		NSArray *allSearchTerms = [searchText componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSMutableArray *searchTermsWithoutKeywords = [NSMutableArray array];

		// Run through the search terms looking for keyword specifications
		for(NSString *eachSearchTerm in allSearchTerms)
		{
			if([self searchTermIsKindSpecification: eachSearchTerm])
			{
				// The kindSpecification should start with "kind:" at this point.. everything past that is the kind parameter
				const NSInteger kLengthOfKindKeyword = 5; // length of the string "kind:"

				NSString *kindParameter = [eachSearchTerm substringFromIndex: kLengthOfKindKeyword];
				if([[kindParameter lowercaseString] hasPrefix: @"pass"])
				{
					searchLimitation = kSearchPassedTests;
				} else if([[kindParameter lowercaseString] hasPrefix: @"fail"]) {
					searchLimitation = kSearchFailedTests;
				}
			} else {
				if([eachSearchTerm length] > 0)
				{
					[searchTermsWithoutKeywords addObject: eachSearchTerm];
				}
			}
		}

		NSMutableArray *newResults = [NSMutableArray array];
		for(UnifiedTestCaseRunResult* eachResult in [runResults testCaseResults])
		{
			// if the run result matches our search limitations for successful or failed tests then
			// apply the search terms to the result
			if( searchLimitation == kSearchAllTests ||
			   ((searchLimitation == kSearchPassedTests) && (eachResult.succeeded)) ||
			   ((searchLimitation == kSearchFailedTests) && (!eachResult.succeeded)) )
			{
				// If no search terms were specified, then simply pass the result on
				if([searchTermsWithoutKeywords count] == 0)
				{
					[newResults addObject: eachResult];
				} else {
					// othewise, pass on the result only if it matches the search
					// terms
					for(NSString *eachSearchTerm in searchTermsWithoutKeywords)
					{
						NSRange nameSearchResult = [eachResult.testName rangeOfString: eachSearchTerm options: NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch ];
						NSRange classSearchResult = [eachResult.className rangeOfString: eachSearchTerm options: NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch ];
						if(nameSearchResult.length > 0 || classSearchResult.length > 0)
						{
							[newResults addObject: eachResult];

							// break out of the for loop since we found a matching search term.
							break;
						}
					}
				}
			}
		}

		self.filteredResults = [NSArray arrayWithArray: newResults];
	}
}
#pragma mark -
#pragma mark Private Methods

- (BOOL) searchTermIsKindSpecification: (NSString *) searchTerm
{
	NSRange kindKeywordRange = [searchTerm rangeOfString: @"kind:" options: NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch | NSWidthInsensitiveSearch ];
	return (kindKeywordRange.location == 0) && (kindKeywordRange.length == 5);
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBar: (UISearchBar *) _searchBar textDidChange: (NSString *) searchText
{
	[self filterResultsWithString: searchText];
}

- (void) searchBarSearchButtonClicked: (UISearchBar *) _searchBar;
{
	[_searchBar resignFirstResponder];
}

- (void) searchBarBookmarkButtonClicked: (UISearchBar *) _searchBar
{
	UIActionSheet *bookmarkChoices =
		[[UIActionSheet alloc]
			    initWithTitle: @"Quick Filters"
			         delegate: self
			cancelButtonTitle: NSLocalizedString(@"Cancel", @"Title on the cancel button for the bookmarks sheet")
	   destructiveButtonTitle: nil
	        otherButtonTitles: @"Passed Tests Only",
							   @"Failed Tests Only",
							   nil];

	[bookmarkChoices showInView: [self view]];
	[bookmarkChoices release];
}

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (NSInteger) buttonIndex
{
#define kPassedTestsOnlyButtonIndex 0
#define kFailedTestsOnlyButtonIndex 1
#define kCancelButtonIndex 2

	if(buttonIndex != kCancelButtonIndex)
	{
		NSArray *allSearchTerms = [searchBar.text componentsSeparatedByCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		NSMutableArray *newSearchTerms = [NSMutableArray array];

		// Collect all the non-keyword search terms
		for(NSString *eachSearchTerm in allSearchTerms)
		{
			if(![self searchTermIsKindSpecification: eachSearchTerm])
			{
				[newSearchTerms addObject: eachSearchTerm];
			}
		}

		// add a kind keyword
		switch(buttonIndex)
		{
			case kPassedTestsOnlyButtonIndex :
				[newSearchTerms addObject: @"kind:passed"];
			break;

			case kFailedTestsOnlyButtonIndex :
				[newSearchTerms addObject: @"kind:failed"];
			break;
		}

		NSString *newSearchText = [newSearchTerms componentsJoinedByString: @" "];
		searchBar.text = newSearchText;
		[self filterResultsWithString: newSearchText];
	}
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) tableView: (UITableView *) table
  numberOfRowsInSection: (NSInteger) section
{
	return [filteredResults count];
}

- (UITableViewCell *)tableView: (UITableView *) _tableView
		 cellForRowAtIndexPath: (NSIndexPath *) indexPath
{
	static NSString * kTestRunResultCellID = @"TestRunResultCell";

	TestRunResultCell *cellToReturn = (TestRunResultCell *) [_tableView dequeueReusableCellWithIdentifier: kTestRunResultCellID];
	if(NULL == cellToReturn)
	{
		NSMutableDictionary *cellOwner = [[NSMutableDictionary alloc] initWithCapacity: 1];
		[[UnitTestRunnerResources resourceBundle] loadNibNamed: kTestRunResultCellID owner: cellOwner options: nil];

		if(nil != [cellOwner objectForKey: kTestRunResultCellID])
		{
			cellToReturn = [[[cellOwner objectForKey: kTestRunResultCellID] retain] autorelease];
		} else {
			// Could not load the nib file.. punt
			cellToReturn = nil;
		}

		[cellOwner release];
	}

	if(nil != cellToReturn)
	{
		NSInteger testIndex = [indexPath row];
		UnifiedTestCaseRunResult *individualTestResult = [filteredResults objectAtIndex: testIndex];

		cellToReturn.testNameLabel.text = individualTestResult.testName;
		cellToReturn.classNameLabel.text = individualTestResult.className;
		cellToReturn.statusImageView.image = individualTestResult.succeeded ? [UnitTestRunnerResources imageNamed: @"TestSucceeded.png"] : [UnitTestRunnerResources imageNamed: @"TestFailed.png"];
	}

	return cellToReturn;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)		  tableView: (UITableView *) _tableView
	didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
	[_tableView deselectRowAtIndexPath: indexPath animated: YES];
	[searchBar endEditing: NO];
}

@end

