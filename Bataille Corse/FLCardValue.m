/*
 * FLCardValue.m
 * Bataille corse
 *
 * Created by François on 02/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import "FLCardValue.h"


@implementation FLCardValue

/* *************************** Initialisations *************************** */
- (id)init
{
	self = [self initWithValue:JOKER andForme:JOKER];
	return self;
}

- (id)initWithValue:(cardValue)initValue andForme:(cardForm)initForme
{
	if ((self = [super init]) != nil) {
		if (initValue < MIN_VALUE || initValue > MAX_VALUE) {
			return nil;
		} else if (initForme < MIN_FORME || initForme > MAX_FORME) {
			return nil;
		}
		
		[self setValeur:initValue];
		[self setForme:initForme];
	}
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Forme : %d, Valeur : %d", _forme, _valeur];
}

@end
