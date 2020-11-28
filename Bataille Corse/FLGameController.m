#import <assert.h>
#import "Constants.h"
#import "FLGameController.h"

@implementation FLGameController

/* ********************** Méthodes d'initialisations ********************** */
- (id)init
{
	FLCard *newCard;
	NSArray *newPacket;
	NSLog(@"*** A game controller should be init with a packet and players ***");
	
	newCard = [FLCard new];
	if (! newCard) {
		NSLog(@"Can't alloc a card in init method of FLGameController");
		return nil;
	}
	
	newPacket = @[newCard];
	if (! newPacket) {
		NSLog(@"Can't alloc an array in init method of FLGameController");
		return nil;
	}
	
	self = [self initWithPacket:newPacket];
	return self;
}

- (id)initWithPacket:(NSArray *)newPacket
{
	FLPlayer *newPlayer;
	NSArray *newPlayers;
	NSLog(@"*** A game controller should be init with players ***");
	
	newPlayer = [FLPlayer new];
	if (! newPlayer) {
		NSLog(@"Can't alloc a player in initWithPacket: method of FLGameController");
		return nil;
	}
	
	newPlayers = @[newPlayer];
	if (! newPacket) {
		NSLog(@"Can't alloc an array in initWithPacket: method of FLGameController");
		return nil;
	}
	
	self = [self initWithPacket:newPacket andPlayers:newPlayers];
	return self;
}

- (id)initWithPacket:(NSArray *)newPacket andPlayers:(NSArray *)newPlayers
{
	NSNotificationCenter *nc;
	if ((self = [super initWithWindowNibName:@"Game"]) != nil) {
		srandom((unsigned int)time(NULL));
		
		[self setWindowFrameAutosaveName:@"FLGameWindow"];
		[self setPacket:newPacket];
		[self setShouldCascadeWindows:NO];
		_players = [[FLCycleArray alloc] initWithArray:newPlayers];
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

/* ********************** Utils ********************** */
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
	
	for (i = 0 ; i<_players.count ; i++) {
		currentView = [playerView copy];
		currentPoint = NSMakePoint((sizeOfOneView + 20) * i, 0);
		[viewWithPlayers addSubview:currentView];
		[currentView setFrameOrigin:currentPoint];
		
		currentPlayerInMethod = [_players objectAtIndex:i];
		[currentView setNbrCards:[currentPlayerInMethod numberOfCards]];
		[currentView setPlayerName:[currentPlayerInMethod playerName]];
		[currentView setEnabled:(_players.currentObject == currentPlayerInMethod)];
	}
}

- (void)refreshPlayersView
{
	unsigned int i;
	FLPlayerView *currentView;
	FLPlayer *currentPlayerInMethod;
	NSArray *views = [viewWithPlayers subviews];
	
	assert([views count] == _players.count);
	
	for (i = 0 ; i<[views count] ; i++) {
		currentView = [views objectAtIndex:i];
		currentPlayerInMethod = [_players objectAtIndex:i];
		
		[currentView setNbrCards:currentPlayerInMethod.numberOfCards];
		[currentView setEnabled:(_players.currentObject == currentPlayerInMethod)];
	}
}

- (void)removePacketOfAllPlayers
{
	unsigned int i;
	for (i = 0 ; i<_players.count ; i++)
		[[_players objectAtIndex:i] removePacket];
}

- (void)initPlayers
{
	unsigned int i;
	for (i = 0 ; i<_players.count ; i++)
		[[_players objectAtIndex:i] setDelegate:self];
}

- (void)invalidateTimersOfPlayers
{
	unsigned int i;
	FLPlayer *currentPlayer;
	for (i = 0 ; i<_players.count ; i++) {
		currentPlayer = [_players objectAtIndex:i];
		[currentPlayer invalidateAllMyTimers];
	}
}

- (void)invalidateHitTimerOfComputersPlayer
{
	unsigned int i;
	FLPlayer *currentPlayer;
	for (i = 0 ; i<_players.count ; i++) {
		currentPlayer = [_players objectAtIndex:i];
		if ([currentPlayer class] == [FLComputerPlayer class])
			[(FLComputerPlayer *)currentPlayer invalidateHitTimer];
	}
}

- (void)currentPlayerPutACardIfItIsAComputerPlayer
{
	if ([_players.currentObject class] == FLComputerPlayer.class) {
		FLComputerPlayer *player = _players.currentObject;
		
		[player invalidatePutCardTimer];
		[player putOneCardAfter:([player tempsReaction] / 1000.)];
	}
}

- (void)computerPlayersHit
{
	FLPlayer *currentPlayer;
	NSUInteger n, nPlayers = _players.count, i;
	
	[self invalidateHitTimerOfComputersPlayer];
	i = random() % nPlayers;
	for (n = 0 ; n<_players.count ; n++, i++) {
		currentPlayer = [_players objectAtIndex:(i % nPlayers)];
		if ([currentPlayer class] == FLComputerPlayer.class)
			[(FLComputerPlayer *)currentPlayer hitAfter:(currentPlayer.tempsReaction / 1000.)];
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
	for (i = 0 ; i<_players.count ; i++) {
		currentPlayer = [_players objectAtIndex:i];
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
	for (i = 0 ; i<[_players count] ; i++) {
		currentPlayer = [_players objectAtIndex:i];
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
			[[_players objectAtIndex:(i % _players.count)] addACard:[putCards objectAtIndex:i]];
	}
}

- (void)selectNextValidPlayer
{
	if ([self allPlayersHaveNoCards]) {
		[_players selectNextIndex];
		if (! mustHit)
			[self distributePutCards];
		return;
	}
	do {
		[_players selectNextIndex];
	} while ([_players.currentObject numberOfCards] <= 0);
}

- (void)putMessage:(NSString *)message ifPlayerIsHuman:(FLPlayer *)player
{
	if ([player class] != [FLPlayer class])
		return;
	[reasonHit setStringValue:message];
}

- (void)flashPlayer:(FLPlayer *)aPlayer
{
	NSUInteger idx = [_players indexOfObject:aPlayer];
	assert(idx != NSNotFound);
	[[[viewWithPlayers subviews] objectAtIndex:idx] flash];
}

/* ********************** Game methods ********************** */
- (BOOL)checkIfOnePlayerWon
{
	FLPlayer *winner = [self whoIsTheOnlyOneToHaveCards];
	if (! winner)
		return NO;
	if ([winner class] == [FLPlayer class]) {
		NSAlert *alert = [NSAlert new];
		alert.messageText = NSLocalizedString(@"bravo", nil);
		alert.informativeText = [NSString stringWithFormat:NSLocalizedString(@"endMatch", nil), winner.playerName];
		[alert addButtonWithTitle:NSLocalizedString(@"ok", nil)];
		[alert runModal];
	} else {
		NSAlert *alert = [NSAlert new];
		alert.messageText = NSLocalizedString(@"dommage", nil);
		alert.informativeText = [NSString stringWithFormat:NSLocalizedString(@"improve", nil), winner.playerName];
		[alert addButtonWithTitle:NSLocalizedString(@"ok", nil)];
		[alert runModal];
	}
	[self invalidateTimersOfPlayers];
	gameIsFinish = YES;
	[self close];
	return YES;
}

- (void)determineFirstPlayer
{
	_players.currentIndex = (random() % _players.count);
}

- (void)distributeCards
{
	cardValue sawValues[NUMBER_OF_CARDS], randomNumber;
	NSUInteger cardPut = 0, nPlayers = _players.count, i;
	
	if (NUMBER_OF_CARDS > _packet.count) {
		NSLog(@"*** In distributeCards of FLGameController, NUMBER_OF_CARDS > [packet count]");
		NSLog(@"so, I must stop the game ***");
		NSAlert *alert = [NSAlert new];
		alert.messageText = NSLocalizedString(@"error", nil);
		alert.informativeText = NSLocalizedString(@"errWhenDistributeCards", nil);
		[alert addButtonWithTitle:NSLocalizedString(@"ok", nil)];
		[alert runModal];
		[NSException raise:@"Can't distribute cards"
						format:@"NUMBER_OF_CARDS > [packet count] (%d > %lu)",
																 NUMBER_OF_CARDS, (unsigned long)_packet.count];
	}
	
	for (i = 0 ; i<NUMBER_OF_CARDS ; i++)
		sawValues[i] = 0;
	
	[self removePacketOfAllPlayers];
	while (cardPut < NUMBER_OF_CARDS) {
		randomNumber = random() % NUMBER_OF_CARDS;
		assert(randomNumber < NUMBER_OF_CARDS);
		
		if (! [self isInt:randomNumber+1 inArray:sawValues sizeOfArray:NUMBER_OF_CARDS]) {
			FLPlayer *actualPlayer = [_players objectAtIndex:(cardPut % nPlayers)];
			[actualPlayer addCard:[_packet objectAtIndex:randomNumber]];
			
			sawValues[cardPut] = randomNumber+1; /* +1 : Pour que 0 ne puisse pas y être
															  * (le tableau a été initialisé à 0) */
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

/* ********************** Delegate de FLPlayer ********************** */
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
		/* Informe le joueur actif qu'il n'a plus de cartes */
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"noCards", nil),
																					[aPlayer playerName]]
															ifPlayerIsHuman:aPlayer];
	}
	if ([game isNecessaryToChangePlayerWithCard:[cardView lastCard]]) {
		playerWhoPutTheLastSpecialCard = aPlayer;
		nbrCardsToAdd = [game numberOfCardsToAddWithCard:[cardView lastCard]];
		[self selectNextValidPlayer];
		/* Indique au joueur actif qu'il doit poser nbrCardsToAdd cartes */
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"mustPutNCards", nil),
																[_players.currentObject playerName], nbrCardsToAdd]
							ifPlayerIsHuman:_players.currentObject];
	} else if (nbrCardsToAdd == 0 && ! mustHit) {
		someOneWillGetPutCards = YES;
		[playerWhoPutTheLastSpecialCard getAllPutCardsAfter:
			[playerWhoPutTheLastSpecialCard tempsReaction]/1000.];
		return;
	} else if (nbrCardsToAdd < 0) {
		nbrCardsToAdd = 0;
		[self selectNextValidPlayer];
	}
	if ([_players.currentObject numberOfCards] <= 0) {
		/* Informe le joueur actif qu'il n'a plus de cartes */
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"noCards", nil),
																		[_players.currentObject playerName]]
										ifPlayerIsHuman:_players.currentObject];
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
		/* Informe le joueur qu'il a récupéré toutes les cartes grâce à son réflexe
		 * et dit pourquoi il a tapé (surtout pour les autres) */
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"getCardsReflex", nil),
																		[aPlayer playerName], [game lastReasonForHit]]
													ifPlayerIsHuman:aPlayer];
	}
	
	[self refreshMustHit];
	if ([_players.currentObject numberOfCards] <= 0) {
		/* Informe le joueur actif qu'il n'a plus de cartes */
		[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"noCards", nil),
																		[_players.currentObject playerName]]
										ifPlayerIsHuman:_players.currentObject];
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
	/* Informe le joueur aPlayer qu'il a perdu des cartes pour avoir tapé sans raison valable */
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
	[_players setCurrentObject:aPlayer];
	[self refreshPlayersView];
	if ([self checkIfOnePlayerWon])
		return;
	
	[reasonHit setStringValue:[game lastReasonForHit]];
	/* Informe le joueur qu'il a récupéré toutes les cartes. */
	[self putMessage:[NSString stringWithFormat:NSLocalizedString(@"getCards", nil),
																						[aPlayer playerName]]
											ifPlayerIsHuman:aPlayer];
	/* Fais clignoter le joueur qui a recupere toute les cartes
	 * pour une information visuelle efficace */
	[self flashPlayer:aPlayer];
	
	nbrCardsToAdd = 0;
	someOneWillGetPutCards = NO;
	if ([aPlayer numberOfCards] <= 0) {
		/* Informe le joueur actif qu'il n'a plus de cartes */
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
	return _players;
}

- (FLCardView *)cardView
{
	return cardView;
}

/* ********************** Interception des événements clavier ********************** */
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
			[_players.currentObject putOneCard];
		}
		return;
	}
	
	for (i = 0 ; i<_players.count ; i++) {
		currentPlayer = [_players objectAtIndex:i];
		if ([input isEqualToString:currentPlayer.hitKey]) {
			[currentPlayer hit];
			return;
		}
	}
	
	NSBeep();
}

/* Pour demander si on veut vraiment arrêter de jouer quand on ferme la fenêtre */
- (BOOL)windowShouldClose:(id)sender
{
	if (gameIsFinish)
		return YES;
	
	NSAlert *alert = [NSAlert new];
	alert.messageText = NSLocalizedString(@"sureQuit", nil);
	alert.informativeText = NSLocalizedString(@"ifYouQuit", nil);
	[alert addButtonWithTitle:NSLocalizedString(@"yes", nil)];
	[alert addButtonWithTitle:NSLocalizedString(@"no", nil)];
	NSModalResponse choice = [alert runModal];
	if (-ABS(choice) /* WHY? runModal returns 1000 when ok, NSModalResponseStop = -1000 */ == NSModalResponseStop) {
		gameIsFinish = YES;
		return YES;
	}
	
	return NO;
}

/* ********************** Notification ********************** */
- (void)refreshReasonForHit:(NSNotification *)n
{
	[reasonHit setHidden:(! [[NSUserDefaults standardUserDefaults] boolForKey:FLBeginner])];
}

/* ********************** Méthodes d'action ********************** */
/* Comme son nom ne l'indique pas, le bouton qui appelle cette méthode est faite pour poser une carte ! */
- (IBAction)buttonHitClicked:(id)sender
{
	[sender setState:1];
	[_players.currentObject putOneCard];
}

/* *********************** Methods for the others ********************** */
- (void)dealloc
{
#ifndef NDEBUG
	NSLog(@"Deallocing %@...", self);
#endif
	[NSNotificationCenter.defaultCenter removeObserver:self];
	[self invalidateTimersOfPlayers];
}

@end
