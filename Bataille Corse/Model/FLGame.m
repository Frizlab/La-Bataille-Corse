/*
 * FLGame.m
 * Bataille corse
 *
 * Created by François on 16/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import "FLGame.h"


@implementation FLGame

- (id)init
{
	if ((self = [super init]) != nil) {
		[self setLastReasonForHit:@""];
	}
	return self;
}

- (BOOL)isNecessaryToChangePlayerWithCard:(FLCard *)card
{
	return [card amIASpecialCard];
}

- (NSUInteger)numberOfCardsToAddWithCard:(FLCard *)card
{
	cardValue valeur = [[card value] valeur];
	switch (valeur) {
		case DAME  : return 2 ; break;
		case ROI   : return 3 ; break;
		case 1     : return 4 ; break;
		case VALET : /* No break */;
		default    : return 1 ; break;
	}
}

- (BOOL)isHitNecessaryWithCards:(NSArray *)cards
{
	if (! [cards count])
		return NO;
	
	NSUInteger i, lastIndex = [cards count] - 1;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	cardValue valeurFirstCard = [[cards objectAtIndex:0] cardValue];
	cardValue valeurLastCard  = [[cards lastObject]		cardValue];
	/* Cas où la dernière carte est un joker */
	if (valeurLastCard == 0) {
//		[lastReasonForHit release];
		[self setLastReasonForHit:NSLocalizedString(@"joker", nil)];
		return YES;
	}
	/* Cas où il y a moins de deux cartes */
	if ([cards count] <= 1)
		return NO;
	/* Cas du début-fin */
	if ([defaults boolForKey:FLDebutFin])
		if (valeurFirstCard == valeurLastCard) {
//			[lastReasonForHit release];
			[self setLastReasonForHit:NSLocalizedString(@"start-end", nil)];
			return YES;
		}
	/* Cas du début-fin-dix */
	if ([defaults boolForKey:FLDebutFinDix])
		if (valeurFirstCard + valeurLastCard == 10) {
//			[lastReasonForHit release];
			[self setLastReasonForHit:NSLocalizedString(@"start-end ten", nil)];
			return YES;
		}
	/* Cas des doubles */
	if ([defaults boolForKey:FLDoubles]) {
		for (i = 1 ; i<=(unsigned)([defaults integerForKey:FLDoublesValue]+1) && i <= lastIndex ; i++) {
			cardValue valeurCurrentStudyCard = [[cards objectAtIndex:lastIndex-i] cardValue];
			if (valeurCurrentStudyCard == valeurLastCard) {
				/* Ici, on sait qu'il faut taper et on détermine le message qui dit pourquoi il le faut */
				[self setLastReasonForHit:[NSString stringWithFormat:@"%@ %@ %lu %@",
					NSLocalizedString(@"doubles", nil),
					NSLocalizedString(@"with", nil),
					(unsigned long)i-1,
					NSLocalizedString(@"cards between", nil)]];
				
				return YES;
			}
		}
	}
	/* Cas des dix */
	if ([defaults boolForKey:FLDix]) {
		for (i = 1 ; i<=(unsigned)([defaults integerForKey:FLDixValue]+1) && i <= lastIndex ; i++) {
			cardValue valeurCurrentStudyCard = [[cards objectAtIndex:lastIndex-i] cardValue];
			if (valeurCurrentStudyCard + valeurLastCard == 10) {
				/* Ici, on sait qu'il faut taper et on détermine le message qui dit pourquoi il le faut */
				[self setLastReasonForHit:[NSString stringWithFormat:@"%@ %@ %lu %@",
					NSLocalizedString(@"ten", nil),
					NSLocalizedString(@"with", nil),
					(unsigned long)i-1,
					NSLocalizedString(@"cards between", nil)]];
				
				return YES;
			}
		}
	}
	/* Dans tous les autres cas */
	return NO;
}

@end
