//
//  FLCycleArray.h
//  Bataille corse
//
//  Created by François on 18/02/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FLCycleArray : NSObject {
	unsigned int currentIndex;
	NSArray *backingStore;
}
- (id)nextObject;
- (void)selectNextIndex;

- (unsigned int)currentIndex;
- (void)setCurrentIndex:(unsigned int)index;

- (id)currentObject;
- (BOOL)setCurrentObject:(id)anObject;

- (unsigned int)validIndexFromIndex:(unsigned int)index;

- (unsigned)count;
- (id)objectAtIndex:(unsigned)index;

- (id)initWithArray:(NSArray *)array;
- (unsigned int)indexOfObject:(id)anObject;

@end
