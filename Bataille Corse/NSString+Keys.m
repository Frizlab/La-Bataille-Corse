//
//  NSString+Keys.m
//  Bataille corse
//
//  Created by François on 04/04/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import "NSString+Keys.h"

@implementation NSString (NSString_Keys)

- (NSString *)nameForKey
{
	if ([self isEqualToString:@"\r"])
		return NSLocalizedString(@"return", nil);
	
	if ([self isEqualToString:@"\t"])
		return NSLocalizedString(@"tab", nil);
	
	if ([self isEqualToString:@"\e"])
		return NSLocalizedString(@"escape", nil);
	
	if ([self isEqualToString:@" "])
		return NSLocalizedString(@"space", nil);
	
	if ([self isEqualToString:@"\x7f"])
		return NSLocalizedString(@"backSpace", nil);
	
	if ([self intValue] & NSEventModifierFlagShift)
		return NSLocalizedString(@"shift", nil);
	
	if ([self intValue] & NSEventModifierFlagControl)
		return NSLocalizedString(@"control", nil);
	
	if ([self intValue] & NSEventModifierFlagOption)
		return NSLocalizedString(@"alt", nil);
	
	if ([self intValue] & NSEventModifierFlagCommand)
		return NSLocalizedString(@"cmd", nil);
	
	switch ([self characterAtIndex:0]) {
		case NSF1FunctionKey  : return @"F1"  ; break;
		case NSF2FunctionKey  : return @"F2"  ; break;
		case NSF3FunctionKey  : return @"F3"  ; break;
		case NSF4FunctionKey  : return @"F4"  ; break;
		case NSF5FunctionKey  : return @"F5"  ; break;
		case NSF6FunctionKey  : return @"F6"  ; break;
		case NSF7FunctionKey  : return @"F7"  ; break;
		case NSF8FunctionKey  : return @"F8"  ; break;
		case NSF9FunctionKey  : return @"F9"  ; break;
		case NSF10FunctionKey : return @"F10" ; break;
		case NSF11FunctionKey : return @"F11" ; break;
		case NSF12FunctionKey : return @"F12" ; break;
		case NSF13FunctionKey : return @"F13" ; break;
		case NSF14FunctionKey : return @"F14" ; break;
		case NSF15FunctionKey : return @"F15" ; break;
		case NSF16FunctionKey : return @"F16" ; break;
		case NSF17FunctionKey : return @"F17" ; break;
		case NSF18FunctionKey : return @"F18" ; break;
		case NSF19FunctionKey : return @"F19" ; break;
		case NSF20FunctionKey : return @"F20" ; break;
		case NSF21FunctionKey : return @"F21" ; break;
		case NSF22FunctionKey : return @"F22" ; break;
		case NSF23FunctionKey : return @"F23" ; break;
		case NSF24FunctionKey : return @"F24" ; break;
		case NSF25FunctionKey : return @"F25" ; break;
		case NSF26FunctionKey : return @"F26" ; break;
		case NSF27FunctionKey : return @"F27" ; break;
		case NSF28FunctionKey : return @"F28" ; break;
		case NSF29FunctionKey : return @"F29" ; break;
		case NSF30FunctionKey : return @"F30" ; break;
		case NSF31FunctionKey : return @"F31" ; break;
		case NSF32FunctionKey : return @"F32" ; break;
		case NSF33FunctionKey : return @"F33" ; break;
		case NSF34FunctionKey : return @"F34" ; break;
		case NSF35FunctionKey : return @"F35" ; break;
		case NSUpArrowFunctionKey    : return NSLocalizedString(@"arrowUp"   , nil) ; break;
		case NSDownArrowFunctionKey  : return NSLocalizedString(@"arrowDown" , nil) ; break;
		case NSLeftArrowFunctionKey  : return NSLocalizedString(@"arrowLeft" , nil) ; break;
		case NSRightArrowFunctionKey : return NSLocalizedString(@"arrowRight", nil) ; break;
		case NSEndFunctionKey        : return NSLocalizedString(@"pagEnd"    , nil) ; break;
		case NSBeginFunctionKey      : return NSLocalizedString(@"pagBegin"  , nil) ; break;
		case NSHomeFunctionKey       : return NSLocalizedString(@"pagBegin"  , nil) ; break;
		case NSPageDownFunctionKey   : return NSLocalizedString(@"pageDown"  , nil) ; break;
		case NSPageUpFunctionKey     : return NSLocalizedString(@"pageUp"    , nil) ; break;
		case NSDeleteFunctionKey     : return NSLocalizedString(@"delete"    , nil) ; break;
		case NSClearLineFunctionKey  : return NSLocalizedString(@"verNum"    , nil) ; break;
		case 3                       : return NSLocalizedString(@"numEnter"  , nil) ; break; // Pas trouvé code clair d'apple
	}
	
	// If it's no a know key or if it is not a key 
	return self;
}

@end
