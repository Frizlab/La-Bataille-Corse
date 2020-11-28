/*
 * FLFlashView.m
 * Bataille corse
 *
 * Created by François on 07/06/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import "FLFlashView.h"

@implementation FLFlashView

- (id)initWithFrame:(NSRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil) {
		[self setColor:[NSColor colorWithCalibratedRed:192./255.
															  green:23./255.
																blue:49./255.
															  alpha:0.]];
		self.fps = 30.;
		self.tts = 0.5;
		[self computeInterval];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	if ((self = [super initWithCoder:decoder]) != nil) {
		[self setColor:[decoder decodeObject]];
		
		[decoder decodeValueOfObjCType:@encode(NSTimeInterval) at:&interval];
		[decoder decodeValueOfObjCType:@encode(double)         at:&_fps];
		[decoder decodeValueOfObjCType:@encode(double)         at:&_tts];
		
		[self computeInterval];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[super encodeWithCoder:coder];
	
	[coder encodeObject:_color];
	
	[coder encodeValueOfObjCType:@encode(NSTimeInterval) at:&interval];
	[coder encodeValueOfObjCType:@encode(double)         at:&_fps];
	[coder encodeValueOfObjCType:@encode(double)         at:&_tts];
}

- (void)timerDecrease:(NSTimer *)t
{
	self.color = [_color colorWithAlphaComponent:_color.alphaComponent - (1./nFrame)];
	[self display];
	
	if (_color.alphaComponent <= 0.)
		[t invalidate];
}

- (void)timerIncrease:(NSTimer *)t
{
	self.color = [_color colorWithAlphaComponent:_color.alphaComponent + (1./nFrame)];
	[self display];
	
	if (_color.alphaComponent >= 1.) {
		[t invalidate];
		[NSTimer scheduledTimerWithTimeInterval:interval target:self
												 selector:@selector(timerDecrease:)
												 userInfo:nil repeats:YES];
	}
}

- (void)flash
{
	if ([_color alphaComponent] <= 0.)
		[NSTimer scheduledTimerWithTimeInterval:interval target:self
												 selector:@selector(timerIncrease:)
												 userInfo:nil repeats:YES];
}

- (void)drawRect:(NSRect)rect
{
	[_color set];
	[NSBezierPath fillRect:rect];
}

- (void)computeInterval
{
	nFrame = (int)(_fps * _tts);
	interval = (_tts/nFrame)/2;
}

- (void)setFps:(double)newFps
{
	_fps = newFps;
	[self computeInterval];
}

- (void)setTts:(double)newTts
{
	_tts = newTts;
	[self computeInterval];
}

@end
