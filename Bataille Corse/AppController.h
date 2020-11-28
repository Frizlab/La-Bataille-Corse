/* AppController */

#import <Cocoa/Cocoa.h>
#import "FLCalibrateTimeController.h"
#import "FLPreferencesController.h"
#import "FLNewGameController.h"
#import "NotificationsNames.h"
#import "FLComputerPlayer.h"
#import "FLGameController.h"
#import "FLCustomWindow.h"
#import "Constants.h"
#import "AppInit.h"

@interface AppController : NSObject {
	IBOutlet FLCustomWindow *loadWindow;
	IBOutlet AppInit *loadObject;
	FLCalibrateTimeController *timeCalibrater;
	FLPreferencesController *prefsController;
	FLNewGameController *newGameController;
	FLGameController *gameController;
	NSArray *cards;
}

/// Appelé quand l'application a fini de se charger ///
- (void)applicationWillFinishLaunching:(NSNotification *)n;

/// Appelé pour savoir si l'application doit quitter ///
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender;

/// Appelé quand l'application va quitter ///
- (void)applicationWillTerminate:(NSNotification *)aNotification;

/// Action methods ///
// Notification et action
- (void)preferences:(id)sender;
- (void)newGame:(id)sender;

// Notification
- (void)beginGame:(NSNotification *)n;

@end
