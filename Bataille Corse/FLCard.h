//
//  FLCard.h
//  Bataille corse
//
//  Created by François on 02/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FLCardValue.h"

@interface FLCard : NSObject {
	NSImage *image;
	FLCardValue *cardVal;
}

// Initialisations //
- (id)initWithValue:(cardValue)initValue andForme:(cardForm)initForme;
- (id)initWithFLCardValue:(FLCardValue *)newCardVal;

// Acces methods //
- (NSImage *)image;
- (void)setImage:(NSImage *)newImage;
- (FLCardValue *)value;
- (void)setValue:(FLCardValue *)newValue;

///////////////////////////// Utils /////////////////////////////
// return YES if the card is a junior, a queen, a king or an ace
- (BOOL)amIASpecialCard;
- (cardValue)cardValue;

@end
