//
//  FLComputerPlayer.m
//  Bataille corse
//
//  Created by François on 21/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <assert.h>
#import "FLComputerPlayer.h"

@implementation FLComputerPlayer

- (id)init
{
	if ((self = [super init]) != nil) {
		srandom((unsigned int)time(NULL));
		
		[self setPlayerName:NSLocalizedString(@"computer", nil)];
		[self setHitKey:nil];
		
		hitTimer = nil;
		
		minAndMaxOfOtherReactionTime.min = 0.;
		minAndMaxOfOtherReactionTime.max = 0.;
		ecartTypeOfOtherReactionTime = 0.;
		averageOfOtherReactionTime = 0.;
	}
	return self;
}

- (void)computeAverage:(float *)averageVar
				 ecartType:(float *)ecartTypeVar
				 andMinMax:(minMax *)minMaxVar
  ofOtherReactionTimes:(FLCycleArray *)players
{
	NSUInteger oldIndex = [players currentIndex], nbrPlayersSeen = 0;
	float somme = 0., sommeCarre = 0., currentTime;
	FLPlayer *currentPlayer;
	
	minMaxVar->min = -1U;
	minMaxVar->max = 0.;
	[players setCurrentObject:self];
	while ((currentPlayer = [players nextObject]) != self) {
		if ([currentPlayer class] == [FLComputerPlayer class])
			continue;
		
		currentTime = [currentPlayer tempsReaction];
		minMaxVar->min = MIN(minMaxVar->min, currentTime);
		minMaxVar->max = MAX(minMaxVar->max, currentTime);
		
		somme += currentTime;
		sommeCarre += currentTime*currentTime;
		nbrPlayersSeen++;
	}
	[players setCurrentIndex:oldIndex];
	
	if (nbrPlayersSeen != 0) {
		(*averageVar) = (somme/nbrPlayersSeen);
		(*ecartTypeVar) = sqrt(fabs((sommeCarre/nbrPlayersSeen) - ((*averageVar)*(*averageVar))));
	} else {
		// There is no real players, I must choose values different than 0
		// to make the game slower
		minMaxVar->min  = 500.;
		minMaxVar->max  = 500.;
		(*averageVar)   = 500.;
		(*ecartTypeVar) =   0.;
	}
}

- (void)hitBySelf:(NSTimer *)t
{
	[hitTimer invalidate];
	hitTimer = nil;
	[super hit];
}

- (void)hitAfter:(float)seconds;
{
	if (hitTimer != nil) {
		NSLog(@"*** Error, I can't hit after %g seconds : Someone had already ask to do this ***",
													  seconds);
		return;
	}
	hitTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
															  target:self
															selector:@selector(hitBySelf:)
															userInfo:nil
															 repeats:NO];
}

// OverWrite
- (void)putOneCardBySelf:(NSTimer *)t
{
	[putCardTimer invalidate];
	putCardTimer = nil;
	[super putOneCard];
}

- (void)putOneCard
{
	if ([[NSUserDefaults standardUserDefaults] boolForKey:FLPossibleToForcePutCard])
		[self putOneCardBySelf:nil];
	else
		NSBeep();
	return;
}

- (float)normalDistributionWithMean:(float)mean andVariance:(float)variance
{
	float	v1, v2, s;
	do {
		v1 = 2*(rand()/(float)RAND_MAX) - 1;
		v2 = 2*(rand()/(float)RAND_MAX) - 1;
		s = v1*v1 + v2*v2;
	} while (s >= 1);
	
	return mean + sqrt(variance)*v1*sqrt((-2.0*log(s)) / s);
}

- (float)tempsReaction
{
	NSInteger levelDifficulty;
	minMax useMinMax, factorMinMax, percentMinMax;
	float diffMaxMin, diffPercent, variance;
	float randomNumber;
	float factor;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	levelDifficulty = [defaults integerForKey:FLLevelDifficulty];
	if (levelDifficulty == FLDifficultyImpossible) return 0.0;
	
	percentMinMax.min = [defaults floatForKey:FLTempsReactionOrdiMin];
	percentMinMax.max = [defaults floatForKey:FLTempsReactionOrdiMax];
	useMinMax.min = minAndMaxOfOtherReactionTime.min -
		((minAndMaxOfOtherReactionTime.min*percentMinMax.min)/100.);
	useMinMax.max = minAndMaxOfOtherReactionTime.max +
		((minAndMaxOfOtherReactionTime.max*percentMinMax.max)/100.);
	
	diffMaxMin  = useMinMax.max - useMinMax.min;
	diffPercent = fabsf(percentMinMax.max - percentMinMax.min);
	// Ce sera la variance utilisée pour la répartition normale
	variance = ecartTypeOfOtherReactionTime + ((diffMaxMin*diffPercent)/100.)/2.;
	
	// Crée un nombre au hasard avec une distribution normale jusqu'à
	// ce qu'il soit entre useMinMax.min et useMinMax.max
	do {
		randomNumber = [self normalDistributionWithMean:averageOfOtherReactionTime andVariance:variance];
	} while (randomNumber < useMinMax.min || randomNumber > useMinMax.max);
	
	factorMinMax.min = 1.0 ; factorMinMax.max = 1.0;
	switch (levelDifficulty) {
		case FLDifficultyVeryEasy : factorMinMax.min = 1.5 ; factorMinMax.max = 2.0 ; break;
		case FLDifficultyEasy     : factorMinMax.min = 1.0 ; factorMinMax.max = 1.5 ; break;
		case FLDifficultyNormal   : factorMinMax.min = 1.0 ; factorMinMax.max = 1.0 ; break;
		case FLDifficultyHard     : factorMinMax.min = 0.5 ; factorMinMax.max = 1.0 ; break;
		case FLDifficultyVeryHard : factorMinMax.min = 0.0 ; factorMinMax.max = 0.5 ; break;
		
		default :
			NSLog(@"*** An error has occured in tempsReaction of FLComputerPlayer :");
			NSLog(@"\tlevelDifficulty is %lu and no correspond to a know level difficulty ***",
										 (unsigned long)levelDifficulty);
			[NSException raise:@"Level difficulty unknown"
							format:@"The level difficulty %lu is unknown (in FLComputerPlayer)",
															(unsigned long)levelDifficulty];
	}
	factor = SSRandomFloatBetween(factorMinMax.min, factorMinMax.max);
	// Multiplie le nombre créé au hasard par un facteur choisi au hasard
	// entre deux bornes qui respectent le niveau de jeu
	randomNumber *= factor;
	randomNumber = MAX(useMinMax.min, randomNumber);
	randomNumber = MIN(useMinMax.max, randomNumber);
	assert(useMinMax.min <= randomNumber);
	assert(useMinMax.max >= randomNumber);
	
	return randomNumber;
}

- (void)setDelegate:(id)anObject
{
	[super setDelegate:anObject];
	if (! [delegate respondsToSelector:@selector(arrayOfPlayers)]) {
		NSLog(@"*** The delegate of an FLComputerPlayer should respond to selector arrayOfPlayers ***");
		return;
	}
	
	[self computeAverage:&averageOfOtherReactionTime
				  ecartType:&ecartTypeOfOtherReactionTime
				  andMinMax:&minAndMaxOfOtherReactionTime
	ofOtherReactionTimes:[delegate arrayOfPlayers]];
#ifndef NDEBUG
	NSLog(@"average   : %g", averageOfOtherReactionTime);
	NSLog(@"ecartType : %g", ecartTypeOfOtherReactionTime);
	NSLog(@"min       : %g", minAndMaxOfOtherReactionTime.min);
	NSLog(@"max       : %g", minAndMaxOfOtherReactionTime.max);
#endif
	// Check if the average is between min and max only if NDEBUG is not define
	assert(minAndMaxOfOtherReactionTime.max >= averageOfOtherReactionTime);
	assert(minAndMaxOfOtherReactionTime.min <= averageOfOtherReactionTime);
}

- (void)invalidateHitTimer
{
	[hitTimer invalidate];
	hitTimer = nil;
}

- (void)invalidateAllMyTimers
{
	[self invalidateHitTimer];
	[super invalidateAllMyTimers];
}

- (void)dealloc
{
#ifndef NDEBUG
	NSLog(@"Deallocing <FLComputerPlayer: 0x%x>...", self);
#endif
	[self invalidateAllMyTimers];
	[super dealloc];
}

@end
