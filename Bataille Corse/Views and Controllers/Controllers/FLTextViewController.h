/*
 * FLTextViewController.h
 * Bataille corse
 *
 * Created by François on 25/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import <Cocoa/Cocoa.h>
#import "FLTextView.h"



@interface FLTextViewController : NSObject

@property(nonatomic, retain) NSString *currentRowIdentifier;
@property(nonatomic, readonly) FLTextView *textView;

@end
