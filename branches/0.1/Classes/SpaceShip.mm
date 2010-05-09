//
//  SpaceShip.m
//  NovaRacer
//
//  Created by adeel on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpaceShip.h"


@implementation SpaceShip
@synthesize currentVelocity, dampingPercentage, currentRotation, collided, flagsScored, capturedFlag;

-(void) accelerateShipBy:(float) force {
	currentVelocity.x = (currentVelocity.x + (force * cos(CC_DEGREES_TO_RADIANS(currentRotation+90.0f))))*(1.0f - dampingPercentage);
	currentVelocity.y = (currentVelocity.y + (force * sin(CC_DEGREES_TO_RADIANS(currentRotation+90.0f))))*(1.0f - dampingPercentage);
	if (collided == YES) {
		worldPosition.x = worldPosition.x - currentVelocity.x;
		worldPosition.y = worldPosition.y - currentVelocity.y;
	}
	else {
		worldPosition.x = worldPosition.x + currentVelocity.x;
		worldPosition.y = worldPosition.y + currentVelocity.y;
	}
	if (collided == YES && [self speed] <= 0.05f) {
		collided = NO;
		[self haultShip];
	}
}

-(void) haultShip {
	currentVelocity.x = 0;
	currentVelocity.y = 0;
}

-(void) captureFlag {
	flagsScored += 1;
	capturedFlag = YES;
}

-(CGPoint) calculateNewPosition:(CGPoint) point angleInRadians:(float)angle {
	float x = (point.x * cos(angle)) - (point.y * sin(angle));
	float y = (point.x * sin(angle)) + (point.y * cos(angle));
	return CGPointMake(x, y);
}

-(void) setCurrentRotation:(float)newAngle {
	currentRotation = (float)((int)newAngle % 360);
}

-(float) speed {
	return sqrt(currentVelocity.x * currentVelocity.x + currentVelocity.y * currentVelocity.y);
}

@end
