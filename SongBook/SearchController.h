

#import "AppDelegate.h"
@class ChooserController;

@interface SearchController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate> {
	NSMutableArray *filteredSongs;
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) ChooserController *delegate;

- (void)setSongsMatchingString:(NSString *)str;

@end
