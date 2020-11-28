#import "FLNewGameController.h"

@implementation FLNewGameController

- (id)init
{
	NSNotificationCenter *nc;
	if ((self = [super initWithWindowNibName:@"NewGame"]) != nil) {
		[self setShouldCascadeWindows:NO];
		[self setWindowFrameAutosaveName:@"FLNewGameWindow"];
		players = [[NSUnarchiver unarchiveObjectWithData:
			[[NSUserDefaults standardUserDefaults] valueForKey:FLNamesOfPlayers]] retain];
		
		nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(refreshPLayer:) name:FLChangeTimeOfOnePlayer object:nil];
	}
	
	return self;
}

- (void)windowDidLoad
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[tableViewListOfPlayersView reloadData];
	[tableViewListOfPlayersView selectRowIndexes:[NSIndexSet indexSetWithIndex:[defaults integerForKey:FLCurrentPlayer]]
									byExtendingSelection:NO];
	
	[nbrComputerPlayers setIntegerValue:[defaults integerForKey:FLNumberOfComputerPlayers]];
	[self refreshButtonOk:nil];
	[self refreshButtonSupp];
}

- (IBAction)calibrateTempsReactionPlayer:(id)sender
{
	if ([self isHitKeyColumnEdited]) {
		NSBeep();
		return;
	}
	FLPlayer *currentPlayer = [players objectAtIndex:[tableViewListOfPlayersView selectedRow]];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:FLCalibrateTime object:currentPlayer];
}

- (IBAction)cancel:(id)sender
{
	[self close];
}

- (IBAction)addPlayer:(id)sender
{
	if ([self isHitKeyColumnEdited]) {
		NSBeep();
		return;
	}
	FLPlayer *newPlayer = [[FLPlayer alloc] init];
	[players addObject:newPlayer];
	[newPlayer release];
	
	[tableViewListOfPlayersView reloadData];
	
	[self editKeyOfRow:([players count] - 1)];
	
	[self refreshButtonSupp];
	[self refreshButtonOk:nil];
	[self saveArray];
}

- (IBAction)deletePlayer:(id)sender
{
	if ([self isHitKeyColumnEdited]) {
		NSBeep();
		return;
	}
	NSInteger row = [tableViewListOfPlayersView selectedRow];
	[players removeObjectAtIndex:row];
	
	[tableViewListOfPlayersView reloadData];
	[self refreshButtonSupp];
	[self refreshButtonOk:nil];
	[self saveArray];
}

- (IBAction)ok:(id)sender
{
	if ([self isHitKeyColumnEdited] || ! [self isCorrectNumberOfPlayersSelectedForPlay]) {
		NSBeep();
		return;
	}
	unsigned int i;
	FLPlayer *currentPlayer;
	NSMutableArray *playersWillPlay = [[NSMutableArray new] autorelease];
	
	for (i = 0 ; i<[players count] ; i++) {
		currentPlayer = [players objectAtIndex:i];
		if ([currentPlayer willPlay])
			[playersWillPlay addObject:currentPlayer];
	}
	for (i = 1 ; i<=(unsigned)[nbrComputerPlayers intValue] ; i++)
		[playersWillPlay addObject:[[FLComputerPlayer new] autorelease]];
	
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:FLBeginGame object:[playersWillPlay copy]];
}

- (IBAction)prefs:(id)sender
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:FLShowPrefs object:nil];
}

// FLFL : si jamais on sait comment rafraichir players depuis le tableau, on peut remettre
// le setEnabled de buttonOk
- (IBAction)refreshButtonOk:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:[nbrComputerPlayers intValue]
															 forKey:FLNumberOfComputerPlayers];
//	[buttonOk setEnabled:[self isCorrectNumberOfPlayersSelectedForPlay]];
}

//////////////////////// dataSource du tableau ////////////////////////
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [players count];
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
				row:(int)rowIndex
{
	NSString *identifier = [aTableColumn identifier];
	FLPlayer *player = [players objectAtIndex:rowIndex];
	
	id value = [player valueForKey:identifier];
	// Permet d'afficher Return au lieu d'un \r interprŽtŽ, Tabulation au lieu d'un \t interprŽtŽ...
	if ([identifier isEqualToString:@"hitKey"])
		return [value nameForKey];
	
	return value;
}

- (void)tableView:(NSTableView *)aTableView
	setObjectValue:(id)anObject
	forTableColumn:(NSTableColumn *)aTableColumn
				  row:(int)rowIndex
{
	NSString *identifier = [aTableColumn identifier];
	FLPlayer *player = [players objectAtIndex:rowIndex];
	[player setValue:anObject forKey:identifier];
	
	[self saveArray];
}

//////////////////////// Delegate du tableau ////////////////////////
- (void)tableViewSelectionDidChange:(NSNotification *)n
{
	[[NSUserDefaults standardUserDefaults] setInteger:[tableViewListOfPlayersView selectedRow]
															 forKey:FLCurrentPlayer];
}

- (BOOL)tableView:(NSTableView *)aTableView
shouldEditTableColumn:(NSTableColumn *)aTableColumn
				  row:(int)rowIndex
{
	[textViewController setCurrentRowIdentifier:[aTableColumn identifier]];
	return YES;
}

//////////////////////// Delegate du control du tableau ////////////////////////
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	if ([self isHitKeyColumnEdited])
		return [self isValidKey:[fieldEditor string]
						  forPlayer:[players objectAtIndex:[tableViewListOfPlayersView editedRow]]];
	return YES;
}

//////////////////////// Utils ////////////////////////
- (BOOL)isCorrectNumberOfPlayersSelectedForPlay
{
	unsigned int i, nbrWillPlay = 0;
	[tableViewListOfPlayersView reloadData];
	for (i = 0 ; i<[players count] ; i++)
		if ([[players objectAtIndex:i] willPlay])
			nbrWillPlay++;
	
	nbrWillPlay += [nbrComputerPlayers intValue];
	return ((1 < nbrWillPlay) && (nbrWillPlay <= 54));
}

- (BOOL)isHitKeyColumnEdited
{
	return ([tableViewListOfPlayersView editedColumn] ==
			  [tableViewListOfPlayersView columnWithIdentifier:@"hitKey"]);
}

- (BOOL)isValidKey:(NSString *)key forPlayer:(FLPlayer *)p
{
	unsigned int i;
	FLPlayer *currentPlayer;
	if ([key isEqualToString:@" "] || [key isEqualToString:@"\e"] || [key length] != 1)
		return NO;
	
	for (i = 0 ; i<[players count] ; i++) {
		currentPlayer = [players objectAtIndex:i];
		if ((! [currentPlayer isEqual:p]) && ([[currentPlayer hitKey] isEqualToString:key]))
			return NO;
	}
	return YES;
}

- (void)editKeyOfRow:(NSUInteger)row
{
	[textViewController setCurrentRowIdentifier:@"hitKey"];
	[tableViewListOfPlayersView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
	[tableViewListOfPlayersView editColumn:[tableViewListOfPlayersView columnWithIdentifier:@"hitKey"]
												  row:row
										  withEvent:nil
											  select:YES];
	[[tableViewListOfPlayersView window] makeFirstResponder:[textViewController textView]];
}

- (void)refreshPLayer:(NSNotification *)n
{
	[tableViewListOfPlayersView reloadData];
	[self saveArray];
}

- (void)refreshButtonSupp
{
	[buttonSupp setEnabled:([players count] > 0)];
}

- (void)saveArray
{
	[[NSUserDefaults standardUserDefaults] setObject:[NSArchiver archivedDataWithRootObject:players]
															forKey:FLNamesOfPlayers];
}

- (void)dealloc
{
#ifndef NDEBUG
	NSLog(@"Deallocing %@", self);
#endif
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	[players release];
	[super dealloc];
}

@end
