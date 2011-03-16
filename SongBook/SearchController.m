

#import "SearchController.h"
#import "AppDelegate.h"
#import "SongViewController.h"
#import "ChooserController.h"
#import "Song.h"
#import "Verse.h"

@implementation SearchController

@synthesize delegate=_delegate;

- (void)viewDidLoad {
	//NSLog(@"viewDidLoad %i", self.tableView.hidden);
    [super viewDidLoad];
    
	// Grab the MOC from the appDelegate
	managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
	
	filteredSongs = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)setSongsMatchingString:(NSString *)str {
	[filteredSongs removeAllObjects];
	// Core Data
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Verse" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text contains[cd] %@", str, str];
	[request setPredicate:predicate];
	
	NSError *error;
	NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
	
	if (array != nil && [array count] > 0) {
		// Pare down the result to unique songs
		/*for (Verse *verse in [array valueForKeyPath:@"@distinctUnionOfObjects.song"]) {
			[filteredSongs addObject:verse.song];
		}*/
		// Sort the results by song number
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];

		[filteredSongs addObjectsFromArray:[[array valueForKeyPath:@"@distinctUnionOfObjects.song"] sortedArrayUsingDescriptors:sortDescriptors]];
		[sortDescriptor release];
		[sortDescriptors release];
	}
}

- (void)didReceiveMemoryWarning {
	NSLog(@"didReceiveMemoryWarning");
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredSongs count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    
	// Grab the song this entry points to
	Song *song = (Song *)[filteredSongs objectAtIndex:indexPath.row];
	
	songNumber.text = [song.number stringValue];
	songTitle.text = [song getFirstLine];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Song *song = (Song *)[filteredSongs objectAtIndex:indexPath.row];
	[_delegate modalControllerDidFinishWithSongNumber:[song number]];
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	//NSLog(@"shouldReloadTableForSearchString");
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	//NSLog(@"shouldReloadTableForSearchScope");
    return YES;
}

#pragma mark -
#pragma mark Search Bar

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
	//NSLog(@"textDidChange");
	[self setSongsMatchingString:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	[_delegate.numberField becomeFirstResponder];
}

- (void)dealloc {
	[filteredSongs dealloc];
    [super dealloc];
}


@end

