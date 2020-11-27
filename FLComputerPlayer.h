//
//  FLComputerPlayer.h
//  Bataille corse
//
//  Created by François on 21/01/05.
//  Copyright 2005 __MyCompanyName__. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h> // Just for have "float SSRandomFloatBetween(float a, float b);"
#import <Cocoa/Cocoa.h>
#import <math.h>
#import "FLCycleArray.h"
#import "Constants.h"
#import "FLPlayer.h"

typedef struct minMax {
	float min;
	float max;
} minMax;

@interface FLComputerPlayer : FLPlayer {
	NSTimer *hitTimer;
	
	minMax minAndMaxOfOtherReactionTime;
	float ecartTypeOfOtherReactionTime;
	float averageOfOtherReactionTime;
}

- (void)computeAverage:(float *)averageVar
				 ecartType:(float *)ecartTypeVar
				 andMinMax:(minMax *)minMaxVar
  ofOtherReactionTimes:(FLCycleArray *)players;
- (void)hitBySelf:(NSTimer *)t;
- (void)hitAfter:(float)seconds;
- (float)normalDistributionWithMean:(float)mean andVariance:(float)variance;
- (void)invalidateHitTimer;
- (void)invalidateAllMyTimers;

@end
