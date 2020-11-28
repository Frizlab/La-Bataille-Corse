/* AppInit */

#import <Cocoa/Cocoa.h>
#import "FLCard.h"

@interface AppInit : NSObject {
	IBOutlet NSImageView *cardImage;
	IBOutlet NSProgressIndicator *scroller;
}
- (NSArray *)initApp:(BOOL)refresh;
- (NSArray *)chargeImages;

@end
