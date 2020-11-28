//
//  FLNSMutableArray.m
//  Bataille corse
//
//  Created by François on 20/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FLNSMutableArray.h"

@implementation NSMutableArray (extendedMutableArray)

- (void)addArray:(NSArray *)array invertingAtIndex:(unsigned int)anIndex
{
	unsigned int i;
	for (i = 0 ; i<[array count] ; i++)
		[self insertObject:[array objectAtIndex:i] atIndex:anIndex];
}

- (void)addArray:(NSArray *)array atIndex:(unsigned int)anIndex
{
	unsigned int i;
	for (i = 0 ; i<[array count] ; i++)
		[self insertObject:[array objectAtIndex:i] atIndex:anIndex + i];
}

@end
