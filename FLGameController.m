#import <assert.h>
#import "FLGameController.h"

@implementation FLGameController

//////////////////////// Méthodes d'initialisations ////////////////////////
- (id)init
{
	FLCard *newCard;
	NSArray *newPacket;
	NSLog(@"*** A game controller should be init with a packet and players ***");
	
	newCard = [[FLCard alloc] init];
	if (! newCard) {
		NSLog(@"Can't alloc a card in init method of FLGameController");
		[self release];
		return nil;
	}
	
	newPacket = [[NSArray arrayWithObject:newCard] retain];
	if (! newPacket) {
		NSLog(@"Can't alloc an array in init method of FLGameController");
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
	NSArray *newPlayers;
	NSLog(@"*** A game controller should be init with players ***");
	
	newPlayer = [[FLPlayer alloc] init];
	if (! newPlayer) {
		NSLog(@"Can't alloc a player in initWithPacket: method of FLGameController");
		[self release];
		return nil;
	}
	
	newPlayers = [[NSArray arrayWithObject:newPlayer] retain];
	if (! newPacket) {
		NSLog(@"Can't alloc an array in initWithPacket: method of FLGameController");
		[self release];
		return nil;
	}
	
	self = [self initWithPacket:newPacket andPlayers:newPlayers];
	[newPlayer  release];
	[newPlayers release];
	return self;
}

- (id)initWithPacket:(NSArray *)newPacket andPlayers:(NSArray *)newPlayers
{
	NSNotificationCenter *nc;
	if ((self = [super initWithWindowNibName:@"Game"]) != nil) {
		srandom(time(NULL));
		
		[self setWindowFrameAutosaveName:@"FLGameWindow"];
		[self setPacket:newPacket];
		[self setShouldCascadeWindows:NO];
		players = [[FLCycleArray alloc] initWithArray:newPlayers];
		someOneWillGetPutCards = NO;
		game = [FLGame new];
		nbrCardsToAdd = 0;
		gameIsFinish = NO;
		mustHit = NO;
		
		nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(refreshReasonForHit:) name:FLRefreshBeginner object:nil];
	}
	return self;
}

- (void)windowDidLoad
{
	[self refreshReasonForHit:nil];
	[self beginToPlay];
}

//////////////////////// Utils ////////////////////////
- (BOOL)isInt:(unsigned int)numb inArray:(unsigned int *)array sizeOfArray:(unsigned int)size
{
	unsigned int i;
	for (i = 0 ; i<size ; i++) {
		if (array[i] == numb)
			return YES;
	}
	return NO;
}

- (void)showPlayersInScreen
{
	float sizeOfOneView = [playerView bounds].size.width;
	FLPlayerView *currentView;
	FLPlayer *currentPlayerInMethod;
	NSPoint currentPoint;
	unsigned int i;
	
	for (i = 0 ; i<[players count] ; i++) {
		currentView = [playerView copy];
		currentPoint = NSMakePoint((sizeOfOneView + 20) * i, 0);
		[viewWithPlayers addSubview:currentView];
		[currentView setFrameOrigin:currentPoint];
		
		currentPlayerInMethod = [players objectAtIndex:i];
		[currentView setNbrCards:[currentPlayerInMethod numberOfCards]];
		[currentView setPlayerName:[currentPlayerInMethod playerName]];
		[currentView setEnabled:([players currentObject] == currentPlayerInMethod)];
	}
}

- (void)refreshPlayersView
{
	unsigned int i;
	FLPlayerView *currentView;
	FLPlayer *currentPlayerInMethod;
	NSArray *views = [viewWithPlayers subviews];
	
	assert([views count] == [players count]);
	
	for (i = 0 ; i<[views count] ; i++) {
		currentView = [views objectAtIndex:i];
		currentPlayerInMethod = [players objectAtIndex:i];
		
		[currentView setNbrCards:[currentPlayerInMethod numberOfCards]];
		[currentView setEnabled:([players currentObject] == currentPlayerInMethod)];
	}
}

- (void)removePacketOfAllPlayers
{
	unsigned int i;
	for (i = 0 ; i<[players count] ; i++)
		[[players objectAtIndex:i] removePacket];
}

- (void)initPlayers
{
	unsigned int i;
	for (i = 0 ; i<[players count] ; i++)
		[[players objectAtIndex:i] setDelegate:self];
}

- (void)invalidateTimersOfPlayers
{
	unsigned int i;
	FLPlayer *currentPlayer;
	for (i = 0 ; i<[players count] ; i++) {
		currentPlayer = [players objectAtIndex:i];
		[currentPlayer invalidateAllMyTimers];
	}
}

- (void)invalidateHitTimerOfComputersPlayer
{
	unsigned int i;
	FLPlayer *currentPlayer;
	for (i = 0 ; i<[players count] ; i++) {
		currentPlayer = [players objectAtIndex:i];
		if ([currentPlayer class] == [FLComputerPlayer class])
			[(FLComputerPlayer *)currentPlayer invalidateHitTimer];
	}
}

- (void)currentPlayerPutACardIfItIsAComputerPlayer
{
	if ([[players currentObject] class] == [FLComputerPlayer class]) {
		FLComputerPlayer *player = [players currentObject];
		
		[player invalidatePutCardTimer];
		[player putOneCardAfter:([player tempsReaction] / 1000.)];
	}
}

- (void)computerPlayersHit
{
	FLPlayer *currentPlayer;
	unsigned int n, nPlayers = [players count], i;
	
	[self invalidateHitTimerOfComputersPlayer];
	i = random() % nPlayers;
	for (n = 0 ; n<[players count] ; n++, i++) {
		currentPlayer = [players objectAtIndex:(i % nPlayers)];
		if ([currentPlayer class] == [FLComputerPlayer class])
			[(FLComputerPlayer *)currentPlayer hitAfter:([currentPlayer tempsReaction] / 1000.)];
	}
}

- (void)refreshMustHit
{
	mustHit = [game isHitNecessaryWithCards:[cardView cards]];
	[self invalidateHitTimerOfComputersPlayer];
	if (mustHit)
		[self computerPlayersHit];
}

- (FLPlayer *)whoIsTheOnlyOneToHaveCards
{
	FLPlayer *currentPlayer;
	FLPlayer *thePlayer = nil;
	unsigned int i, count = 0;
	for (i = 0 ; i<[players count] ; i++) {
		currentPlayer = [players objectAtIndex:i];
		if ([currentPlayer numberOfCards] > 0) {
			thePlayer = currentPlayer;
			count++;
		}
		if (count > 1)
			return nil;
	}
	return thePlayer;
}

- (BOOL)allPlayersHaveNoCards
{
	unsigned int i;
	FLPlayer *currentPlayer;
	for (i = 0 ; i<[players count] ; i++) {
		currentPlayer = [players objectAtIndex:i];
		if ([currentPlayer numberOfCards] > 0)
			return NO;
	}
	return YES;
}

- (void)distributePutCards
{
	unsigned int i;
	NSArray *putCards;
	while ([self allPlayersHaveNoCards] && ! mustHit) {
		putCards = [cardView cards];
		[cardView removeAllCards];
		for (i = 0 ; i<[putCards count] ; i++)
			[[players objectAtIndex:(i % [players count])] addACard:[putCards objectAtIndex:i]];
	}
}

- (void)selectNextValidPlayer
{
	if ([self allPlayersHaveNoCards]) {
		[players selectNextIndex];
		if (! mustHit)
			[self distributePutCards];
		return;
	}
	do {
		[players selectNextIndex];
	} while ([[players currentObject] numberOfCards] <= 0);
}

- (void)putMessage:(NSString *)message ifPlayerIsHuman:(FLPlayer *)player
{
	if ([player class] != [FLPlayer class])
		return;
	[reasonHit setStringValue:message];
}

- (void)flashPlayer:(FLPlayer *)aPlayer
{
	unsigned int idx = [players indexOfObject:aPlayer];
	assert(idx != NSNotFound);
	[[[viewWithPlayers subviews] objectAtIndex:idx] flash];
}

//////////////////////// Game methods ////////////////////////
- (BOOL)checkIfOnePlayerWon
{
	FLPlayer *winner = [self whoIsTheOnlyOneToHaveCards];
	if (! winner)
		return NO;
	if ([winner class] == [FLPlayer class]) {
		NSRunAlertPanel(NSLocalizedString(@"bravo"   , nil),
							 NSLocalizedString(@"endMatch", nil),
							 NSLocalizedString(@"ok"      , nil),
							 nil,
							 nil, [winner playerName]);
	} else {
		NSRunAlertPanel(NSLocalizedString(@"dommage", nil),
							 NSLocalizedString(@"improve", nil),
							 NSLocalizedString(@"ok"     , nil),
							 nil,
							 nil, [winner playerName]);
	}
	[self invalidateTimersOfPlayers];
	gameIsFinish = YES;
	[self close];
	return YES;
}

- (void)determineFirstPlayer
{
	[players setCurrentIndex:(random() % [players count])];
}

- (void)distributeCards
{
	cardValue sawValues[NUMBER_OF_CARDS], randomNumber;
	unsigned int cardPut = 0, nPlayers = [players count], i;
	
	if (NUMBER_OF_CARDS > [packet count]) {
		NSLog(@"*** In distributeCards of FLGameController, NUMBER_OF_CARDS > [packet count]");
		NSLog(@"so, I must stop the game ***");
		NSRunAlertPanel(NSLocalizedString(@"error"                 , nil),
							 NSLocalizedString(@"errWhenDistributeCards", nil),
							 NSLocalizedString(@"ok"                    , nil),
							 nil,
							 nil);
		[NSException raise:@"Can't distribute cards"
						format:@"NUMBER_OF_CARDS > [packet count] (%d > %d)",
																 NUMBER_OF_CARDS, [packet count]];
	}
	
	for (i = 0 ; i<NUMBER_OF_CARDS ; i++)
		sawValues[i] = 0;
	
	[self removePacketOfAllPlayers];
	while (cardPut < NUMBER_OF_CARDS) {
		randomNumber = random() % NUMBER_OF_CARDS;
		assert(randomNumber < NUMBER_OF_CARDS);
		
		if (! [self isInt:randomNumber+1 inArray:sawValues sizeOfArray:NUMBER_OF_CARDS]) {
			FLPlayer *actualPlayer = [players objectAtIndex:(cardPut % nPlayers)];
			[actualPlayer addCard:[packet objectAtIndex:randomNumber]];
			
			sawValues[cardPut] = randomNumber+1; // +1 : Pour que 0 ne puisse pas y être 
															 // (le tableau a été initialisé à 0)
			cardPut++;
		}
	}
}

- (void)beginToPlay
{
	[self initPlayers];
	[self distributeCards];
	[self determineFirstPlayer];
	[self showPlayersInScreen];
	[self currentPlayerPutACardIfItIsAComputerPlayer];
}

//////////////////////// Delegate de FLPlayer ////////////////////////
- (BOOL)player:(FLPlayer *)aPlayer willPutTheCard:(FLCard *)theCard
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" will try to put the card \"%@\"", [aPlayer playerName], theCard);
#endif
	return (! mustHit) && (! someOneWillGetPutCards);
}

- (void)player:(FLPlayer *)aPlayer didPutTheCard:(FLCard *)theCard
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" did put the card \"%@\"", [aPlayer playerName], theCard);
#endif
	[self refreshMustHit];
	nbrCardsToAdd--;
	
	[reasonHit setStringValue:@""];
	if ([aPlayer numberOfCards] <= 0) {
		// Informe le joueur actif qu'il n'a plus de cartes
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"noCards", nil),
																					[aPlayer playerName]]
															ifPlayerIsHuman:aPlayer];
	}
	if ([game isNecessaryToChangePlayerWithCard:[cardView lastCard]]) {
		playerWhoPutTheLastSpecialCard = aPlayer;
		nbrCardsToAdd = [game numberOfCardsToAddWithCard:[cardView lastCard]];
		[self selectNextValidPlayer];
		// Indique au joueur actif qu'il doit poser nbrCardsToAdd cartes
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"mustPutNCards", nil),
																[[players currentObject] playerName], nbrCardsToAdd]
							ifPlayerIsHuman:[players currentObject]];
	} else if (nbrCardsToAdd == 0 && ! mustHit) {
		someOneWillGetPutCards = YES;
		[playerWhoPutTheLastSpecialCard getAllPutCardsAfter:
			[playerWhoPutTheLastSpecialCard tempsReaction]/1000.];
		return;
	} else if (nbrCardsToAdd < 0) {
		nbrCardsToAdd = 0;
		[self selectNextValidPlayer];
	}
	if ([[players currentObject] numberOfCards] <= 0) {
		// Informe le joueur actif qu'il n'a plus de cartes
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"noCards", nil),
																		[[players currentObject] playerName]]
										ifPlayerIsHuman:[players currentObject]];
		[self selectNextValidPlayer];
	}
	[self currentPlayerPutACardIfItIsAComputerPlayer];
	
	[self refreshPlayersView];
}

- (BOOL)playerWillHit:(FLPlayer *)aPlayer
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" will try to hit", [aPlayer playerName]);
#endif
	return mustHit;
}

- (void)playerDidHit:(FLPlayer *)aPlayer
{
#ifndef NDEBUG
	NSLog(@"player \"%@\" did hit", [aPlayer playerName]);
#endif
	if (mustHit) {
		// Informe le joueur qu'il a récupéré toutes les cartes grâce à son réflexe
		// et dit pourquoi il a tapé (surtout pour les autres)
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"getCardsReflex", nil),
																		[aPlayer playerName], [game lastReasonForHit]]
													ifPlayerIsHuman:aPlayer];
	}
	
	[self refreshMustHit];
	if ([[players currentObject] numberOfCards] <= 0) {
		// Informe le joueur actif qu'il n'a plus de cartes
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"noCards", nil),
																		[[players currentObject] playerName]]
										ifPlayerIsHuman:[players currentObject]];
		[self selectNextValidPlayer];
		[self currentPlayerPutACardIfItIsAComputerPlayer];
	}
	
	[self refreshPlayersView];
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
	// Informe le joueur aPlayer qu'il a perdu des cartes pour avoir tapé sans raison valable
	[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"citationPut", nil),
				[aPlayer playerName], [[NSUserDefaults standardUserDefaults] integerForKey:FLNbrCardsAmende]]
								ifPlayerIsHuman:aPlayer];
	
	[self refreshPlayersView];
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
	[players setCurrentObject:aPlayer];
	[self refreshPlayersView];
	if ([self checkIfOnePlayerWon])
		return;
	
	[reasonHit setStringValue:[game lastReasonForHit]];
	// Informe le joueur qu'il a récupéré toutes les cartes.
	[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"getCards", nil),
																						[aPlayer playerName]]
											ifPlayerIsHuman:aPlayer];
	// Fais clignoter le joueur qui a recupere toute les cartes
	// pour une information visuelle efficace
	[self flashPlayer:aPlayer];
	
	nbrCardsToAdd = 0;
	someOneWillGetPutCards = NO;
	if ([aPlayer numberOfCards] <= 0) {
		// Informe le joueur actif qu'il n'a plus de cartes
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"noCards", nil),
																		[aPlayer playerName]]
									ifPlayerIsHuman:aPlayer];
		[self selectNextValidPlayer];
	}
	[self invalidateTimersOfPlayers];
	[self currentPlayerPutACardIfItIsAComputerPlayer];
}

- (FLCycleArray *)arrayOfPlayers
{
	return players;
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
	unsigned int i;
	FLPlayer *currentPlayer;
	unsigned int code = [e modifierFlags];
	if ((code & NSAlphaShiftKeyMask) || (code == 256 /* CapsLock release */ )) {
		[super flagsChanged:e];
		return;
	}
	
	for (i = 0 ; i<[players count] ; i++) {
		currentPlayer = [players objectAtIndex:i];
		if ([[NSString stringWithFormat:@"%02d", code] isEqualToString:[currentPlayer hitKey]]) {
			[currentPlayer hit];
			return;
		}
	}

	NSBeep();
}
#endif

- (void)keyDown:(NSEvent *)event
{
	unsigned int i;
	FLPlayer *currentPlayer;
	NSString *input = [event characters];
	if ([event isARepeat])
		return;
	
	if ([input isEqualToString:@" "]) {
		if (someOneWillGetPutCards) {
			[playerWhoPutTheLastSpecialCard getAllPutCards];
		} else {
			[[players currentObject] putOneCard];
		}
		return;
	}
	
	for (i = 0 ; i<[players count] ; i++) {
		currentPlayer = [players objectAtIndex:i];
		if ([input isEqualToString:[currentPlayer hitKey]]) {
			[currentPlayer hit];
			return;
		}
	}
	
	NSBeep();
}

// Pour demander si on veut vraiment arrêter de jouer quand on ferme la fenêtre
- (BOOL)windowShouldClose:(id)sender
{
	if (gameIsFinish)
		return YES;
	
	int choice;
	choice = NSRunAlertPanel(NSLocalizedString(@"sureQuit", nil),
									 NSLocalizedString(@"ifYouQuit", nil),
									 NSLocalizedString(@"yes", nil),
									 NSLocalizedString(@"no", nil),
									 nil);
	if (choice == NSAlertDefaultReturn) {
		gameIsFinish = YES;
		return YES;
	}
	
	return NO;
}

//////////////////////// Notification ////////////////////////
- (void)refreshReasonForHit:(NSNotification *)n
{
	[reasonHit setHidden:(! [[NSUserDefaults standardUserDefaults] boolForKey:FLBeginner])];
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

- (FLCycleArray *)players
{
	return players;
}

- (void)setPlayers:(FLCycleArray *)newPlayers
{
	[self invalidateTimersOfPlayers];
	[players release];
	players = [newPlayers retain];
}

//////////////////////// Méthodes d'action ////////////////////////
// Comme son nom ne l'indique pas, le bouton qui appelle cette méthode est faite pour poser une carte !
- (IBAction)buttonHitClicked:(id)sender
{
	[sender setState:1];
	[[players currentObject] putOneCard];
}

//////////////////////// Methods for the others ////////////////////////
- (void)dealloc
{
#ifndef NDEBUG
	NSLog(@"Deallocing %@...", self);
#endif
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	[self invalidateTimersOfPlayers];
//	[game    release];
	[packet  release];
	[players release];
	[super dealloc];
}

@end
