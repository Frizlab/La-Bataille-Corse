#import "AppInit.h"



@implementation AppInit

- (NSArray *)appInit:(BOOL)refresh
{
	if (! refresh) {
		srandom((unsigned int)time(NULL));
		_scroller = nil;
		_cardImage = nil;
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
	
	[_scroller setMaxValue:MAX_FORME*MAX_VALUE];
	for (i = MIN_VALUE ; i<=MAX_VALUE ; i++) {
		for (j = MIN_FORME ; j<=MAX_FORME ; j++) {
			currentCard = [[FLCard alloc] initWithValue:i andForme:j];
			if (currentCard) {
#ifndef NDEBUG
				NSLog(@"I have loaded image %lu_%lu", (unsigned long)i, (unsigned long)j);
#endif
				[_cardImage setImage:currentCard.image];
				[_cardImage display];
				[allCards addObject:currentCard];
				[_scroller setDoubleValue:++k];
				[_scroller display];
			}
		}
	}
	return [allCards copy];
}

@end
