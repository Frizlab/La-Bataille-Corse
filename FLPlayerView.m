#import "FLPlayerView.h"

@implementation FLPlayerView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		[self setPlayerName:@"..."];
		[self setNbrCards:0];
		[self setEnabled:0];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder]) != nil) {
		[self setTextFieldNbrCard:[decoder decodeObject]];
		[self setTextFieldPlayerName:[decoder decodeObject]];
		[self setFlashView:[decoder decodeObject]];
		[self setButtonState:[decoder decodeObject]];
		
		[self setPlayerName:[decoder decodeObject]];
		[decoder decodeValueOfObjCType:@encode(unsigned int) at:&nbrCards];
		[decoder decodeValueOfObjCType:@encode(unsigned int) at:&enabled];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[super encodeWithCoder:coder];
	
	[coder encodeObject:textFieldNbrCard];
	[coder encodeObject:textFieldPlayerName];
	[coder encodeObject:flashView];
	[coder encodeObject:buttonState];
	
	[coder encodeObject:playerName];
	[coder encodeValueOfObjCType:@encode(unsigned int) at:&nbrCards];
	[coder encodeValueOfObjCType:@encode(unsigned int) at:&enabled];
}

////////////////////////////
- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
}

////////////////////////////
- (void)setButtonState:(NSButton *)newButton
{
	[buttonState release];
	buttonState = [newButton retain];
}

- (void)setFlashView:(FLFlashView *)newFlashView
{
	[flashView release];
	flashView = [newFlashView retain];
}

- (void)setTextFieldNbrCard:(NSTextField *)newTextField
{
	[textFieldNbrCard release];
	textFieldNbrCard = [newTextField retain];
}

- (void)setTextFieldPlayerName:(NSTextField *)newTextField
{
	[textFieldPlayerName release];
	textFieldPlayerName = [newTextField retain];
}

- (unsigned int)enabled
{
	return enabled;
}

- (void)setEnabled:(unsigned int)newState
{
	enabled = newState;
	[buttonState setEnabled:enabled];
}

- (unsigned int)nbrCards
{
	return nbrCards;
}

- (void)setNbrCards:(signed int)newNbr
{
	nbrCards = newNbr;
	[textFieldNbrCard setIntValue:nbrCards];
}

- (NSString *)playerName
{
	return playerName;
}

- (void)setPlayerName:(NSString *)newName
{
	[playerName release];
	playerName = [newName retain];
	[textFieldPlayerName setStringValue:playerName];
}

- (void)flash
{
	[flashView flash];
}


// NSCopying
- (id)copyWithZone:(NSZone *)zone
{
	NSData *data = [NSArchiver archivedDataWithRootObject:self];
	FLPlayerView *copyPlayer = [NSUnarchiver unarchiveObjectWithData:data];
	// data is in an autoreleasePool, so, I don't have to release it
	return copyPlayer;
}

- (void)dealloc
{
	[playerName release];
	[super dealloc];
}

@end
