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
	// Efface le fond par d�faut d'une fen�tre
	[result setBackgroundColor:[NSColor clearColor]];
	// Mais, on est oblig� de rendre la fen�tre non opaque pour pas qu'elle s'affiche en noir
	[result setOpaque:NO];
	// Pour mettre la fenetre devant toute les autres fenetres, m�me celles des autres applis
//	[result setLevel:NSStatusWindowLevel];
	// Pour remettre l'ombre de la fen�tre, ce qui est automatiquement enlev� pour ce type de fen�tre
	[result setHasShadow:YES];
	
	return result;
}

// Autorise la fen�tre � re�evoir les �venement clavier
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
