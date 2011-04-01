//
//  SongController.m
//  SongBook
//
//  Created by Kelly Banman on 11-03-19.
//  Copyright 2011 n/a. All rights reserved.
//

#import "SongController.h"
#import "SongViewController.h"
#import "AppDelegate.h"
#import "Song.h"
#import "ChooserController.h"

@implementation SongController

@synthesize	delegate=_delegate,
		 currentSong=_currentSong,
			 nxtSong=_nextSong;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		self.view.backgroundColor = [UIColor lightGrayColor];
		// Init both pages
		_currentSong = [[SongViewController alloc] initWithNibName:@"SongView" bundle:nil];
		_currentSong.delegate = self;
		_nextSong = [[SongViewController alloc] initWithNibName:@"SongView" bundle:nil];
		_nextSong.delegate = self;
		
		// Swipe right
		UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
		
		[self.view addGestureRecognizer:recognizer];
		[recognizer release];
		
		// Swipe left
		recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
		recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
		[self.view addGestureRecognizer:recognizer];
		[recognizer release];
		
		[self.view addSubview:_nextSong.view];
		[_nextSong.view removeFromSuperview];
		[self.view addSubview:_currentSong.view];
		displayingPrimary = YES;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[_currentSong release];
	[_nextSong release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	if (duration == 0) return;
	[(displayingPrimary ? _currentSong : _nextSong) layoutVerses];
}

#pragma mark - Custom Stuff



- (BOOL)setSong:(NSNumber *)number {
    Song *song = [self getSong:[number integerValue]];
	if (song != nil) {
		//NSLog(@"setSong");
		[(displayingPrimary ? _currentSong : _nextSong) setSong:song];
		return YES;
	} else {
		return NO;
	}
}

- (Song *)getSong:(NSInteger)num
{
	// Core Data
	NSManagedObjectContext *managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	// Specify Song
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number == %i", num];
	[request setPredicate:predicate];
	
	NSError *error;
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	if (array != nil && [array count] == 1) {
		return [array objectAtIndex:0];
    } else {
		NSLog(@"Song %i not found!", num);
		return nil;
    }
}

- (void)assignSong:(Song *)song toView:(SongViewController *)view
{
	view.currentSong = song;
	[view layoutVerses];
}

- (void)flipPage:(UIViewAnimationTransition)type 
{
	/*
	// Already make the next song the current one
	SongViewController *next = _nextSong;
    _nextSong = _currentSong;
    _currentSong = next;
	
	
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:type forView:[self view] cache:YES];
    [self.view addSubview:_currentSong.view];
    [UIView commitAnimations];
	 */
	[UIView transitionFromView:(displayingPrimary ? _currentSong.view : _nextSong.view)
						toView:(displayingPrimary ? _nextSong.view : _currentSong.view)
					  duration:0.6
					   options:type
					completion:^(BOOL finished) {
						if (finished) {
							displayingPrimary = !displayingPrimary;
							[(UIScrollView *)(displayingPrimary ? _nextSong : _currentSong).view setContentOffset:CGPointMake(0.0, 0.0)];
						}
					}];
}



- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
	//NSLog(@"swipe %i", recognizer.direction);
	// Only support paging in portrait mode
	if (self.interfaceOrientation != UIInterfaceOrientationPortrait) return;
	
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextSong];
    } else {
		[self prevSong];
    }
}

- (void)nextSong {
	Song *newSong = [self getSong:[(displayingPrimary ? _currentSong : _nextSong).currentSong.number integerValue] + 1];
	if (newSong) {
		[(displayingPrimary ? _nextSong : _currentSong) setSong:newSong];
		[self flipPage:UIViewAnimationOptionTransitionCurlUp];
	}
}


- (void)prevSong {
	Song *newSong = [self getSong:[(displayingPrimary ? _currentSong : _nextSong).currentSong.number integerValue] - 1];
	if (newSong) {
		[(displayingPrimary ? _nextSong : _currentSong) setSong:newSong];
		[self flipPage:UIViewAnimationOptionTransitionCurlDown];
	}
}

- (void)showChooser:(id)sender
{
	[_delegate songControllerDidFinish:self];
}

- (BOOL)isPopulated
{
	return (_currentSong.currentSong != nil);
}

@end
