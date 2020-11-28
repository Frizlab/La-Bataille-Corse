/*
 * FLCard.h
 * Bataille corse
 *
 * Created by François on 02/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import <Cocoa/Cocoa.h>
#import "FLCardValue.h"

@interface FLCard : NSObject

@property(nonatomic, retain) NSImage *image;
@property(nonatomic, retain) FLCardValue *value;

/* Initialisations */
- (id)initWithValue:(cardValue)initValue andForme:(cardForm)initForme;
- (id)initWithFLCardValue:(FLCardValue *)newCardVal;

/* *************************** Utils *************************** */
/* return YES if the card is a junior, a queen, a king or an ace */
- (BOOL)amIASpecialCard;
- (cardValue)cardValue;

@end
