//
//  Song.h
//  SongBook
//
//  Created by Kelly Banman on 11-03-14.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Verse;

@interface Song : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSSet* verses;

- (void)addVerses:(NSSet *)value;
- (NSString *)getFirstLine;
- (NSArray *)getVerses;

@end
