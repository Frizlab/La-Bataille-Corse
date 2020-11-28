//
//  FLTextViewController.h
//  Bataille corse
//
//  Created by François on 25/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FLTextView.h"

@interface FLTextViewController : NSObject {
	NSString *currentRowIdentifier;
	// Read-only
	FLTextView *textView;
}
- (NSString *)currentRowIdentifier;
- (void)setCurrentRowIdentifier:(NSString *)newIdentifier;
- (FLTextView *)textView;

@end
