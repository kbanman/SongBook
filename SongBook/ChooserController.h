//
//  MainViewController.h
//  SongBook
//
//  Created by Kelly Banman on 11-03-13.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class SearchController, BookmarksController, SongViewController;

@interface ChooserController : UIViewController {
    SongViewController *songView;
	BOOL isShaking;
}


- (IBAction)showSong:(id)sender;
- (IBAction)userTouchedGo:(id)sender;
- (IBAction)showBookmarksController:(id)sender;
- (void)modalControllerDidFinishWithSongNumber:(NSNumber *)number;
- (void)songViewControllerDidFinish:(SongViewController *)controller;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) SearchController *searchController;
@property (nonatomic, retain) BookmarksController *bmController;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITextField *numberField;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@end
