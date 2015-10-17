/* FLPlayerView */

#import <Cocoa/Cocoa.h>
#import "FLComputerPlayer.h"
#import "FLFlashView.h"

@interface FLPlayerView : NSView <NSCopying, NSCoding> {
	IBOutlet NSButton *buttonState;
	IBOutlet FLFlashView *flashView;
	IBOutlet NSTextField *textFieldNbrCard;
	IBOutlet NSTextField *textFieldPlayerName;
	
	unsigned int enabled, nbrCards;
	NSString *playerName;
}
- (void)setButtonState:(NSButton *)newButton;
- (void)setFlashView:(FLFlashView *)newFlashView;
- (void)setTextFieldNbrCard:(NSTextField *)newTextField;
- (void)setTextFieldPlayerName:(NSTextField *)newTextField;

- (unsigned int)enabled;
- (void)setEnabled:(unsigned int)newState;
- (unsigned int)nbrCards;
- (void)setNbrCards:(signed int)newNbr;
- (NSString *)playerName;
- (void)setPlayerName:(NSString *)newName;

- (void)flash;

@end
