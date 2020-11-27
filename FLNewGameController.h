/* FLNewGameController */

#import <Cocoa/Cocoa.h>
#import "FLTextViewController.h"
#import "NotificationsNames.h"
#import "FLComputerPlayer.h"
#import "NSString+Keys.h"
#import "Constants.h"
#import "FLPlayer.h"

@interface FLNewGameController : NSWindowController {
	IBOutlet NSButton *buttonOk;
	IBOutlet NSButton *buttonSupp;
	IBOutlet NSTableView *tableViewListOfPlayersView;
	IBOutlet FLTextViewController *textViewController;
	IBOutlet NSTextField *nbrComputerPlayers;
	IBOutlet NSWindow *windowHitKey;
	
	NSMutableArray *players;
}

/// Action methods ///
- (IBAction)calibrateTempsReactionPlayer:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)addPlayer:(id)sender;
- (IBAction)deletePlayer:(id)sender;
- (IBAction)ok:(id)sender;
- (IBAction)prefs:(id)sender;
- (IBAction)refreshButtonOk:(id)sender;

/// dataSource du tableau ///
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
				row:(int)rowIndex;
- (void)tableView:(NSTableView *)aTableView
	setObjectValue:(id)anObject
	forTableColumn:(NSTableColumn *)aTableColumn
				  row:(int)rowIndex;

/// Delegate du tableau ///
- (void)tableViewSelectionDidChange:(NSNotification *)n;
- (BOOL)tableView:(NSTableView *)aTableView
shouldEditTableColumn:(NSTableColumn *)aTableColumn
				  row:(int)rowIndex;
/// Delegate du control du tableau ///
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor;

/// Utils ///
- (BOOL)isCorrectNumberOfPlayersSelectedForPlay;
- (BOOL)isHitKeyColumnEdited;
- (BOOL)isValidKey:(NSString *)key forPlayer:(FLPlayer *)p;
- (void)editKeyOfRow:(NSUInteger)row;
- (void)refreshButtonSupp;
- (void)saveArray;

@end
