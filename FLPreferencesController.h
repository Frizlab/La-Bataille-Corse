/* FLPreferencesController */

#import <Cocoa/Cocoa.h>
#import "NotificationsNames.h"
#import "NamesPrefs.h"

@interface FLPreferencesController : NSWindowController {
	IBOutlet NSButton *checkButtonBeginner;
	IBOutlet NSButton *checkButtonDix;
	IBOutlet NSButton *checkButtonDoubles;
	IBOutlet NSButton *checkButtonPossibleToForcePutCard;
	IBOutlet NSButton *checkButtonShowLoadWindow;
	IBOutlet NSButton *checkButtonStartEnd;
	IBOutlet NSButton *checkButtonStartEndDix;
	IBOutlet NSPopUpButton *popUpButtonMenu;
	IBOutlet NSTextField *textFieldNbrCartesAmende;
	IBOutlet NSTextField *textFieldNbrCartesDix;
	IBOutlet NSTextField *textFieldNbrCartesDoubles;
	IBOutlet NSTextField *textFieldTempsReactionOrdiMax;
	IBOutlet NSTextField *textFieldTempsReactionOrdiMin;
}
- (IBAction)changeBeginner:(id)sender;
- (IBAction)changeDebutFin:(id)sender;
- (IBAction)changeDebutFinDix:(id)sender;
- (IBAction)changeDix:(id)sender;
- (IBAction)changeDoubles:(id)sender;
- (IBAction)changeLevelDifficulty:(id)sender;
- (IBAction)changeNbrCardsAmende:(id)sender;
- (IBAction)changeNbrCardsDix:(id)sender;
- (IBAction)changeNbrCardsDoubles:(id)sender;
- (IBAction)changePossibleToForcePutCard:(id)sender;
- (IBAction)changeShowLoadWindow:(id)sender;
- (IBAction)changeTempsReactionOrdiMax:(id)sender;
- (IBAction)changeTempsReactionOrdiMin:(id)sender;

@end
