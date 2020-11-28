//
//  FLCalibrateTimeController.h
//  Bataille corse
//
//  Created by François on 21/03/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FLPlayerView.h"
#import "FLCardView.h"
#import "FLPlayer.h"

#define NBR_TRUE_TO_HAVE 15

@interface FLCalibrateTimeController : NSWindowController {
	IBOutlet FLCardView *cardView;
	IBOutlet FLPlayerView *playerView;
	IBOutlet NSTextField *reasonHit;
	IBOutlet NSView *viewWithPlayers;
	
	BOOL mustHit, isCalibrateFinish;
	unsigned int nbrTrue;
	FLPlayer *player;
	NSArray *packet;
	FLGame *game;
	NSDate *now;
	float somme;
}

/// Init methods ///
- (id)initWithPacket:(NSArray *)newPacket;
- (id)initWithPacket:(NSArray *)newPacket andPlayer:(FLPlayer *)newPlayers;

/// Utils ///
- (float)timeBeforePlayerPutACard;
- (void)refreshPlayerView;
- (void)refreshMustHit;
- (BOOL)isInt:(unsigned int)numb inArray:(unsigned int *)array sizeOfArray:(unsigned int)size;
- (void)distributeCards;

/// Interception des événements ///
// Événement clavier 
#ifndef NSPECIALKEY
- (void)flagsChanged:(NSEvent *)e;
#endif
- (void)keyDown:(NSEvent *)event;

/// Notification ///
- (void)refreshReasonForHit:(NSNotification *)n;

/// Méthodes d'accès ///
- (NSArray *)packet;
- (void)setPacket:(NSArray *)newPacket;
- (FLPlayer *)player;
- (void)setPlayer:(FLPlayer *)newPlayer;
- (void)setNow:(NSDate *)newNow;

/// Pour demander si on veut vraiment arrêter de jouer quand on ferme la fenêtre ///
- (BOOL)windowShouldClose:(id)sender;

/// Delegate de FLPlayer ///
- (BOOL)player:(FLPlayer *)aPlayer willPutTheCard:(FLCard *)theCard;
- (void)player:(FLPlayer *)aPlayer didPutTheCard:(FLCard *)theCard;
- (BOOL)playerWillHit:(FLPlayer *)aPlayer;
- (void)playerDidHit:(FLPlayer *)aPlayer;
- (void)player:(FLPlayer *)aPlayer willPutCitation:(NSArray *)cards;
- (void)player:(FLPlayer *)aPlayer didPutCitation:(NSArray *)cards;
- (void)playerWillGetAllPutCards:(FLPlayer *)aPlayer;
- (void)playerDidGetAllPutCards:(FLPlayer *)aPlayer;
- (FLCardView *)cardView;

@end
