//
//  SpaceShip.m
//  NovaRacer
//
//  Created by Usman Khalid on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpaceShip.h"


@implementation SpaceShip
@synthesize currentVelocity, dampingPercentage, currentRotation, collided, flagsScored, capturedFlag, worldVelocity;

-(void) accelerateShipBy:(float) force {
	currentVelocity.x = (currentVelocity.x + (force * cos(CC_DEGREES_TO_RADIANS(currentRotation))))*(1.0f - dampingPercentage);
	currentVelocity.y = (currentVelocity.y + (force * sin(CC_DEGREES_TO_RADIANS(currentRotation))))*(1.0f - dampingPercentage);
	
	worldVelocity.x = (worldVelocity.x + (force * cos(CC_DEGREES_TO_RADIANS(180-currentRotation))))*(1.0f - dampingPercentage);
	worldVelocity.y = (worldVelocity.y + (force * sin(CC_DEGREES_TO_RADIANS(180-currentRotation))))*(1.0f - dampingPercentage);
	if (collided == NO) {
		[self moveShipForward];
	}
	else {
		[self moveShipBackward];
	}
	if (collided == YES && [self speed] <= 0.2f) {
		collided = NO;
		[self haultShip];
	}
}

-(void) moveShipForward {
	CGPoint point = sprite.position;
	point.x = point.x - currentVelocity.x;
	point.y = point.y - currentVelocity.y;
	[sprite setPosition:point];
	
	point = worldPosition;
	point.x = point.x - currentVelocity.x;
	point.y = point.y - currentVelocity.y;
	worldPosition = point;
}

-(void) moveShipBackward {
	CGPoint point = sprite.position;
	point.x = point.x + currentVelocity.x;
	point.y = point.y + currentVelocity.y;
	[sprite setPosition:point];
	
	point = worldPosition;
	point.x = point.x + currentVelocity.x;
	point.y = point.y + currentVelocity.y;
	worldPosition = point;
}


-(void) haultShip {
	currentVelocity.x = 0;
	currentVelocity.y = 0;
	worldVelocity.x = 0;
	worldVelocity.y = 0;
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
	currentRotation = (float)((int)(currentRotation + newAngle) % 360);
	[sprite setRotation:currentRotation*-1];
}

-(float) speed {
	return sqrt(currentVelocity.x * currentVelocity.x + currentVelocity.y * currentVelocity.y);
}
@end
