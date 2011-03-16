

#import "BookmarksController.h"
#import "AppDelegate.h"
#import "ChooserController.h"


@implementation BookmarksController

@synthesize delegate=_delegate, table=_table, bookmarks=_bookmarks;


- (void)viewDidLoad {
    [super viewDidLoad];

    // We need an edit button
	//self.navigationItem.leftBarButtonItem = self.doneButton;
	
}

- (void)viewWillAppear:(BOOL)animated
{
	[self reloadData];
}
- (void)viewDidDisappear:(BOOL)animated
{
	[_bookmarks release];
	_bookmarks = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait ||
			interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
			interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	_table = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bookmarks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"cellForRowAtIndexPath");
    static NSString *CellIdentifier = @"Cell";
	
    UILabel *songNumber;
	UILabel *songTitle;
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];// Set up the cell...
		CGFloat	cellWidth = [[UIScreen mainScreen] bounds].size.width,
		cellHeight = cell.contentView.frame.size.height,
		title_marginLeft = 62.0;
		
		CGRect numberFrame = CGRectMake(0, 0, title_marginLeft, cellHeight);
		songNumber = [[UILabel alloc] initWithFrame:numberFrame]; 
		songNumber.font = [UIFont boldSystemFontOfSize:20.0];
		songNumber.backgroundColor = [UIColor clearColor];
		songNumber.textAlignment = UITextAlignmentCenter;
		songNumber.tag = 42;
		[cell.contentView addSubview:songNumber];
		[songNumber release];
		
		CGRect titleFrame = CGRectMake(title_marginLeft, 0, cellWidth-title_marginLeft, cellHeight);
		songTitle = [[UILabel alloc] initWithFrame:titleFrame];
		songTitle.font = [UIFont systemFontOfSize:17.0];
		songTitle.textColor = [UIColor grayColor];
		songTitle.backgroundColor = [UIColor clearColor];
		songTitle.textAlignment = UITextAlignmentLeft;
		songTitle.tag = 43;
		songTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[cell.contentView addSubview:songTitle];
		[songTitle release];
    } else {
		songNumber = (UILabel *)[cell.contentView viewWithTag:42];
		songTitle = (UILabel *)[cell.contentView viewWithTag:43];
	}
    
	// Grab the song this bookmark points to
	NSDictionary *bookmark = (NSDictionary *)[_bookmarks objectAtIndex:indexPath.row];

	songNumber.text = [[bookmark objectForKey:@"number"] stringValue];
	songTitle.text = [bookmark objectForKey:@"title"];
	
	//self.contentView.backgroundColor = [UIColor clearColor];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set the song and flip to the SongView
	NSDictionary *bookmark = (NSDictionary *)[_bookmarks objectAtIndex:indexPath.row];
	[_delegate modalControllerDidFinishWithSongNumber:[bookmark objectForKey:@"number"]];
}


// Support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete it from the datasource
		[(AppDelegate*)[[UIApplication sharedApplication] delegate] deleteBookmarkForNumber:[[_bookmarks objectAtIndex:indexPath.row] objectForKey:@"number"]];
		// And from the local array
		[_bookmarks removeObjectAtIndex:indexPath.row];
        // Delete the row from the table
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
}


- (IBAction)edit:(id)sender {
	[_table setEditing:YES animated:YES];
}

- (IBAction)done:(id)sender {
	if (_table.editing) {
		[_table setEditing:NO animated:YES];
		return;
	}
	[_delegate modalControllerDidFinishWithSongNumber:[NSNumber numberWithInt:0]];
}

- (void)reloadData
{
	// Populate the array
	if (!_bookmarks) {
		_bookmarks = [(NSMutableArray *)[(AppDelegate*)[[UIApplication sharedApplication] delegate] getBookmarks] retain];
	}
	//NSLog(@"bookmarks retainCount: %i", [_bookmarks retainCount]);
	[_table reloadData];
}

- (AppDelegate *)appDelegate {	
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	// TODO: this will fire along with viewWillAppear sometimes, resulting in a double retain
	[self reloadData];
}

- (void)dealloc {
	[_bookmarks dealloc];
    [super dealloc];
}


@end

