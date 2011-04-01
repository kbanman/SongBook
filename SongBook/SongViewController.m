//
//  SongViewController.m
//  SongBook
//
//  Created by Kelly Banman on 11-03-13.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SongViewController.h"
#import "AppDelegate.h"
#import "SongController.h"
#import "Song.h"
#import "Verse.h"

@implementation SongViewController

@synthesize	  delegate=_delegate, 
		bookmarkButton=_bookmarkButton, 
			songNumber=_songNumber, 
//		   isPopulated=_isPopulated, 
		   currentSong=_song,
			  titleBar=_titleBar;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
	[self layoutVerses];
}


#pragma mark - Song Methods
- (void)layoutVerses {
	[self layoutVerses:(self.delegate.interfaceOrientation != UIInterfaceOrientationPortrait)];
}
- (void)layoutVerses:(BOOL)landscape {
	//NSLog(@"layoutVerses %i",landscape);
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] bookmarkExistsForNumber:_song.number]) {
        [_bookmarkButton setImage:[UIImage imageNamed:@"bookmarkedIcon.png"]];
    } else {
        [_bookmarkButton setImage:[UIImage imageNamed:@"bookmarkIcon.png"]];
    }
	
	self.songNumber.text = [_song.number stringValue];
	
    // Get rid of all the current stuff
    for (UIView *subview in self.view.subviews) {
        if ([subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UITextView class]]) {
            [subview removeFromSuperview];
        }
    }
    
    // Layout vars
    CGFloat padding_top = 25.0,
			padding_bottom = 175.0,
			chorus_top = 5.0,
			chorus_bottom = 23.0,
			verse_top = -2.0,
			verse_left = 0.0,
			verse_width = 320.0 - verse_left,
			total_height = 44.0 + padding_top, // The height of the title bar
			num_top = 7.0,
			num_left = 8.0,
			num_width = 100.0;
	
	UIFont  *verseFont, 
			*numFont;
	
	if (landscape) 
	{
		verse_width = 480.0 - verse_left;
		numFont = [UIFont fontWithName:@"Baskerville-Bold" size:25.0];
		verseFont = [UIFont fontWithName:@"Baskerville" size:24.0];
		padding_bottom = padding_bottom/2;
	} else {
		numFont = [UIFont fontWithName:@"Baskerville-Bold" size:20.0];
		verseFont = [UIFont fontWithName:@"Baskerville" size:19.0];
	}
	
    CGFloat num_height = [@"00" sizeWithFont:numFont].height,
			verse_inner_padding = verseFont.pointSize/2.0;
    
    for (Verse *verse in [_song getVerses]) {
        //NSLog(@"%@", verse.text);
        if ([verse isChorus] != true) {
            // Add a verse number
            CGRect numFrame = CGRectMake(num_left, total_height+num_top, num_width, num_height);
            total_height += num_height;
            UILabel *numLabel = [[UILabel alloc] initWithFrame:numFrame];
            numLabel.text = [NSString stringWithFormat:@"%@.",verse.number];
            numLabel.font = numFont;
            numLabel.backgroundColor = [UIColor clearColor];
            numLabel.textColor = RGB(100.0,100.0,100.0);
            [self.view addSubview:numLabel];
            [numLabel release];
        } else if ([verse.index intValue] != 0) {
			// non-first chorus
            total_height += chorus_top;
        } else {
			// first chorus
			total_height += num_height;
		}
        CGSize testSize = [verse.text sizeWithFont:verseFont 
								 constrainedToSize:CGSizeMake(verse_width - verse_inner_padding, CGFLOAT_MAX) 
									 lineBreakMode:UILineBreakModeWordWrap];
        CGRect verseFrame = CGRectMake(verse_left, total_height+verse_top, verse_width+4.0, testSize.height + 10.0);
        total_height += verse_top + verseFrame.size.height;
		
        UITextView *verseLabel = [[UITextView alloc] initWithFrame:verseFrame];
        verseLabel.font = verseFont;
        verseLabel.text = verse.text;
        verseLabel.scrollEnabled = false;
        verseLabel.editable = false;
        verseLabel.backgroundColor = [UIColor clearColor];
        if (verse.is_chorus) {
            total_height += chorus_bottom;
            //verseLabel.backgroundColor = [UIColor greenColor];
        }
        [self.view addSubview:verseLabel];
        [verseLabel release];
    }
    [(UIScrollView *)self.view setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, total_height+padding_bottom)];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// tint the title bar
	_titleBar.tintColor = NAVBARCOLOUR;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration 
{	
	NSLog(@"SVC willAnimateRotationToInterfaceOrientation");
	if (duration > 0) {
		//NSLog(@"%f = %f",duration,duration/2);
		[self layoutVerses:(toInterfaceOrientation != UIInterfaceOrientationPortrait)];
	}
}
*/

#pragma mark - Actions

- (void)setSong:(Song *)song
{
	_song = [song retain];
	[self layoutVerses];
}

- (IBAction)showChooser:(id)sender
{
    [_delegate showChooser:sender];
}
- (IBAction)bookmarkButtonTapped:(id)sender {
	if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] bookmarkExistsForNumber:_song.number]){
		[(AppDelegate *)[[UIApplication sharedApplication] delegate] deleteBookmarkForNumber:_song.number];
		[_bookmarkButton setImage:[UIImage imageNamed:@"bookmarkIcon.png"]];
	} else {
		[(AppDelegate *)[[UIApplication sharedApplication] delegate] addBookmarkForNumber:_song.number withTitle:[_song getFirstLine]];
		[_bookmarkButton setImage:[UIImage imageNamed:@"bookmarkedIcon.png"]];
	}
}


@end
