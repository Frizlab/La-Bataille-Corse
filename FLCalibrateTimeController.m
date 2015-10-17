//
//  FLCalibrateTimeController.m
//  Bataille corse
//
//  Created by François on 21/03/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "FLCalibrateTimeController.h"

@implementation FLCalibrateTimeController

- (id)init
{
	FLCard *newCard;
	NSArray *newPacket;
	NSLog(@"*** An FLCalibrateTimeController should be init with a packet and a player ***");
	
	newCard = [[FLCard alloc] init];
	if (! newCard) {
		NSLog(@"Can't alloc a card in init method of FLCalibrateTimeController");
		[self release];
		return nil;
	}
	
	newPacket = [[NSArray arrayWithObject:newCard] retain];
	if (! newPacket) {
		NSLog(@"Can't alloc an array of cards in init method of FLCalibrateTimeController");
		[self release];
		return nil;
	}
	
	self = [self initWithPacket:newPacket];
	[newCard   release];
	[newPacket release];
	return self;
}

- (id)initWithPacket:(NSArray *)newPacket
{
	FLPlayer *newPlayer;
	NSLog(@"*** A game controller should be init with a player ***");
	
	newPlayer = [[FLPlayer alloc] init];
	if (! newPlayer) {
		NSLog(@"Can't alloc a player in initWithPacket: method of FLCalibrateTimeController");
		[self release];
		return nil;
	}
	
	self = [self initWithPacket:newPacket andPlayer:newPlayer];
	[newPlayer  release];
	return self;
}

- (id)initWithPacket:(NSArray *)newPacket andPlayer:(FLPlayer *)newPlayers
{
	NSNotificationCenter *nc;
	if ((self = [super initWithWindowNibName:@"Game"]) != nil) {
		srandom(time(NULL));
		
		[self setWindowFrameAutosaveName:@"FLCalibrateTimeWindow"];
		[self setShouldCascadeWindows:NO];
		[self setPlayer:newPlayers];
		[self setPacket:newPacket];
		game = [FLGame new];
		isCalibrateFinish = NO;
		mustHit = NO;
		nbrTrue = 0;
		somme = 0.;
		
		[player setDelegate:self];
		
		nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(refreshReasonForHit:) name:FLRefreshBeginner object:nil];
	}
	return self;
}

- (void)windowDidLoad
{
	[self distributeCards];
	
	NSPoint currentPoint = NSMakePoint(0, 0);
	[viewWithPlayers addSubview:playerView];
	[playerView setFrameOrigin:currentPoint];
	
	[playerView setNbrCards  :[player numberOfCards]];
	[playerView setPlayerName:[player playerName]];
	[playerView setEnabled   :1];
	
	[player putOneCardAfter:[self timeBeforePlayerPutACard]];
}

//////////////////////// Utils ////////////////////////
- (float)timeBeforePlayerPutACard
{
	return ([player tempsReaction]/1000);
}

- (void)refreshPlayerView
{
	[playerView setNbrCards:[player numberOfCards]];
}

- (void)refreshMustHit
{
	mustHit = [game isHitNecessaryWithCards:[cardView cards]];
	if (mustHit)
		[self setNow:[[NSDate new] autorelease]];
}

- (BOOL)isInt:(unsigned int)numb inArray:(unsigned int *)array sizeOfArray:(unsigned int)size
{
	unsigned int i;
	for (i = 0 ; i<size ; i++) {
		if (array[i] == numb)
			return YES;
	}
	return NO;
}

- (void)distributeCards
{
	cardValue sawValues[NUMBER_OF_CARDS], randomNumber;
	unsigned int cardPut = 0, i;
	
	if (NUMBER_OF_CARDS > [packet count]) {
		NSLog(@"*** In distributeCards of FLGameController, NUMBER_OF_CARDS > [packet count]");
		NSLog(@"so, I must quit ***");
		NSAlert *alert = [NSAlert new];
		alert.messageText = NSLocalizedString(@"error", nil);
		alert.informativeText = NSLocalizedString(@"errWhenDistributeCards", nil);
		[alert addButtonWithTitle:NSLocalizedString(@"ok", nil)];
		[alert runModal];
		[NSApp terminate:nil];
	}
	
	for (i = 0 ; i<NUMBER_OF_CARDS ; i++)
		sawValues[i] = 0;
	
	[player removePacket];
	while (cardPut < NUMBER_OF_CARDS) {
		randomNumber = random() % NUMBER_OF_CARDS;
		assert(randomNumber < NUMBER_OF_CARDS);
		
		if (! [self isInt:randomNumber+1 inArray:sawValues sizeOfArray:NUMBER_OF_CARDS]) {
			[player addCard:[packet objectAtIndex:randomNumber]];
			
			sawValues[cardPut] = randomNumber+1; // Pour que 0 ne puisse pas y être 
															 // (tableau initialisé à 0)
			cardPut++;
		}
	}
}

//////////////////////// Delegate de FLPlayer ////////////////////////
- (BOOL)player:(FLPlayer *)aPlayer willPutTheCard:(FLCard *)theCard
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" will try to put the card \"%@\"", [aPlayer playerName], theCard);
#endif
	return (! mustHit);
}

- (void)player:(FLPlayer *)aPlayer didPutTheCard:(FLCard *)theCard
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" did put the card \"%@\"", [aPlayer playerName], theCard);
#endif
	[self refreshMustHit];
	if (! mustHit)
		if (! isCalibrateFinish)
			[player putOneCardAfter:[self timeBeforePlayerPutACard]];
	[self setNow:[NSDate new]];
	
	[self refreshPlayerView];
}

- (BOOL)playerWillHit:(FLPlayer *)aPlayer
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" will try to hit", [aPlayer playerName]);
#endif
	if (mustHit) {
		nbrTrue++;
		somme += (-[now timeIntervalSinceNow]);
		[player setTempsReaction:(somme/nbrTrue) * 1000];
		// Inform FLNewGameController the time of reaction of one player has changed
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc postNotificationName:FLChangeTimeOfOnePlayer object:nil];
		if (nbrTrue == NBR_TRUE_TO_HAVE) {
			[player invalidateAllMyTimers];
			isCalibrateFinish = YES;
			[self close];
		}
	} else
		[[[viewWithPlayers subviews] objectAtIndex:0] flash];
	
	return mustHit;
}

- (void)playerDidHit:(FLPlayer *)aPlayer
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" did hit", [aPlayer playerName]);
#endif
	if (! mustHit)
		[player getAllPutCards];
	
	[self refreshMustHit];
	[self refreshReasonForHit:nil];
	if (! isCalibrateFinish)
		[player putOneCardAfter:[self timeBeforePlayerPutACard]];
	
	[self refreshPlayerView];
}

- (void)player:(FLPlayer *)aPlayer willPutCitation:(NSArray *)cards
{
#ifndef NDEBUG
//	NSLog(@"player \"%@\" will put the citation \"%@\"", [aPlayer playerName], cards);
	NSLog(@"player \"%@\" will put a citation", [aPlayer playerName]);
#endif
}

- (void)player:(FLPlayer *)aPlayer didPutCitation:(NSArray *)cards
{
#ifndef NDEBUG
//	NSLog(@"player \"%@\" did put the citation \"%@\"", [aPlayer playerName], cards);
	NSLog(@"player \"%@\" did put a citation", [aPlayer playerName]);
#endif
	[self refreshMustHit];
	
	[self refreshPlayerView];
}

- (void)playerWillGetAllPutCards:(FLPlayer *)aPlayer
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" will get all put cards", [aPlayer playerName]);
#endif
}

- (void)playerDidGetAllPutCards:(FLPlayer *)aPlayer
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" did get all put cards", [aPlayer playerName]);
#endif
	[player invalidateAllMyTimers];
	
	[self refreshPlayerView];
}

- (FLCardView *)cardView
{
	return cardView;
}

//////////////////////// Interception des événements ////////////////////////
// Événement clavier
#ifndef NSPECIALKEY
- (void)flagsChanged:(NSEvent *)e
{
	unsigned int code = [e modifierFlags];
	if ((code & NSAlphaShiftKeyMask) || (code == 256 /* CapsLock release */ )) {
		[super flagsChanged:e];
		return;
	}
	
	// FLFL : Ne pas oublier que des joueurs autres que currentPlayer peuvent jouer
	if ([[NSString stringWithFormat:@"%02d", code] isEqualToString:[player hitKey]])
		return;
	
	NSBeep();
}
#endif

- (void)keyDown:(NSEvent *)event
{
	NSString *input = [event charactersIgnoringModifiers];
	if ([event isARepeat])
		return;
	
	if ([input isEqualToString:[player hitKey]]) {
		[player hit];
		return;
	}
	
	NSBeep();
}

//////////////////////// Notification ////////////////////////
- (void)refreshReasonForHit:(NSNotification *)n
{
	[reasonHit setHidden:(! [[NSUserDefaults standardUserDefaults] boolForKey:FLBeginner])];
	[reasonHit setStringValue:[game lastReasonForHit]];
}

//////////////////////// Méthodes d'accès ////////////////////////
- (NSArray *)packet
{
	return packet;
}

- (void)setPacket:(NSArray *)newPacket
{
	[packet release];
	packet = [newPacket retain];
}

- (FLPlayer *)player
{
	return player;
}

- (void)setPlayer:(FLPlayer *)newPlayer
{
	[player release];
	player = [newPlayer retain];
}

- (void)setNow:(NSDate *)newNow
{
	[now release];
	now = [newNow retain];
}

//////////// Pour demander si on veut vraiment arrêter de jouer quand on ferme la fenêtre ////////////
- (BOOL)windowShouldClose:(id)sender
{
	if (isCalibrateFinish)
		return YES;
	
	NSAlert *alert = [NSAlert new];
	alert.messageText = NSLocalizedString(@"sureStopCalibrate", nil);
	alert.informativeText = NSLocalizedString(@"ifYouStop", nil);
	[alert addButtonWithTitle:NSLocalizedString(@"yes", nil)];
	[alert addButtonWithTitle:NSLocalizedString(@"no", nil)];
	NSModalResponse choice = [alert runModal];
	if (-ABS(choice) /* WHY? runModal returns 1000 when ok, NSModalResponseStop = -1000 */ == NSModalResponseStop) {
		isCalibrateFinish = YES;
		return YES;
	}
	
	return NO;
}

//////////////////////// Méthodes d'action ////////////////////////
- (IBAction)buttonHitClicked:(id)sender
{
	[sender setState:1];
}

- (void)dealloc
{
	[packet release];
	[player release];
//	[game   release];
	[now    release];
	[super dealloc];
}

@end
