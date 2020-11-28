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
		
		unsigned int encoded;
		encoded = (unsigned int)_nbrCards; [decoder decodeValueOfObjCType:@encode(unsigned int) at:&encoded];
		encoded = (unsigned int)_enabled;  [decoder decodeValueOfObjCType:@encode(unsigned int) at:&encoded];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[super encodeWithCoder:coder];
	
	[coder encodeObject:_textFieldNbrCard];
	[coder encodeObject:_textFieldPlayerName];
	[coder encodeObject:_flashView];
	[coder encodeObject:_buttonState];
	
	[coder encodeObject:_playerName];
	
	unsigned int decoded;
	[coder encodeValueOfObjCType:@encode(unsigned int) at:&decoded]; _nbrCards = decoded;
	[coder encodeValueOfObjCType:@encode(unsigned int) at:&decoded]; _enabled  = decoded;
}

/* ************************ */
- (void)drawRect:(NSRect)rect
{
	[super drawRect:rect];
}

- (void)setNbrCards:(NSUInteger)newNbr
{
	_nbrCards = newNbr;
	[_textFieldNbrCard setIntegerValue:(NSInteger)_nbrCards];
}

- (void)setPlayerName:(NSString *)newName
{
	_playerName = newName;
	[_textFieldPlayerName setStringValue:_playerName];
}

/* ************************ */
- (void)flash
{
	[_flashView flash];
}

/* NSCopying */
- (id)copyWithZone:(NSZone *)zone
{
	/* Note from self in the future: 😅! */
	NSData *data = [NSArchiver archivedDataWithRootObject:self];
	FLPlayerView *copyPlayer = [NSUnarchiver unarchiveObjectWithData:data];
	return copyPlayer;
}

@end
