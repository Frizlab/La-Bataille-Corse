//
//  FLCardValue.h
//  Bataille corse
//
//  Created by François on 02/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define JOKER 0

#define PIQUE   1
#define COEUR   2
#define CARREAU 3
#define TREFLE  4
#define MIN_FORME 0
#define MAX_FORME 4

#define VALET   11
#define DAME    12
#define ROI     13
#define MIN_VALUE 0
#define MAX_VALUE 13

typedef unsigned int cardForm;
typedef unsigned int cardValue;

@interface FLCardValue : NSObject {
	cardForm forme;
	cardValue valeur;
}
// Initialisations //
- (id)initWithValue:(cardValue)initValue andForme:(cardForm)initForme;

// Méthodes d'accès //
- (cardForm)forme;
- (void)setForme:(cardForm)newForme;
- (cardValue)valeur;
- (void)setValeur:(cardValue)newValeur;

@end
