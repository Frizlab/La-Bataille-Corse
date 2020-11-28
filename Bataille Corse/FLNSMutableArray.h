/*
 * FLNSMutableArray.h
 * Bataille corse
 *
 * Created by François on 20/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import <Cocoa/Cocoa.h>


@interface NSMutableArray (extendedMutableArray)

- (void)addArray:(NSArray *)array invertingAtIndex:(NSUInteger)index;
- (void)addArray:(NSArray *)array          atIndex:(NSUInteger)index;

@end
