#import "FLPreferencesController.h"

@implementation FLPreferencesController

- (id)init
{
	if ((self = [super initWithWindowNibName:@"Preferences"]) != nil)
		[self setWindowFrameAutosaveName:@"FLPrefsWindow"];
	return self;
}

- (void)windowDidLoad
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[checkButtonBeginner           setState:[[defaults valueForKey:FLBeginner]                intValue]];
	[checkButtonShowLoadWindow     setState:[[defaults valueForKey:FLShowLoadWindow]          intValue]];
	[checkButtonDix                setState:[[defaults valueForKey:FLDix]                     intValue]];
	[textFieldNbrCartesDix         setIntValue:[[defaults valueForKey:FLDixValue]             intValue]];
	[checkButtonDoubles            setState:[[defaults valueForKey:FLDoubles]                 intValue]];
	[textFieldNbrCartesDoubles     setIntValue:[[defaults valueForKey:FLDoublesValue]         intValue]];
	[checkButtonStartEnd           setState:[[defaults valueForKey:FLDebutFin]                intValue]]; 
	[checkButtonStartEndDix        setState:[[defaults valueForKey:FLDebutFinDix]             intValue]];
	[textFieldTempsReactionOrdiMax setIntValue:[[defaults valueForKey:FLTempsReactionOrdiMax] intValue]];
	[textFieldTempsReactionOrdiMin setIntValue:[[defaults valueForKey:FLTempsReactionOrdiMin] intValue]];
	[textFieldNbrCartesAmende      setIntValue:[[defaults valueForKey:FLNbrCardsAmende]       intValue]];
	[checkButtonPossibleToForcePutCard setIntValue:
		[[defaults valueForKey:FLPossibleToForcePutCard] intValue]];
	
	[popUpButtonMenu selectItem:
		[popUpButtonMenu itemAtIndex:
			[[defaults valueForKey:
				FLLevelDifficulty] intValue]]];
}

- (IBAction)changeBeginner:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:[sender state] forKey:FLBeginner];
	// Sent notification for refresh in real time
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:FLRefreshBeginner object:nil];
}

- (IBAction)changeDebutFin:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:[sender state] forKey:FLDebutFin];
}

- (IBAction)changeDebutFinDix:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:[sender state] forKey:FLDebutFinDix];
}

- (IBAction)changeDix:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:[sender state] forKey:FLDix];
}

- (IBAction)changeDoubles:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:[sender state] forKey:FLDoubles];
}

- (IBAction)changeLevelDifficulty:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:[popUpButtonMenu selectedTag] forKey:FLLevelDifficulty];
}

- (IBAction)changeNbrCardsAmende:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:[sender intValue] forKey:FLNbrCardsAmende];
}

- (IBAction)changeNbrCardsDix:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:[sender intValue] forKey:FLDixValue];
}

- (IBAction)changeNbrCardsDoubles:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:[sender intValue] forKey:FLDoublesValue];
}

- (IBAction)changePossibleToForcePutCard:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:[sender state] forKey:FLPossibleToForcePutCard];
}

- (IBAction)changeShowLoadWindow:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setBool:[sender state] forKey:FLShowLoadWindow];
}

- (IBAction)changeTempsReactionOrdiMax:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:[sender intValue] forKey:FLTempsReactionOrdiMax];
}

- (IBAction)changeTempsReactionOrdiMin:(id)sender
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:[sender intValue] forKey:FLTempsReactionOrdiMin];
}

@end
