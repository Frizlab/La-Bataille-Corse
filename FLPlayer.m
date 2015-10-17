//
//  FLPlayer.m
//  Bataille corse
//
//  Created by François on 12/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FLPlayer.h"


@implementation FLPlayer

+ (void)initialize
{
	if (self == [FLPlayer class])
		[self setVersion:1];
}

- (id)init
{
	if ((self = [super init]) != nil) {
		[self setPlayerName:NSLocalizedString(@"newPlayer", nil)];
		[self setTempsReaction:750.];
		[self setHitKey:@"\r"];
		nbrCards = 0;
		
		putCardTimer     = nil;
		getPutCardsTimer = nil;
		willPlay         = YES;
		delegate = self;
		
		packet = [[NSMutableArray alloc] init];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	int version;
	if ((self = [self init]) != nil) {
		version = [decoder versionForClassName:@"FLPlayer"];
		[self setPlayerName:[decoder decodeObject]];
		[decoder decodeValueOfObjCType:@encode(int) at:&tempsReaction];
		[self setHitKey:[decoder decodeObject]];
		if (version > 0) {
			[decoder decodeValueOfObjCType:@encode(BOOL) at:&willPlay];
/*			if (version > 1)
				;*/
		}
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:playerName];
	[coder encodeValueOfObjCType:@encode(int) at:&tempsReaction];
	[coder encodeObject:hitKey];
	// Version 1
	[coder encodeValueOfObjCType:@encode(BOOL) at:&willPlay];
}

/////////////////////////////// Accessor methods ///////////////////////////////
- (BOOL)willPlay
{
	return willPlay;
}

- (void)setWillPlay:(BOOL)newWillPlay
{
	willPlay = newWillPlay;
}

- (NSString *)playerName
{
	return playerName;
}

- (void)setPlayerName:(NSString *)newPlayerName
{
	[playerName release];
	playerName = [newPlayerName retain];
}

- (float)tempsReaction
{
	return tempsReaction;
}

- (void)setTempsReaction:(float)newValue
{
	tempsReaction = newValue;
}

- (NSString *)hitKey
{
	return hitKey;
}

- (void)setHitKey:(NSString *)key
{
	[hitKey release];
	hitKey = [key retain];
}

- (NSMutableArray *)packet
{
	return packet;
}

- (void)setPacket:(NSMutableArray *)newPacket
{
	[packet release];
	packet = [newPacket retain];
}

- (id)delegate
{
	return delegate;
}

- (void)setDelegate:(id)anObject
{
	delegate = anObject;
	if (! [delegate respondsToSelector:@selector(cardView)])
		NSLog(@"*** The delegate of an FLPlayer should respond to selector cardView ***");
}

- (signed int)numberOfCards
{
	return nbrCards;
}

/////////////////////////////// Necessary ///////////////////////////////
- (void)putTheCitation
{
	FLCardView *cardView = nil;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *cardsForCitation = [self cardsForCitation:(signed)[defaults integerForKey:FLNbrCardsAmende]];
	
	if ([delegate respondsToSelector:@selector(player:willPutCitation:)])
		[delegate player:self willPutCitation:cardsForCitation];
	
	if ([delegate respondsToSelector:@selector(cardView)])
		cardView = [delegate cardView];
	
	[cardView insertArrayOfCards:cardsForCitation];
	
	if ([delegate respondsToSelector:@selector(player:didPutCitation:)])
		[delegate player:self didPutCitation:cardsForCitation];
}

- (void)reallyPutLastCard
{
	if (! [packet count]) {
#ifndef NDEBUG
		NSLog(@"I'd like to put a card, but I can't, I have no card !!!");
#endif
		return;
	}
	FLCard *lastCard = [packet lastObject];
	FLCardView *cardView = nil;
	if ([delegate respondsToSelector:@selector(cardView)])
		cardView = [delegate cardView];
	
	[cardView addACard:lastCard];
	[packet removeLastObject];
	
	nbrCards--;
	
	if ([delegate respondsToSelector:@selector(player:didPutTheCard:)])
		[delegate player:self didPutTheCard:lastCard];
}

- (void)putOneCard
{
	FLCard *lastCard;
	
	lastCard = [packet lastObject];
	if ([delegate respondsToSelector:@selector(player:willPutTheCard:)]) {
		if ([delegate player:self willPutTheCard:lastCard])
			[self reallyPutLastCard];
	} else
		[self reallyPutLastCard];
}

- (void)putOneCardBySelf:(NSTimer *)t
{
	[putCardTimer invalidate];
	putCardTimer = nil;
	[self putOneCard];
}

- (void)putOneCardAfter:(float)seconds
{
	if (putCardTimer != nil) {
#ifndef NDEBUG
		NSLog(@"*** Error, I can't put a card after %g seconds : Someone had already ask to do this ***",
																seconds);
#endif
		return;
	}
	putCardTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
																	target:self
																 selector:@selector(putOneCardBySelf:)
																 userInfo:nil
																  repeats:NO];
}

- (void)hit
{
	if ([delegate respondsToSelector:@selector(playerWillHit:)]) {
		if ([delegate playerWillHit:self])
			[self getAllPutCards];
		else
			[self putTheCitation];
	} else
		[self getAllPutCards];
	
	if ([delegate respondsToSelector:@selector(playerDidHit:)])
		[delegate playerDidHit:self];
}

/////////////////////////////// Utils ///////////////////////////////
- (NSArray *)putCardsOnGame
{
	if ([delegate respondsToSelector:@selector(cardView)])
		return [[delegate cardView] cards];
	else
		return [[NSArray new] autorelease];
}

// Anagrammes //
- (signed int)passage:(unsigned int)length withLevels:(NSMutableArray *)levels
{
	unsigned int i;
	for (i = 0 ; i<length-1 ; i++) {
		if ((unsigned)[[levels objectAtIndex:i] intValue] != i+1) {
			return i;
		}
	}
	return -1;
}

// FLFL
// Il est possible que le temps pour trouver un anagramme correct
// soit excessivement long avec cette methode
// Il faudrait la changer pour que l'echange se fasse entre la première
// et la derniere carte, la premiere et l'avant derniere... (trouver l'algo)
// On peut choisir plusieurs suites de cartes possible jusqu'à ce que l'on
// trouve une suite convenable en s'arrêtant à un certain nombre d'essai
// pour que l'attente ne soit pas trop longue
- (NSArray *)cardsForCitation:(signed int)nbrCardsAmende
{
	unsigned int length = [packet count], i, lastIndexBasesLevel;
	signed int nbrCardsToPut = MIN(nbrCardsAmende, (signed)[packet count]);
	NSArray *putCards = [self putCardsOnGame];
	NSMutableArray *bases, *level, *returnArray;
	FLGame *game = [[FLGame new] autorelease];
	NSArray *testArray, *result;
	NSRange rangeNbrCards;
	
	nbrCards -= nbrCardsAmende;
	if (nbrCardsToPut <= 0)
		return [[NSArray new] autorelease];
	
	rangeNbrCards = NSMakeRange(length-nbrCardsToPut, nbrCardsToPut);
	result = [packet subarrayWithRange:rangeNbrCards];
	returnArray = [[NSMutableArray new] autorelease];
	[returnArray addArray:result invertingAtIndex:0];
	testArray = [returnArray arrayByAddingObjectsFromArray:putCards];
	if (! [game isHitNecessaryWithCards:testArray]) {
		[packet removeObjectsInRange:rangeNbrCards];
		return returnArray;
	}
	
	bases = [[NSMutableArray new] autorelease];
	level = [[NSMutableArray new] autorelease];
	for (i = 0 ; i < (length-1) ; i++) {
		[bases addObject:[[packet mutableCopy] autorelease]];
		[level addObject:[NSNumber numberWithInt:0]]; // The NSNumber is autoreleased
	}
	lastIndexBasesLevel = [bases count];
	
	i = 0;
	while (i<length) {
		signed int augment;
		unsigned int j, currentLevel = [[level objectAtIndex:i] intValue];
		[[bases objectAtIndex:i] exchangeObjectAtIndex:lastIndexBasesLevel-currentLevel-1
											  withObjectAtIndex:lastIndexBasesLevel-i];
		
		returnArray = [[NSMutableArray new] autorelease];
		result = [[bases objectAtIndex:i] subarrayWithRange:rangeNbrCards];
		[returnArray addArray:result atIndex:0];
		testArray = [returnArray arrayByAddingObjectsFromArray:putCards];
#ifndef NDEBUG
		NSLog(@"%@", returnArray);
#endif
		if (! [game isHitNecessaryWithCards:testArray]) {
			[self setPacket:[[[bases objectAtIndex:i] mutableCopy] autorelease]];
			[packet removeObjectsInRange:rangeNbrCards];
			return returnArray;
		}
		[level replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:++currentLevel]];
		for (j = i-1 ; (signed)j>=0 ; j--)
			[bases replaceObjectAtIndex:j withObject:[bases objectAtIndex:i]];
		
		augment = [self passage:length withLevels:level];
		if (augment == -1) {
#ifndef NDEBUG
			NSLog(@"Can't find cards to put under packet whithout hit become necessary");
#endif
			[self setPacket:[[[bases objectAtIndex:i] mutableCopy] autorelease]];
			[packet removeObjectsInRange:rangeNbrCards];
			return returnArray;
		}
		if (augment) {
			for (j = augment-1 ; (signed)j>=0 ; j--) {
				[level replaceObjectAtIndex:j withObject:[NSNumber numberWithInt:0]];
			}
			i += augment;
		} else {
			i = 0;
		}
	}
	
	assert(0);
	return nil;
}
/////////////////

- (void)putTheLateCitation
{
	NSArray *cardsToAdd;
	signed int nbrCardsToPut;
	FLCardView *cardView = nil;
	
	if ([delegate respondsToSelector:@selector(cardView)])
		cardView = [delegate cardView];
	
	nbrCardsToPut = (-nbrCards);
	cardsToAdd = [self cardsForCitation:nbrCardsToPut];
	[cardView insertArrayOfCards:cardsToAdd];
	
	nbrCards += nbrCardsToPut;
}

- (void)getAllPutCardsBySelf:(NSTimer *)t
{
	[getPutCardsTimer invalidate];
	getPutCardsTimer = nil;
	[self getAllPutCards];
}

- (void)getAllPutCardsAfter:(float)seconds
{
	if (getPutCardsTimer != nil) {
#ifndef NDEBUG
		NSLog(@"*** Error, I can't get cards after %g seconds : Someone had already ask to do this ***",
															  seconds);
#endif
		return;
	}
	getPutCardsTimer = [NSTimer scheduledTimerWithTimeInterval:seconds
																		 target:self
																	  selector:@selector(getAllPutCardsBySelf:)
																	  userInfo:nil
																		repeats:NO];
}

- (void)getAllPutCards
{
	NSArray *putCards;
	FLCardView *cardView;
	if ([delegate respondsToSelector:@selector(playerWillGetAllPutCards:)])
		[delegate playerWillGetAllPutCards:self];
	
	if (! [delegate respondsToSelector:@selector(cardView)]) {
#ifndef NDEBUG
		NSLog(@"*** Can't get put card because I can't have the cardView !!! ***");
#endif
		return;
	} else
		cardView = [delegate cardView];
	
	putCards = [cardView cards];
	[packet addArray:putCards invertingAtIndex:0];
	[cardView removeAllCards];
	[self putTheLateCitation];
	
	nbrCards += [putCards count];
	
	if ([delegate respondsToSelector:@selector(playerDidGetAllPutCards:)])
		[delegate playerDidGetAllPutCards:self];
}

- (void)addCard:(FLCard *)card
{
	[packet addObject:card];
	[self putTheLateCitation];
	nbrCards++;
}

- (void)removePacket
{
	[self setPacket:[[[NSMutableArray alloc] init] autorelease]];
	nbrCards = 0;
}

- (BOOL)player:(FLPlayer *)aPlayer willPutTheCard:(FLCard *)theCard {return YES;}
- (void)player:(FLPlayer *)aPlayer  didPutTheCard:(FLCard *)theCard {}
- (BOOL)playerWillHit:(FLPlayer *)aPlayer {return YES;}
- (void)playerDidHit :(FLPlayer *)aPlayer {}
- (void)player:(FLPlayer *)aPlayer willPutCitation:(NSArray *)cards {}
- (void)player:(FLPlayer *)aPlayer  didPutCitation:(NSArray *)cards {}
- (void)playerWillGetAllPutCards:(FLPlayer *)aPlayer {}
- (void)playerDidGetAllPutCards :(FLPlayer *)aPlayer {}
- (FLCycleArray *)arrayOfPlayers {return nil;}
- (FLCardView *)cardView {return nil;}

/////////////////////////////// Description ///////////////////////////////
- (NSString *)description
{
	return [NSString stringWithFormat:@"player name : %@, tempsReaction : %f, packet : (%@), willPlay %d",
															  playerName,      tempsReaction,    packet,      willPlay];
}

- (void)invalidateGetPutCardsTimer
{
	[getPutCardsTimer invalidate];
	getPutCardsTimer = nil;
}

- (void)invalidatePutCardTimer
{
	[putCardTimer invalidate];
	putCardTimer = nil;
}

- (void)invalidateAllMyTimers
{
	[self invalidateGetPutCardsTimer];
	[self invalidatePutCardTimer];
}

- (void)dealloc
{
#ifndef NDEBUG
	NSLog(@"Dealloc FLPlayer named \"%@\"", [self playerName]);
#endif
	[getPutCardsTimer release];
	[putCardTimer     release];
	[playerName       release];
	[hitKey           release];
	[packet           release];
	[super dealloc];
}



// Pour le tableau de FLNewGameController (overwrite de la méthode de NSObject)
- (void)unableToSetNilForKey:(NSString *)key
{
	if ([key isEqual:@"tempsReaction"]) {
		[self setTempsReaction:0.0];
	} else {
		[super unableToSetNilForKey:key];
	}
}

@end
