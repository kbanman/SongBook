
#import "AppDelegate.h"
#import "ChooserController.h"

@interface BookmarksController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	
}

@property (nonatomic, retain) NSMutableArray *bookmarks;
@property (nonatomic, retain) ChooserController *delegate;
@property (nonatomic, retain) IBOutlet UITableView *table;

- (IBAction)edit:(id)sender;
- (IBAction)done:(id)sender;
- (void)reloadData;

@end
