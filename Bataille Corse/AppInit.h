/* AppInit */

#import <Cocoa/Cocoa.h>
#import "FLCard.h"



@interface AppInit : NSObject

@property(nonatomic, retain) IBOutlet NSImageView *cardImage;
@property(nonatomic, retain) IBOutlet NSProgressIndicator *scroller;

- (NSArray *)appInit:(BOOL)refresh;
- (NSArray *)chargeImages;

@end
