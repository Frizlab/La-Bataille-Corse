/*
 * FLFlashView.h
 * Bataille corse
 *
 * Created by François on 07/06/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import <Cocoa/Cocoa.h>



@interface FLFlashView : NSView {
	NSTimeInterval interval;
	unsigned int nFrame;
}

@property(nonatomic, retain) NSColor *color;
@property(nonatomic) double fps;
@property(nonatomic) double tts;

- (void)computeInterval;
- (void)flash;

@end
