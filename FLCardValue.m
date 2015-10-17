//
//  FLCardValue.m
//  Bataille corse
//
//  Created by Fran�ois on 02/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FLCardValue.h"


@implementation FLCardValue

///////////////////////////// Initialisations /////////////////////////////
- (id)init
{
	self = [self initWithValue:JOKER andForme:JOKER];
	return self;
}

- (id)initWithValue:(cardValue)initValue andForme:(cardForm)initForme
{
	if ((self = [super init]) != nil) {
		if (initValue < MIN_VALUE || initValue > MAX_VALUE) {
			[self release];
			return nil;
		} else if (initForme < MIN_FORME || initForme > MAX_FORME) {
			[self release];
			return nil;
		}
		[self setValeur:initValue];
		[self setForme:initForme];
	}
	return self;
}

/// M�thodes d'acc�s ///
- (cardForm)forme
{
	return forme;
}

- (void)setForme:(cardForm)newForme
{
	forme = newForme;
}

- (cardValue)valeur
{
	return valeur;
}

- (void)setValeur:(cardValue)newValeur
{
	valeur = newValeur;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Forme : %d, Valeur : %d", forme, valeur];
}

@end
