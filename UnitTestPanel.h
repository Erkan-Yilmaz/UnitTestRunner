//
//  UnitTestPanel.h
//  TopicSpace
//
//  Created by Scott Thompson on 7/10/09.
//  Copyright 2009 Turing Complete, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UnitTestPanel : NSWindowController
{
	NSCollectionView *collectionView;

	NSButton *successButton;
	NSButton *failureButton;

	NSArray *runResults;
}

@property (retain) IBOutlet NSCollectionView *collectionView;
@property (retain) IBOutlet NSButton *successButton;
@property (retain) IBOutlet NSButton *failureButton;

@property (nonatomic, retain) NSArray *runResults;

+ (UnitTestPanel *) sharedUnitTestPanel;

- (IBAction) runTests: (id) sender;
@end
