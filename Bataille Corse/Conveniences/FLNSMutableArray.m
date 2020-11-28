/*
 * FLNSMutableArray.m
 * Bataille corse
 *
 * Created by François on 20/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import "FLNSMutableArray.h"

@implementation NSMutableArray (extendedMutableArray)

- (void)addArray:(NSArray *)array invertingAtIndex:(NSUInteger)anIndex
{
	NSUInteger i;
	for (i = 0 ; i<array.count ; i++)
		[self insertObject:[array objectAtIndex:i] atIndex:anIndex];
}

- (void)addArray:(NSArray *)array atIndex:(NSUInteger)anIndex
{
	NSUInteger i;
	for (i = 0 ; i<array.count ; i++)
		[self insertObject:[array objectAtIndex:i] atIndex:anIndex + i];
}

@end
