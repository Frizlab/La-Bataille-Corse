//
//  FLGame.h
//  Bataille corse
//
//  Created by François on 16/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Constants.h"
#import "FLCard.h"

@interface FLGame : NSObject {
	NSString *lastReasonForHit;
}
- (BOOL)isNecessaryToChangePlayerWithCard:(FLCard *)card;
- (unsigned int)numberOfCardsToAddWithCard:(FLCard *)card;
- (BOOL)isHitNecessaryWithCards:(NSArray *)cards;

- (NSString *)lastReasonForHit;
- (void)setLastReasonForHit:(NSString *)newReason;

@end
