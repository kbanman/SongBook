//
//  FlipsideViewController.h
//  SongBook
//
//  Created by Kelly Banman on 11-03-13.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Song, ChooserController;

@interface SongViewController : UIViewController {
	
}

@property (nonatomic, retain) Song *currentSong;
@property (nonatomic, assign) ChooserController *delegate;
@property (nonatomic, retain) IBOutlet UILabel *songNumber;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *bookmarkButton;
@property (nonatomic, retain) IBOutlet UIToolbar *titleBar;
@property (nonatomic, assign) BOOL isPopulated;

- (IBAction)bookmarkButtonTapped:(id)sender;
- (IBAction)showSongChooser:(id)sender;

- (void)layoutVerses;
- (void)layoutVerses:(BOOL)landscape;
- (void)setSong:(NSNumber *)number;
- (void)nextSong;
- (void)prevSong;
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;

@end
