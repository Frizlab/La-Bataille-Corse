/* FLGameController */

#import <Cocoa/Cocoa.h>
#import "FLCycleArray.h"
#import "NotificationsNames.h"
#import "FLNSMutableArray.h"
#import "FLPlayerView.h"
#import "NamesPrefs.h"
#import "FLCardView.h"
#import "FLPlayer.h"
#import "FLCard.h"
#import "FLGame.h"

@interface FLGameController : NSWindowController {
    IBOutlet FLCardView *cardView;
	 IBOutlet FLPlayerView *playerView;
    IBOutlet NSTextField *reasonHit;
	 IBOutlet NSView *viewWithPlayers;
	 
	 BOOL mustHit, someOneWillGetPutCards, gameIsFinish;
	 FLPlayer *playerWhoPutTheLastSpecialCard;
	 signed int nbrCardsToAdd;
	 FLCycleArray *players;
	 NSArray *packet;
    FLGame *game;
}

// M�thodes d'initialisations //
- (id)initWithPacket:(NSArray *)newPacket;
- (id)initWithPacket:(NSArray *)newPacket andPlayers:(NSArray *)newPlayers;

// Utils //
- (BOOL)isInt:(unsigned int)numb inArray:(unsigned int *)array sizeOfArray:(unsigned int)size;
- (void)showPlayersInScreen;
- (void)refreshPlayersView;
- (void)removePacketOfAllPlayers;
- (void)initPlayers;
- (void)invalidateTimersOfPlayers;
- (void)invalidateHitTimerOfComputersPlayer;
- (void)currentPlayerPutACardIfItIsAComputerPlayer;
- (void)computerPlayersHit;
- (void)refreshMustHit;
- (FLPlayer *)whoIsTheOnlyOneToHaveCards;
- (BOOL)allPlayersHaveNoCards;
- (void)distributePutCards;
- (void)selectNextValidPlayer;
- (void)putMessage:(NSString *)message ifPlayerIsHuman:(FLPlayer *)player;
- (void)flashPlayer:(FLPlayer *)aPlayer;

// Game methods //
- (BOOL)checkIfOnePlayerWon;
- (void)determineFirstPlayer;
- (void)distributeCards;
- (void)beginToPlay;

// Delegate de FLPlayer //
- (BOOL)player:(FLPlayer *)aPlayer willPutTheCard:(FLCard *)theCard;
- (void)player:(FLPlayer *)aPlayer didPutTheCard:(FLCard *)theCard;
- (BOOL)playerWillHit:(FLPlayer *)aPlayer;
- (void)playerDidHit:(FLPlayer *)aPlayer;
- (void)player:(FLPlayer *)aPlayer willPutCitation:(NSArray *)cards;
- (void)player:(FLPlayer *)aPlayer didPutCitation:(NSArray *)cards;
- (void)playerWillGetAllPutCards:(FLPlayer *)aPlayer;
- (void)playerDidGetAllPutCards:(FLPlayer *)aPlayer;
- (FLCycleArray *)arrayOfPlayers;
- (FLCardView *)cardView;

// Interception des �v�nements //
// �v�nement clavier
#ifndef NSPECIALKEY
- (void)flagsChanged:(NSEvent *)e;
#endif
- (void)keyDown:(NSEvent *)event;

// Pour demander si on veut vraiment arr�ter de jouer quand on ferme la fen�tre
- (BOOL)windowShouldClose:(id)sender;

// Notification //
- (void)refreshReasonForHit:(NSNotification *)n;

// M�thodes d'acc�s //
- (NSArray *)packet;
- (void)setPacket:(NSArray *)newPacket;
- (FLCycleArray *)players;
- (void)setPlayers:(FLCycleArray *)newPlayers;

// M�thodes d'action //
// Comme son nom ne l'indique pas, le bouton qui appelle cette m�thode est fait pour poser une carte !
- (IBAction)buttonHitClicked:(id)sender;

@end
