/*
 * FLCard.m
 * Bataille corse
 *
 * Created by François on 02/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import "FLCard.h"


@implementation FLCard

@synthesize value = cardVal;

/* *************************** Initialisations *************************** */
- (id)init
{
	FLCardValue *newCardVal = [[FLCardValue alloc] init];
	if (! newCardVal) {
		return nil;
	}
	self = [self initWithFLCardValue:newCardVal];
	return self;
}

- (id)initWithValue:(cardValue)initValue andForme:(cardForm)initForme
{
	FLCardValue *newCardVal = [[FLCardValue alloc] initWithValue:initValue andForme:initForme];
	if (!newCardVal) {
		return nil;
	}
	
	self = [self initWithFLCardValue:newCardVal];
	return self;
}

- (id)initWithFLCardValue:(FLCardValue *)newCardVal
{
	NSString *fileName;
	NSImage *currentImage;
	if ((self = [super init]) != nil) {
		[self setValue:cardVal];
		fileName = [NSString stringWithFormat:@"%d_%d", [newCardVal valeur], [newCardVal forme]];
		currentImage = [NSImage imageNamed:fileName];
		if (! currentImage) {
#ifndef NDEBUG
			NSLog(@"Can't load image %@", fileName);
#endif
			return nil;
		}
		[self setImage:currentImage];
		[self setValue:newCardVal];
	}
	return self;
}

/* *************************** Utils *************************** */
/* return YES if the card is a junior, a queen, a king or an ace */
- (BOOL)amIASpecialCard
{
	cardValue val = [[self value] valeur];
	switch (val) {
		case VALET : /* No break */;
		case DAME  : /* No break */;
		case ROI   : /* No break */;
		case 1     : return YES ; break;
		default    : return NO;
	}
	return NO;
}

- (cardValue)cardValue
{
	return [[self value] valeur];
}

- (cardForm)cardForm
{
	return [[self value] forme];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"card : value : %@", cardVal];
}

- (void)dealloc
{
#ifndef NDEBUG
	NSLog(@"Deallocing card (%@)...", self);
#endif
}

@end
