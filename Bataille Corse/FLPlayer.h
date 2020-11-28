//
//  FLPlayer.h
//  Bataille corse
//
//  Created by François on 12/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FLNSMutableArray.h"
#import "FLCycleArray.h"
#import "FLCardView.h"
#import "FLGame.h"
#import "FLCard.h"

@interface FLPlayer : NSObject <NSCoding> {
	id delegate;
	NSMutableArray *packet;
	signed int nbrCards; // Devient négatif quand le joueur doit mettre une amende
								// et qu'il n'a plus assez de cartes pour la mettre
	
	NSTimer *getPutCardsTimer;
	NSTimer *putCardTimer;
	
	NSString *playerName;
	float tempsReaction;
	NSString *hitKey;
	BOOL willPlay;
}

/// Accessor methods ///
- (BOOL)willPlay;
- (void)setWillPlay:(BOOL)newWillPlay;
- (NSString *)playerName;
- (void)setPlayerName:(NSString *)newPlayerName;
- (float)tempsReaction;
- (void)setTempsReaction:(float)newValue;
- (NSString *)hitKey;
- (void)setHitKey:(NSString *)key;
- (NSMutableArray *)packet;
- (void)setPacket:(NSMutableArray *)newPacket;
- (id)delegate;
- (void)setDelegate:(id)anObject;
- (signed int)numberOfCards;

//// Necessary ///
- (void)putTheCitation;
- (void)reallyPutLastCard;
- (void)putOneCard;
- (void)putOneCardBySelf:(NSTimer *)t;
- (void)putOneCardAfter:(float)seconds;
- (void)hit;

/// Utils ///
- (NSArray *)putCardsOnGame;
// Anagrammes //
- (NSInteger)passage:(NSUInteger)length withLevels:(NSMutableArray *)levels;
// Il est possible que le temps pour trouver un anagramme correct
// soit excessivement long avec cette methode
// Il faudrait la changer pour que l'echange se fasse entre la première
// et la derniere carte, la premiere et l'avant derniere... (trouver l'algo)
- (NSArray *)cardsForCitation:(signed int)nbrCardsAmende;
// Fin anagrammes //
- (void)putTheLateCitation;
- (void)getAllPutCardsBySelf:(NSTimer *)t;
- (void)getAllPutCardsAfter:(float)seconds;
- (void)getAllPutCards;
- (void)addCard:(FLCard *)card;
- (void)removePacket;
- (void)invalidateGetPutCardsTimer;
- (void)invalidatePutCardTimer;
- (void)invalidateAllMyTimers;

// The delegate object should have this methods :
- (BOOL)player:(FLPlayer *)aPlayer willPutTheCard:(FLCard *)theCard;
- (void)player:(FLPlayer *)aPlayer  didPutTheCard:(FLCard *)theCard;
- (BOOL)playerWillHit:(FLPlayer *)aPlayer;
- (void)playerDidHit :(FLPlayer *)aPlayer;
- (void)player:(FLPlayer *)aPlayer willPutCitation:(NSArray *)cards;
- (void)player:(FLPlayer *)aPlayer  didPutCitation:(NSArray *)cards;
- (void)playerWillGetAllPutCards:(FLPlayer *)aPlayer;
- (void)playerDidGetAllPutCards :(FLPlayer *)aPlayer;
- (FLCycleArray *)arrayOfPlayers;
- (FLCardView *)cardView;

@end
