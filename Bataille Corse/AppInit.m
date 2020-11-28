#import "AppInit.h"

@implementation AppInit

- (NSArray *)initApp:(BOOL)refresh
{
	if (! refresh) {
		scroller = nil;
		cardImage = nil;
	}
	return [self chargeImages];
}

- (NSArray *)chargeImages
{
	cardForm j;
	cardValue i;
	float k = 1;
	FLCard *currentCard;
	NSMutableArray *allCards = [[NSMutableArray alloc] init];
	NSArray *retour;
	
	[scroller setMaxValue:MAX_FORME*MAX_VALUE];
	for (i = MIN_VALUE ; i<=MAX_VALUE ; i++) {
		for (j = MIN_FORME ; j<=MAX_FORME ; j++) {
			currentCard = [[FLCard alloc] initWithValue:i andForme:j];
			if (currentCard) {
#ifndef NDEBUG
				NSLog(@"I have loaded image %d_%d.tiff", i, j);
#endif
				[cardImage setImage:[currentCard image]];
				[cardImage display];
				[allCards addObject:currentCard];
				[scroller setDoubleValue:++k];
				[scroller display];
			}
		}
	}
	retour = [allCards copy];
	// Le copy ne fait pas de retain des objets !!!!!!!!!!!
	[allCards release];
	return retour;
}

@end
