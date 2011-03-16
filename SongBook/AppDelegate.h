//
//  SongBookAppDelegate.h
//  SongBook
//
//  Created by Kelly Banman on 11-03-13.
//  Copyright 2011 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChooserController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)getBookmarks;
- (void)addBookmarkForNumber:(NSNumber *)num withTitle:(NSString *)title;
- (void)deleteBookmarkForNumber:(NSNumber *)num;
- (BOOL)bookmarkExistsForNumber:(NSNumber *)num;

@property (nonatomic, retain) IBOutlet ChooserController *chooserController;

@end
