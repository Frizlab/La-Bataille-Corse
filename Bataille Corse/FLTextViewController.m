//
//  FLTextViewController.m
//  Bataille corse
//
//  Created by François on 25/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FLTextViewController.h"

@implementation FLTextViewController

- (id)init
{
	if ((self = [super init]) != nil) {
		textView = [[FLTextView alloc] init];
		[self setCurrentRowIdentifier:nil];
	}
	return self;
}

- (NSString *)currentRowIdentifier
{
	return currentRowIdentifier;
}

- (void)setCurrentRowIdentifier:(NSString *)newIdentifier
{
	[currentRowIdentifier release];
	currentRowIdentifier = [newIdentifier retain];
}

- (FLTextView *)textView
{
	return textView;
}

//////////////////////// delegate de la fenêtre ////////////////////////
- (id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)anObject
{
	if ([currentRowIdentifier isEqualToString:@"hitKey"] && [anObject class] == [NSTableView class])
		return textView;
	return nil;
}

- (void) dealloc
{
	[currentRowIdentifier release];
	[textView release];
	[super dealloc];
}

@end
