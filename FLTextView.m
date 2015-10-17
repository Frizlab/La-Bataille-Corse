//
//  FLTextView.m
//  Bataille corse
//
//  Created by François on 25/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FLTextView.h"

@implementation FLTextView

- (BOOL)resignFirstResponder
{
	// The [super resignFirstResponder] must be here
	if ([[self superview] textShouldEndEditing:self])
		return [super resignFirstResponder];
	else
		return NO;
}

- (void)leaveEiting
{
	[[self window] makeFirstResponder:[self superview]];
}

- (void)flagsChanged:(NSEvent *)e
{
#ifdef NSPECIALKEY
	[super flagsChanged:e];
	return;
#endif
	
	unsigned int code = [e modifierFlags];
	if ((code & NSAlphaShiftKeyMask) || (code == 256 /* CapsLock release */ )) {
		NSBeep();
		return;
	}
	[super setString:[NSString stringWithFormat:@"%02d", code]];
	[self leaveEiting];
}

- (void)keyDown:(NSEvent *)e
{
	NSString *letter = [e charactersIgnoringModifiers];
	[super setString:letter];
	if ([letter length] != 1) {
		NSBeep();
		return;
	}
	if ([letter isEqualToString:@"\t"] || ! [[self superview] textShouldEndEditing:self]) {
		NSBeep();
		[super setString:[letter nameForKey]];
		[super selectAll:nil];
		return;
	}
	[self leaveEiting];
}

@end
