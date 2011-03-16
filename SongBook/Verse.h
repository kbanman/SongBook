//
//  Verse.h
//  SongBook
//
//  Created by Kelly Banman on 11-03-14.
//  Copyright (c) 2011 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Song;

@interface Verse : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSNumber * is_chorus;
@property (nonatomic, retain) Song * song;

- (BOOL)isChorus;

@end
