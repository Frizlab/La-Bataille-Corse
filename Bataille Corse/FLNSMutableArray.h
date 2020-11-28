/*
 * FLNSMutableArray.h
 * Bataille corse
 *
 * Created by François on 20/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import <Cocoa/Cocoa.h>


@interface NSMutableArray (extendedMutableArray)

- (void)addArray:(NSArray *)array invertingAtIndex:(unsigned int)index;
- (void)addArray:(NSArray *)array          atIndex:(unsigned int)index;

@end
