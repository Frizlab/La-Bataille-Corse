#import "FLCardView.h"

@implementation FLCardView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		cards = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NSArray *)cards
{
	return [[cards copy] autorelease];
}

- (void)setCards:(NSMutableArray *)newCards
{
	[cards release];
	cards = [newCards retain];
	[self setNeedsDisplay:YES];
}

- (void)addACard:(FLCard *)aCard
{
	[cards addObject:aCard];
	[self setNeedsDisplay:YES];
}

- (void)insertArrayOfCards:(NSArray *)cardsToAdd
{
	[cards addArray:cardsToAdd atIndex:0];
	[self setNeedsDisplay:YES];
}

- (void)removeAllCards
{
	[cards removeAllObjects];
	[self setNeedsDisplay:YES];
}

- (FLCard *)lastCard
{
	return [cards lastObject];
}

- (void)drawRect:(NSRect)rect
{
	unsigned int i;
//	NSSize currentSize;
	NSImage *currentImage;
	NSPoint origin = rect.origin;
	
//	[[NSColor blackColor] set];
	for (i = 0 ; i<[cards count] ; i++) {
		currentImage = [[cards objectAtIndex:i] image];
//		currentSize = [currentImage size];
		[currentImage drawAtPoint:origin fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.];
//		[NSBezierPath strokeLineFromPoint:origin
//										  toPoint:NSMakePoint(origin.x, (origin.y + currentSize.height))];
		origin.x += 25;
	}
}

- (void)dealloc
{
	[cards release];
	[super dealloc];
}

@end
