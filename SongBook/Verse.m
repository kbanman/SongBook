//
//  Verse.m
//  SongBook
//
//  Created by Kelly Banman on 11-03-14.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import "Verse.h"
#import "Song.h"


@implementation Verse
@dynamic text;
@dynamic number;
@dynamic index;
@dynamic is_chorus;
@dynamic song;

- (BOOL)isChorus
{
	return [self.is_chorus boolValue];
}

@end
