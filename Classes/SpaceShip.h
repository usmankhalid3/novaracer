//
//  SpaceShip.h
//  NovaRacer
//
//  Created by Usman Khalid on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
//#import "Math.h"


@interface SpaceShip : GameObject {
	CGPoint currentVelocity;
	float dampingPercentage;
	float currentRotation;
	BOOL collided;
	int flagsScored;
	BOOL capturedFlag;
}

@property(nonatomic, readwrite) CGPoint currentVelocity;
@property(nonatomic, readwrite) float dampingPercentage;
@property(nonatomic, readwrite) float currentRotation;
@property(nonatomic, readwrite) BOOL collided;
@property(nonatomic, readwrite) int flagsScored;
@property(nonatomic, readwrite) BOOL capturedFlag;

-(void) accelerateShipBy:(float) force;
-(CGPoint) calculateNewPosition:(CGPoint)point angleInRadians:(float)angle;
-(float) speed;
-(void) haultShip;
-(void) moveShipForward;
-(void) moveShipBackward;
-(void) captureFlag;

@end
