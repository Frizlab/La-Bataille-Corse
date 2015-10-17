#import "AppController.h"

@implementation AppController

+ (void)initialize
{
	// Cr�e un dictionnaire
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:FLShowLoadWindow];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:FLBeginner];
	[defaultValues setObject:[NSNumber numberWithBool:YES] forKey:FLDoubles];
	[defaultValues setObject:[NSNumber numberWithInt:0]    forKey:FLDoublesValue];
	[defaultValues setObject:[NSNumber numberWithBool:NO]  forKey:FLDix];
	[defaultValues setObject:[NSNumber numberWithInt:0]    forKey:FLDixValue];
	[defaultValues setObject:[NSNumber numberWithBool:NO]  forKey:FLDebutFin];
	[defaultValues setObject:[NSNumber numberWithBool:NO]  forKey:FLDebutFinDix];
	[defaultValues setObject:[NSNumber numberWithInt:50]   forKey:FLTempsReactionOrdiMin];
	[defaultValues setObject:[NSNumber numberWithInt:50]   forKey:FLTempsReactionOrdiMax];
	[defaultValues setObject:[NSNumber numberWithInt:1]    forKey:FLNbrCardsAmende];
	
	[defaultValues setObject:[NSNumber numberWithInt:FLDifficultyNormal] forKey:FLLevelDifficulty];
	
	[defaultValues setObject:[NSArchiver archivedDataWithRootObject:
		[NSMutableArray arrayWithObject:[[FLPlayer alloc] init]]]
							forKey:FLNamesOfPlayers];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:FLCurrentPlayer];
	[defaultValues setObject:[NSNumber numberWithInt:1] forKey:FLNumberOfComputerPlayers];
	// Enregistre le dictionnaire de defaults
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (id)init
{
	NSNotificationCenter *nc;
	if ((self = [super init]) != nil) {
		nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(preferences:)   name:FLShowPrefs     object:nil];
		[nc addObserver:self selector:@selector(beginGame:)     name:FLBeginGame     object:nil];
		[nc addObserver:self selector:@selector(calibrateTime:) name:FLCalibrateTime object:nil];
	}
	return self;
}

////////// Appel� quand l'application � fini de se charger //////////
- (void)applicationWillFinishLaunching:(NSNotification *)n
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL showLoadWindow = [[defaults valueForKey:FLShowLoadWindow] boolValue];
	if (showLoadWindow) {
		[loadWindow center];
		[loadWindow setAlphaValue:0.85];
		[loadWindow makeKeyAndOrderFront:nil];
	}
	
	cards = [loadObject initApp:showLoadWindow];
	[loadWindow close];
	[self newGame:nil];
}

////////// Appel� pour savoir si l'application doit quitter //////////
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
#ifndef NDEBUG
	return NSTerminateNow;
#endif
	if ((gameController && ! [gameController windowShouldClose:nil]) ||
		 (timeCalibrater && ! [timeCalibrater windowShouldClose:nil]))
		return NSTerminateCancel;
	else
		return NSTerminateNow;
}

////////// Appel� quand l'application va quitter //////////
- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[self release];
}

////////// Action methods //////////
// Notification et action
- (void)preferences:(id)sender
{
	if (! prefsController)
		prefsController = [[FLPreferencesController alloc] init];
	[prefsController showWindow:self];
}

- (void)newGame:(id)sender
{
	if (gameController && ! [gameController windowShouldClose:nil])
		return;
	[gameController close];
	[gameController release];
	gameController = nil;
	
	if (! newGameController) {
		newGameController = [[FLNewGameController alloc] init];
	}
	[newGameController showWindow:self];
}

// Notification
- (void)beginGame:(NSNotification *)n
{
	if ((gameController && ! [gameController windowShouldClose:nil]) ||
		 (timeCalibrater && ! [timeCalibrater windowShouldClose:nil]))
		return;
	[newGameController close];
	
	[timeCalibrater close];
	[timeCalibrater release];
	timeCalibrater = nil;
	
	[gameController close];
	[gameController release];
	gameController = [[FLGameController alloc] initWithPacket:cards andPlayers:[n object]];
	[gameController showWindow:self];
}

- (void)calibrateTime:(NSNotification *)n
{
	if ((gameController && ! [gameController windowShouldClose:nil]) ||
		 (timeCalibrater && ! [timeCalibrater windowShouldClose:nil]))
		return;
	[gameController close];
	[gameController release];
	gameController = nil;
	
	[timeCalibrater close];
	[timeCalibrater release];
	timeCalibrater = [[FLCalibrateTimeController alloc] initWithPacket:cards andPlayer:[n object]];
	[timeCalibrater showWindow:self];
}

- (void)dealloc
{
#ifndef NDEBUG	
	NSLog(@"Deallocing %@...", self);
#endif
	NSNotificationCenter *nc;
	nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	[newGameController release];
	[prefsController release];
	[gameController release];
	[cards release];
	[super dealloc];
}

@end
