/*
 * FLPlayer.m
 * Bataille corse
 *
 * Created by François on 12/01/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import "FLPlayer.h"


@implementation FLPlayer

+ (void)initialize
{
	if (self == FLPlayer.class)
		[self setVersion:1];
}

- (id)init
{
	if ((self = [super init]) != nil) {
		[self setPlayerName:NSLocalizedString(@"newPlayer", nil)];
		[self setTempsReaction:750.];
		[self setHitKey:@"\r"];
		_numberOfCards = 0;
		
		putCardTimer     = nil;
		getPutCardsTimer = nil;
		_willPlay         = YES;
		_delegate = self;
		
		_packet = [NSMutableArray new];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	NSInteger version;
	if ((self = [self init]) != nil) {
		version = [decoder versionForClassName:@"FLPlayer"];
		[self setPlayerName:[decoder decodeObject]];
		[decoder decodeValueOfObjCType:@encode(int) at:&_tempsReaction];
		[self setHitKey:[decoder decodeObject]];
		if (version > 0) {
			[decoder decodeValueOfObjCType:@encode(BOOL) at:&_willPlay];
/*			if (version > 1)
				;*/
		}
	}
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:_playerName];
	[coder encodeValueOfObjCType:@encode(int) at:&_tempsReaction];
	[coder encodeObject:_hitKey];
	/* Version 1 */
	[coder encodeValueOfObjCType:@encode(BOOL) at:&_willPlay];
}

/* ***************************** Accessor methods ***************************** */
- (void)setDelegate:(id)anObject
{
	_delegate = anObject;
	if (![_delegate respondsToSelector:@selector(cardView)])
		NSLog(@"*** The delegate of an FLPlayer should respond to selector cardView ***");
}

/* ***************************** Necessary ***************************** */
- (void)putTheCitation
{
	FLCardView *cardView = nil;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *cardsForCitation = [self cardsForCitation:(signed)[defaults integerForKey:FLNbrCardsAmende]];
	
	if ([_delegate respondsToSelector:@selector(player:willPutCitation:)])
		[_delegate player:self willPutCitation:cardsForCitation];
	
	if ([_delegate respondsToSelector:@selector(cardView)])
		cardView = [_delegate cardView];
	
	[cardView insertArrayOfCards:cardsForCitation];
	
	if ([_delegate respondsToSelector:@selector(player:didPutCitation:)])
		[_delegate player:self didPutCitation:cardsForCitation];
}

- (void)reallyPutLastCard
{
	if (!_packet.count) {
#ifndef NDEBUG
		NSLog(@"I'd like to put a card, but I can't, I have no card !!!");
#endif
		return;
	}
	FLCard *lastCard = _packet.lastObject;
	FLCardView *cardView = nil;
	if ([_delegate respondsToSelector:@selector(cardView)])
		cardView = [_delegate cardView];
	
	[cardView addACard:lastCard];
	[_packet removeLastObject];
	
	_numberOfCards--;
	
	if ([_delegate respondsToSelector:@selector(player:didPutTheCard:)])
		[_delegate player:self didPutTheCard:lastCard];
}

- (void)putOneCard
{
	FLCard *lastCard;
	
	lastCard = [_packet lastObject];
	if ([_delegate respondsToSelector:@selector(player:willPutTheCard:)]) {
		if ([_delegate player:self willPutTheCard:lastCard])
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
	if ([_delegate respondsToSelector:@selector(playerWillHit:)]) {
		if ([_delegate playerWillHit:self])
			[self getAllPutCards];
		else
			[self putTheCitation];
	} else
		[self getAllPutCards];
	
	if ([_delegate respondsToSelector:@selector(playerDidHit:)])
		[_delegate playerDidHit:self];
}

/* ***************************** Utils ***************************** */
- (NSArray *)putCardsOnGame
{
	if ([_delegate respondsToSelector:@selector(cardView)])
		return [[_delegate cardView] cards];
	else
		return [NSArray new];
}

/* Anagrammes */
- (NSInteger)passage:(NSUInteger)length withLevels:(NSMutableArray *)levels
{
	NSUInteger i;
	for (i = 0 ; i<length-1 ; i++) {
		if ((NSUInteger)[[levels objectAtIndex:i] intValue] != i+1) {
			return i;
		}
	}
	return -1;
}

/* FLFL
 * Il est possible que le temps pour trouver un anagramme correct
 * soit excessivement long avec cette methode
 * Il faudrait la changer pour que l'echange se fasse entre la première
 * et la derniere carte, la premiere et l'avant derniere... (trouver l'algo)
 * On peut choisir plusieurs suites de cartes possible jusqu'à ce que l'on
 * trouve une suite convenable en s'arrêtant à un certain nombre d'essai
 * pour que l'attente ne soit pas trop longue */
- (NSArray *)cardsForCitation:(signed int)nbrCardsAmende
{
	NSUInteger length = [_packet count], i, lastIndexBasesLevel;
	signed int nbrCardsToPut = MIN(nbrCardsAmende, (signed)_packet.count);
	NSArray *putCards = [self putCardsOnGame];
	NSMutableArray *bases, *level, *returnArray;
	FLGame *game = [FLGame new];
	NSArray *testArray, *result;
	NSRange rangeNbrCards;
	
	_numberOfCards -= nbrCardsAmende;
	if (nbrCardsToPut <= 0)
		return [NSArray new];
	
	rangeNbrCards = NSMakeRange(length-nbrCardsToPut, nbrCardsToPut);
	result = [_packet subarrayWithRange:rangeNbrCards];
	returnArray = [NSMutableArray new];
	[returnArray addArray:result invertingAtIndex:0];
	testArray = [returnArray arrayByAddingObjectsFromArray:putCards];
	if (! [game isHitNecessaryWithCards:testArray]) {
		[_packet removeObjectsInRange:rangeNbrCards];
		return returnArray;
	}
	
	bases = [NSMutableArray new];
	level = [NSMutableArray new];
	for (i = 0 ; i < (length-1) ; i++) {
		[bases addObject:[_packet mutableCopy]];
		[level addObject:@0];
	}
	lastIndexBasesLevel = [bases count];
	
	i = 0;
	while (i<length) {
		NSInteger augment;
		NSUInteger j, currentLevel = [[level objectAtIndex:i] intValue];
		[[bases objectAtIndex:i] exchangeObjectAtIndex:lastIndexBasesLevel-currentLevel-1
											  withObjectAtIndex:lastIndexBasesLevel-i];
		
		returnArray = [NSMutableArray new];
		result = [[bases objectAtIndex:i] subarrayWithRange:rangeNbrCards];
		[returnArray addArray:result atIndex:0];
		testArray = [returnArray arrayByAddingObjectsFromArray:putCards];
#ifndef NDEBUG
		NSLog(@"%@", returnArray);
#endif
		if (! [game isHitNecessaryWithCards:testArray]) {
			[self setPacket:[bases[i] mutableCopy]];
			[_packet removeObjectsInRange:rangeNbrCards];
			return returnArray;
		}
		[level replaceObjectAtIndex:i withObject:[NSNumber numberWithInteger:++currentLevel]];
		for (j = i-1 ; (signed)j>=0 ; j--)
			[bases replaceObjectAtIndex:j withObject:[bases objectAtIndex:i]];
		
		augment = [self passage:length withLevels:level];
		if (augment == -1) {
#ifndef NDEBUG
			NSLog(@"Can't find cards to put under packet whithout hit become necessary");
#endif
			[self setPacket:[bases[i] mutableCopy]];
			[_packet removeObjectsInRange:rangeNbrCards];
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
/* ************* */

- (void)putTheLateCitation
{
	NSArray *cardsToAdd;
	signed int nbrCardsToPut;
	FLCardView *cardView = nil;
	
	if ([_delegate respondsToSelector:@selector(cardView)])
		cardView = [_delegate cardView];
	
	nbrCardsToPut = -_numberOfCards;
	cardsToAdd = [self cardsForCitation:nbrCardsToPut];
	[cardView insertArrayOfCards:cardsToAdd];
	
	_numberOfCards += nbrCardsToPut;
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
	if ([_delegate respondsToSelector:@selector(playerWillGetAllPutCards:)])
		[_delegate playerWillGetAllPutCards:self];
	
	if (![_delegate respondsToSelector:@selector(cardView)]) {
#ifndef NDEBUG
		NSLog(@"*** Can't get put card because I can't have the cardView !!! ***");
#endif
		return;
	} else
		cardView = [_delegate cardView];
	
	putCards = cardView.cards;
	[_packet addArray:putCards invertingAtIndex:0];
	[cardView removeAllCards];
	[self putTheLateCitation];
	
	_numberOfCards += [putCards count];
	
	if ([_delegate respondsToSelector:@selector(playerDidGetAllPutCards:)])
		[_delegate playerDidGetAllPutCards:self];
}

- (void)addCard:(FLCard *)card
{
	[_packet addObject:card];
	[self putTheLateCitation];
	_numberOfCards++;
}

- (void)removePacket
{
	[self setPacket:[NSMutableArray new]];
	_numberOfCards = 0;
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

/* ***************************** Description ***************************** */
- (NSString *)description
{
	return [NSString stringWithFormat:@"player name : %@, tempsReaction : %f, packet : (%@), willPlay %d",
															 _playerName,     _tempsReaction,   _packet,     _willPlay];
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
}



/* Pour le tableau de FLNewGameController (overwrite de la méthode de NSObject) */
- (void)setNilValueForKey:(NSString *)key
{
	if ([key isEqual:@"tempsReaction"]) {
		[self setTempsReaction:0.0];
	} else {
		[super setNilValueForKey:key];
	}
}

@end
