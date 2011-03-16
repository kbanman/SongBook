//
//  Song.m
//  SongBook
//
//  Created by Kelly Banman on 11-03-14.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import "Song.h"
#import "Verse.h"


@implementation Song
@dynamic number;
@dynamic verses;

- (void)addVersesObject:(Verse *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"verses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"verses"] addObject:value];
    [self didChangeValueForKey:@"verses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeVersesObject:(Verse *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"verses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"verses"] removeObject:value];
    [self didChangeValueForKey:@"verses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addVerses:(NSSet *)value {    
    [self willChangeValueForKey:@"verses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"verses"] unionSet:value];
    [self didChangeValueForKey:@"verses" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeVerses:(NSSet *)value {
    [self willChangeValueForKey:@"verses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"verses"] minusSet:value];
    [self didChangeValueForKey:@"verses" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (NSArray *)getVerses
{
	// Sort the stanzas by index
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	NSArray *vs = [[self verses] sortedArrayUsingDescriptors:sortDescriptors];
	[sortDescriptor release];
	[sortDescriptors release];
	return vs;
}

- (NSString *)getFirstLine
{
	if ([self.verses count] < 1) {
		return @"Empty song";
	}
	return [[[[[self getVerses] objectAtIndex:0] text] componentsSeparatedByString:@"\n"] objectAtIndex:0];
}


@end
