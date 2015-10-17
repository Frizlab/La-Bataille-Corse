#import "FLCustomWindow.h"

@implementation FLCustomWindow

- (id)initWithContentRect:(NSRect)contentRect
					 styleMask:(NSUInteger)aStyle
						backing:(NSBackingStoreType)bufferingType
						  defer:(BOOL)flag
{
	// Change the style mask to NSBorderlessWindowMask. So, the window will not have title-bar.
	FLCustomWindow* result = [super initWithContentRect:contentRect
															styleMask:NSBorderlessWindowMask
															  backing:bufferingType
																 defer:NO];
	// Efface le fond par défaut d'une fenêtre
	[result setBackgroundColor:[NSColor clearColor]];
	// Mais, on est obligé de rendre la fenêtre non opaque pour pas qu'elle s'affiche en noir
	[result setOpaque:NO];
	// Pour mettre la fenetre devant toute les autres fenetres, même celles des autres applis
//	[result setLevel:NSStatusWindowLevel];
	// Pour remettre l'ombre de la fenêtre, ce qui est automatiquement enlevé pour ce type de fenêtre
	[result setHasShadow:YES];
	
	return result;
}

// Autorise la fenêtre à reçevoir les évenement clavier
- (BOOL)canBecomeKeyWindow
{
	return YES;
}

- (void)close
{
//	NSLog(@"close window %@", self);
	[super close];
}

@end
