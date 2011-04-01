

#import "AppDelegate.h"
@class ChooserController;

@interface SearchController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {
	NSMutableArray *filteredSongs;
	NSManagedObjectContext *managedObjectContext;
	NSTimer *delay;
}

@property (nonatomic, retain) ChooserController *delegate;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayer;

- (void)setSongsMatchingString:(NSTimer *)timer;
- (void)reloadSearchResults;
@end
