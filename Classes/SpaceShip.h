//
//  SpaceShip.h
//  NovaRacer
//
//  Created by adeel on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"
//#import "Math.h"


@interface SpaceShip : GameObject {
	CGPoint currentVelocity;
	float dampingPercentage;
	float currentRotation;
}

@property(nonatomic, readwrite) CGPoint currentVelocity;
@property(nonatomic, readwrite) float dampingPercentage;
@property(nonatomic, readwrite) float currentRotation;

-(void) accelerateShipBy:(float) force;
-(CGPoint) calculateNewPosition:(CGPoint)point angleInRadians:(float)angle;
-(float)speed;

@end
