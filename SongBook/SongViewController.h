//
//  SongViewController.h
//  SongBook
//
//  Created by Kelly Banman on 11-03-13.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Song, SongController;

@interface SongViewController : UIViewController {

}

@property (nonatomic, retain) Song *currentSong;
@property (nonatomic, retain) SongController *delegate;
@property (nonatomic, retain) IBOutlet UILabel *songNumber;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *bookmarkButton;
@property (nonatomic, retain) IBOutlet UIToolbar *titleBar;

- (IBAction)bookmarkButtonTapped:(id)sender;
- (IBAction)showChooser:(id)sender;

- (void)layoutVerses;
- (void)layoutVerses:(BOOL)landscape;
- (void)setSong:(Song *)song;
//- (void)nextSong;
//- (void)prevSong;
//- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;

@end
