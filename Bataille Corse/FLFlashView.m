//
//  FLFlashView.m
//  Bataille corse
//
//  Created by François on 07/06/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FLFlashView.h"

@implementation FLFlashView

- (id)initWithFrame:(NSRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil) {
		[self setColor:[NSColor colorWithCalibratedRed:192./255.
															  green:23./255.
																blue:49./255.
															  alpha:0.]];
		fps = 30.;
		tts = 0.5;
		[self computeInterval];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder]) != nil) {
		[self setColor:[decoder decodeObject]];
		
		[decoder decodeValueOfObjCType:@encode(NSTimeInterval) at:&interval];
		[decoder decodeValueOfObjCType:@encode(double)         at:&fps];
		[decoder decodeValueOfObjCType:@encode(double)         at:&tts];
		
		[self computeInterval];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[super encodeWithCoder:coder];
	
	[coder encodeObject:color];
	
	[coder encodeValueOfObjCType:@encode(NSTimeInterval) at:&interval];
	[coder encodeValueOfObjCType:@encode(double)         at:&fps];
	[coder encodeValueOfObjCType:@encode(double)         at:&tts];
}

- (void)timerDecrease:(NSTimer *)t
{
	[self setColor:[[color colorWithAlphaComponent:[color alphaComponent]-(1./nFrame)] retain]];
	[color release];
	[self display];
	
	if ([color alphaComponent] <= 0.)
		[t invalidate];
}

- (void)timerIncrease:(NSTimer *)t
{
	[self setColor:[[color colorWithAlphaComponent:[color alphaComponent]+(1./nFrame)] retain]];
	[color release];
	[self display];
	
	if ([color alphaComponent] >= 1.) {
		[t invalidate];
		[NSTimer scheduledTimerWithTimeInterval:interval target:self
												 selector:@selector(timerDecrease:)
												 userInfo:nil repeats:YES];
	}
}

- (void)flash
{
	if ([color alphaComponent] <= 0.)
		[NSTimer scheduledTimerWithTimeInterval:interval target:self
												 selector:@selector(timerIncrease:)
												 userInfo:nil repeats:YES];
}

- (void)drawRect:(NSRect)rect
{
	[color set];
	[NSBezierPath fillRect:rect];
}

- (void)computeInterval
{
	nFrame = (int)(fps*tts);
	interval = (tts/nFrame)/2;
}

- (NSColor *)color
{
	return color;
}

- (void)setColor:(NSColor *)newColor
{
	[color release];
	color = [newColor retain];
}

// Frame per seconds
- (double)fps
{
	return fps;
}

- (void)setFps:(double)newFps
{
	fps = newFps;
	[self computeInterval];
}

// Temps total en secondes
- (double)tts
{
	return tts;
}

- (void)setTts:(double)newTts
{
	tts = newTts;
	[self computeInterval];
}

@end
