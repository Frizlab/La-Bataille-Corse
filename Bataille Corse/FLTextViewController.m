/*
 * FLTextViewController.m
 * Bataille corse
 *
 * Created by François on 25/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import "FLTextViewController.h"



@implementation FLTextViewController

- (id)init
{
	if ((self = [super init]) != nil) {
		_textView = [[FLTextView alloc] init];
		self.currentRowIdentifier = nil;
	}
	return self;
}

/* ********************** delegate de la fenêtre ********************** */
- (id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)anObject
{
	if ([_currentRowIdentifier isEqualToString:@"hitKey"] && [anObject class] == NSTableView.class)
		return _textView;
	
	return nil;
}

@end
