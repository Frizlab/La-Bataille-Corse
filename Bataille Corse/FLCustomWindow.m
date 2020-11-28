#import "FLCustomWindow.h"

@implementation FLCustomWindow

- (id)initWithContentRect:(NSRect)contentRect
					 styleMask:(NSWindowStyleMask)aStyle
						backing:(NSBackingStoreType)bufferingType
						  defer:(BOOL)flag
{
	// Change the style mask to NSBorderlessWindowMask. So, the window will not have title-bar.
	FLCustomWindow* result = [super initWithContentRect:contentRect
															styleMask:NSWindowStyleMaskBorderless
															  backing:bufferingType
																 defer:NO];
	// Efface le fond par dÈfaut d'une fenÍtre
	[result setBackgroundColor:[NSColor clearColor]];
	// Mais, on est obligÈ de rendre la fenÍtre non opaque pour pas qu'elle s'affiche en noir
	[result setOpaque:NO];
	// Pour mettre la fenetre devant toute les autres fenetres, mÍme celles des autres applis
//	[result setLevel:NSStatusWindowLevel];
	// Pour remettre l'ombre de la fenÍtre, ce qui est automatiquement enlevÈ pour ce type de fenÍtre
	[result setHasShadow:YES];
	
	return result;
}

// Autorise la fenÍtre ‡ reÁevoir les Èvenement clavier
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
