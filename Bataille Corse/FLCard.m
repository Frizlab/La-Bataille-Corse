//
//  FLCard.m
//  Bataille corse
//
//  Created by François on 02/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FLCard.h"


@implementation FLCard

///////////////////////////// Initialisations /////////////////////////////
- (id)init
{
	FLCardValue *newCardVal = [[FLCardValue alloc] init];
	if (! newCardVal) {
		[self release];
		return nil;
	}
	self = [self initWithFLCardValue:newCardVal];
	[newCardVal release];
	return self;
}

- (id)initWithValue:(cardValue)initValue andForme:(cardForm)initForme
{
	FLCardValue *newCardVal = [[FLCardValue alloc] initWithValue:initValue andForme:initForme];
	if (! newCardVal) {
		[self release];
		return nil;
	}
	self = [self initWithFLCardValue:newCardVal];
	[newCardVal release];
	return self;
}

- (id)initWithFLCardValue:(FLCardValue *)newCardVal
{
	NSString *fileName;
	NSImage *currentImage;
	if ((self = [super init]) != nil) {
		[self setValue:cardVal];
		fileName = [NSString stringWithFormat:@"%d_%d", [newCardVal valeur], [newCardVal forme]];
//		fullPathName = [[NSBundle mainBundle] pathForResource:fileName ofType:@"tiff"];
//		fullPathName = [[NSBundle mainBundle] pathForResource:fileName ofType:@"tiff" inDirectory:@"cartes"];
		currentImage = [NSImage imageNamed:fileName];
		if (! currentImage) {
#ifndef NDEBUG
			NSLog(@"Can't load image %@", fileName);
#endif
			[self release];
			return nil;
		}
		[self setImage:currentImage];
		[currentImage release];
		
		[self setValue:newCardVal];
	}
	return self;
}

///////////////////////////// Acces methods /////////////////////////////
- (NSImage *)image
{
	return image;
}

- (void)setImage:(NSImage *)newImage
{
	[newImage retain];
	[image release];
	image = newImage;
}

- (FLCardValue *)value
{
	return cardVal;
}

- (void)setValue:(FLCardValue *)newValue
{
	[newValue retain];
	[cardVal release];
	cardVal = newValue;
}

///////////////////////////// Utils /////////////////////////////
// return YES if the card is a junior, a queen, a king or an ace
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
	[image release];
	[cardVal release];
	[super dealloc];
}

@end
