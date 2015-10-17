/* FLCardView */

#import <Cocoa/Cocoa.h>
#import "FLNSMutableArray.h"
#import "FLCard.h"

@interface FLCardView : NSView {
	NSMutableArray *cards;
}
- (NSArray *)cards;
- (void)setCards:(NSMutableArray *)newCards;

- (void)addACard:(FLCard *)aCard;
- (void)insertArrayOfCards:(NSArray *)cardsToAdd;
- (void)removeAllCards;

- (FLCard *)lastCard;

@end
