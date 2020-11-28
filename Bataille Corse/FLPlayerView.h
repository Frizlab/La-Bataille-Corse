/* FLPlayerView */

#import <Cocoa/Cocoa.h>
#import "FLComputerPlayer.h"
#import "FLFlashView.h"



@interface FLPlayerView : NSView <NSCopying, NSCoding>

@property(nonatomic, retain) IBOutlet NSButton *buttonState;
@property(nonatomic, retain) IBOutlet FLFlashView *flashView;
@property(nonatomic, retain) IBOutlet NSTextField *textFieldNbrCard;
@property(nonatomic, retain) IBOutlet NSTextField *textFieldPlayerName;

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, assign) NSUInteger nbrCards;
@property(nonatomic, retain) NSString *playerName;

- (void)flash;

@end
