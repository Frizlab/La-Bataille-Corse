//
//  FLFlashView.h
//  Bataille corse
//
//  Created by François on 07/06/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FLFlashView : NSView {
	NSTimeInterval interval;
	unsigned int nFrame;
	double fps, tts;
	NSColor *color;
}
- (void)computeInterval;
- (NSColor *)color;
- (void)setColor:(NSColor *)newColor;
- (double)fps; // Frame per seconds
- (void)setFps:(double)newFps;
- (double)tts; // Temps total en secondes
- (void)setTts:(double)newTts;

- (void)flash;

@end
