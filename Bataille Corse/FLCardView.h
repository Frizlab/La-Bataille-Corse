/* FLCardView */

#import <Cocoa/Cocoa.h>
#import "FLNSMutableArray.h"
#import "FLCard.h"



@interface FLCardView : NSView {
	NSMutableArray *_cards;
}

@property(nonatomic, retain) NSArray *cards;

- (void)addACard:(FLCard *)aCard;
- (void)insertArrayOfCards:(NSArray *)cardsToAdd;
- (void)removeAllCards;

- (FLCard *)lastCard;

@end
