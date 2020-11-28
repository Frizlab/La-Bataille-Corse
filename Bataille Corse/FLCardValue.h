/*
 * FLCardValue.h
 * Bataille corse
 *
 * Created by François on 02/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

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


typedef NSUInteger cardForm;
typedef NSUInteger cardValue;


@interface FLCardValue : NSObject

@property(nonatomic) cardForm forme;
@property(nonatomic) cardValue valeur;

/* Initialisations */
- (id)initWithValue:(cardValue)initValue andForme:(cardForm)initForme;

@end
