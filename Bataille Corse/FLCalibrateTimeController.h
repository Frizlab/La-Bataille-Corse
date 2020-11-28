/*
 * FLCalibrateTimeController.h
 * Bataille corse
 *
 * Created by François on 21/03/05.
 * Copyright 2005 Frizlab. All rights reserved.
 */

#import <Cocoa/Cocoa.h>
#import "FLPlayerView.h"
#import "FLCardView.h"
#import "FLPlayer.h"



#define NBR_TRUE_TO_HAVE 15

@interface FLCalibrateTimeController : NSWindowController {
	IBOutlet FLPlayerView *playerView;
	IBOutlet NSTextField *reasonHit;
	IBOutlet NSView *viewWithPlayers;
	
	BOOL mustHit, isCalibrateFinish;
	NSUInteger nbrTrue;
	FLGame *game;
	float somme;
}

@property(nonatomic, retain) NSArray *packet;
@property(nonatomic, retain) FLPlayer *player;
@property(nonatomic, retain) NSDate *now;

/* *** Init methods *** */
- (id)initWithPacket:(NSArray *)newPacket;
- (id)initWithPacket:(NSArray *)newPacket andPlayer:(FLPlayer *)newPlayers;

/* *** Utils *** */
- (float)timeBeforePlayerPutACard;
- (void)refreshPlayerView;
- (void)refreshMustHit;
- (BOOL)isInt:(NSUInteger)numb inArray:(NSUInteger *)array sizeOfArray:(NSUInteger)size;
- (void)distributeCards;

/* *** Interception des événements *** */
/* Événement clavier */
#ifndef NSPECIALKEY
- (void)flagsChanged:(NSEvent *)e;
#endif
- (void)keyDown:(NSEvent *)event;

/* *** Notification *** */
- (void)refreshReasonForHit:(NSNotification *)n;

/* *** Pour demander si on veut vraiment arrêter de jouer quand on ferme la fenêtre *** */
- (BOOL)windowShouldClose:(id)sender;

/* *** Delegate de FLPlayer *** */
- (BOOL)player:(FLPlayer *)aPlayer willPutTheCard:(FLCard *)theCard;
- (void)player:(FLPlayer *)aPlayer didPutTheCard:(FLCard *)theCard;
- (BOOL)playerWillHit:(FLPlayer *)aPlayer;
- (void)playerDidHit:(FLPlayer *)aPlayer;
- (void)player:(FLPlayer *)aPlayer willPutCitation:(NSArray *)cards;
- (void)player:(FLPlayer *)aPlayer didPutCitation:(NSArray *)cards;
- (void)playerWillGetAllPutCards:(FLPlayer *)aPlayer;
- (void)playerDidGetAllPutCards:(FLPlayer *)aPlayer;
@property(nonatomic, retain) IBOutlet FLCardView *cardView;

@end
