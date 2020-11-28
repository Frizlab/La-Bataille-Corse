/*
 * FLGame.h
 * Bataille corse
 *
 * Created by François on 16/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import <Cocoa/Cocoa.h>
#import "Constants.h"
#import "FLCard.h"

@interface FLGame : NSObject

@property(nonatomic, retain) NSString *lastReasonForHit;

- (BOOL)isNecessaryToChangePlayerWithCard:(FLCard *)card;
- (NSUInteger)numberOfCardsToAddWithCard:(FLCard *)card;
- (BOOL)isHitNecessaryWithCards:(NSArray *)cards;

@end
