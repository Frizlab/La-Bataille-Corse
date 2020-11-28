#import "FLCardView.h"



@implementation FLCardView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		_cards = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)setCards:(NSMutableArray *)newCards
{
	_cards = newCards;
	[self setNeedsDisplay:YES];
}

- (void)addACard:(FLCard *)aCard
{
	[_cards addObject:aCard];
	[self setNeedsDisplay:YES];
}

- (void)insertArrayOfCards:(NSArray *)cardsToAdd
{
	[_cards addArray:cardsToAdd atIndex:0];
	[self setNeedsDisplay:YES];
}

- (void)removeAllCards
{
	[_cards removeAllObjects];
	[self setNeedsDisplay:YES];
}

- (FLCard *)lastCard
{
	return _cards.lastObject;
}

- (void)drawRect:(NSRect)rect
{
	unsigned int i;
//	NSSize currentSize;
	NSImage *currentImage;
	NSPoint origin = rect.origin;
	
//	[[NSColor blackColor] set];
	for (i = 0 ; i<_cards.count ; i++) {
		currentImage = [[_cards objectAtIndex:i] image];
//		currentSize = [currentImage size];
		[currentImage drawAtPoint:origin fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.];
//		[NSBezierPath strokeLineFromPoint:origin
//										  toPoint:NSMakePoint(origin.x, (origin.y + currentSize.height))];
		origin.x += 25;
	}
}

@end
