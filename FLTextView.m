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
	if ([(id)[self superview] textShouldEndEditing:self])
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
	
# else
	
	unsigned int code = [e modifierFlags];
	if ((code & NSEventModifierFlagCapsLock) || (code == 256 /* CapsLock release */ )) {
		NSBeep();
		return;
	}
	[super setString:[NSString stringWithFormat:@"%02d", code]];
	[self leaveEiting];
#endif
}

- (void)keyDown:(NSEvent *)e
{
	NSString *letter = [e charactersIgnoringModifiers];
	[super setString:letter];
	if ([letter length] != 1) {
		NSBeep();
		return;
	}
	if ([letter isEqualToString:@"\t"] || ! [(id)[self superview] textShouldEndEditing:self]) {
		NSBeep();
		[super setString:[letter nameForKey]];
		[super selectAll:nil];
		return;
	}
	[self leaveEiting];
}

@end
