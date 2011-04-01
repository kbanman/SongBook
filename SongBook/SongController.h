//
//  SongController.h
//  SongBook
//
//  Created by Kelly Banman on 11-03-19.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongViewController, ChooserController, Song;

@interface SongController : UIViewController {
	BOOL displayingPrimary;
}

@property (nonatomic, retain) ChooserController *delegate;
@property (nonatomic, retain) SongViewController *currentSong;
@property (nonatomic, retain) SongViewController *nxtSong;

- (BOOL)setSong:(NSNumber *)number;
- (Song *)getSong:(NSInteger)num;
- (void)assignSong:(Song *)song toView:(SongViewController *)view;
- (void)nextSong;
- (void)prevSong;
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;
- (void)showChooser:(id)sender;
- (BOOL)isPopulated;

@end
