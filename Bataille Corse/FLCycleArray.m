//
//  FLCycleArray.m
//  Bataille corse
//
//  Created by François on 18/02/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FLCycleArray.h"

@interface FLCycleArray (private)

- (void)setBackingStore:(NSArray *)array;

@end



@implementation FLCycleArray

- (id)init
{
	NSArray *backStore;
	if ((self = [super init]) != nil) {
		[self setCurrentIndex:0];
		backStore = [[NSArray alloc] init];
		[self setBackingStore:backStore];
		[backStore release];
	}
	return self;
}

- (id)initWithArray:(NSArray *)array
{
	NSArray *backStore;
	if ((self = [super init]) != nil) {
		backStore = [NSArray arrayWithArray:array];
		[self setBackingStore:backStore];
		[self setCurrentIndex:0];
	}
	return self;
}

- (id)nextObject
{
	[self selectNextIndex];
	return [self currentObject];
}

- (void)selectNextIndex
{
	if (++currentIndex >= [self count])
		currentIndex = 0;
}

- (NSUInteger)currentIndex
{
	return currentIndex;
}

- (void)setCurrentIndex:(NSUInteger)anIndex
{
	currentIndex = [self validIndexFromIndex:anIndex];
}

- (id)currentObject
{
	return [self objectAtIndex:currentIndex];
}

- (BOOL)setCurrentObject:(id)anObject
{
	NSUInteger testIndex = [self indexOfObject:anObject];
	if (testIndex != NSNotFound) {
		currentIndex = testIndex;
		return YES;
	}
	return NO;
}

- (NSUInteger)validIndexFromIndex:(NSUInteger)anIndex
{
	return (anIndex % [backingStore count]);
}

/* Method "copy" */
- (NSUInteger)indexOfObject:(id)anObject
{
	return [backingStore indexOfObject:anObject];
}

- (NSUInteger)count
{
	return [backingStore count];
}

- (id)objectAtIndex:(NSUInteger)anIndex
{
	return [backingStore objectAtIndex:anIndex];
}

- (void)dealloc
{
#ifndef NDEBUG
	NSLog(@"Deallocing <%@ : %@>...", [self className], self);
#endif
	[backingStore release];
	[super dealloc];
}

@end


@implementation FLCycleArray (private)

- (void)setBackingStore:(NSArray *)array
{
	[backingStore release];
	backingStore = [array retain];
}

@end
