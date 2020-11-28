//
//  FLCycleArray.h
//  Bataille corse
//
//  Created by Fran√ßois on 18/02/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FLCycleArray : NSObject {
	NSUInteger currentIndex;
	NSArray *backingStore;
}
- (id)nextObject;
- (void)selectNextIndex;

- (NSUInteger)currentIndex;
- (void)setCurrentIndex:(NSUInteger)index;

- (id)currentObject;
- (BOOL)setCurrentObject:(id)anObject;

- (NSUInteger)validIndexFromIndex:(NSUInteger)index;

- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;

- (id)initWithArray:(NSArray *)array;
- (NSUInteger)indexOfObject:(id)anObject;

@end
