/*
 * FLTextView.h
 * Bataille corse
 *
 * Created by François on 25/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

/* This class is a subclass of NSTextView, but it should be used for the tableView only */

#import <Cocoa/Cocoa.h>
#import "NSString+Keys.h"

@interface FLTextView : NSTextView {
}
- (void)leaveEiting;

@end
