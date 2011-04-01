//
//  ChooserController.m
//  SongBook
//
//  Created by Kelly Banman on 11-03-13.
//  Copyright 2011 n/a. All rights reserved.
//

#import "ChooserController.h"
#import "SearchController.h"
#import "BookmarksController.h"
#import "SongController.h"
#import "SongViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Song.h"

@implementation ChooserController

@synthesize managedObjectContext=_managedObjectContext, 
				searchController=_searchController, 
					bmController=_bmController, 
					   searchBar=_searchBar, 
					 numberField=_numberField, 
					  doneButton=_doneButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

	// Set up the Song View
    songView = [[SongController alloc] init];
    songView.delegate = self;
    songView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	
	// Set up the Search Controller
	_searchController = [[SearchController alloc] initWithStyle:UITableViewStylePlain];
	_searchController.tableView.frame = CGRectMake(0, 44, 320, 200);
	_searchController.delegate = self;
    
	_searchBar.delegate = _searchController;
	self.searchDisplayController.delegate = _searchController;
	self.searchDisplayController.searchResultsDataSource = _searchController;
	self.searchDisplayController.searchResultsDelegate = _searchController;
	_searchController.searchDisplayer = self.searchDisplayController;
    
    // Init the bookmarks controller
    _bmController = [[BookmarksController alloc] initWithNibName:@"BookmarksController" bundle:nil];
    _bmController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	_bmController.delegate = self;
	
	//[songView setSong:[NSNumber numberWithInt:87]];
	//[self showSong:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
	self.searchDisplayController.active = NO;
	[_doneButton setEnabled:(songView.currentSong.currentSong != nil)];
	[_numberField becomeFirstResponder];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:animated];
}


- (void)songControllerDidFinish:(SongController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
	// Prevent Sleep
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (IBAction)showSong:(id)sender
{
	//NSLog(@"%@",songView.currentSong.currentSong);
	if ( ! [songView isPopulated]) return;
    [self presentModalViewController:songView animated:YES];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
	// Prevent Sleep
	[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}


- (void)modalControllerDidFinishWithSongNumber:(NSNumber *)number {
	[number retain];
	if ([number intValue] > 0){
		[self dismissModalViewControllerAnimated:NO];
		// Show the song selected
		[songView setSong:number];
		[self showSong:nil];
	} else {
		[self dismissModalViewControllerAnimated:YES];
	}
	[number release];
}

- (IBAction)showBookmarksController:(id)sender {
	[self presentModalViewController:_bmController animated:YES];
}

- (IBAction)userTouchedGo:(id)sender {
	NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
	NSNumber *num = [formatter numberFromString:_numberField.text];
	
	if ([songView setSong:num]) {
		[self showSong:nil];
	} else {
		// Shake that thang
		CAKeyframeAnimation *wiggle = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
		wiggle.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.05], [NSNumber numberWithFloat:0.05], nil];
		wiggle.duration = 0.05f;
		wiggle.autoreverses = YES;
		wiggle.repeatCount = 5;
		[_numberField.layer addAnimation:wiggle forKey:nil];
	}
}


#pragma mark - Boring Stuff

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if (isShaking)
		return NO;
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    [_managedObjectContext release];
    [super dealloc];
}

// Shake Detection
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	isShaking = YES;
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (event.type == UIEventSubtypeMotionShake) {
		NSNumber *num;
		do {
			num = [NSNumber numberWithInt:(arc4random() % NUMSONGS)+1];
		} while ( ! [songView setSong:num]);
		[self showSong:nil];
	}
	isShaking = NO;
}
//AppDelegate *mainDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate]

@end
