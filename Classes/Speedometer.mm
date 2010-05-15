//
//  Speedometer.m
//  NovaRacer
//
//  Created by adeel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Speedometer.h"


@implementation Speedometer

@synthesize needle;

-(id) init {
	
	if ((self = [super init])) {
		speedometer = [CCSprite spriteWithFile:@"speedometer.png"];
		speedometer.position = ccp(20, 10);
		speedometer.anchorPoint = ccp(0, 0);
		speedometer.scale = 0.8;
		[self addChild:speedometer];
		
		needle = [CCSprite spriteWithFile:@"needle.png"];
		needle.position = ccp(63, 51);
		needle.anchorPoint = ccp(0, 0);
		needle.scale = 0.20f;
		[self addChild:needle];
		
		[needle runAction:[CCSequence actions: [CCRotateTo actionWithDuration:0.9f angle:-130.0f], nil]];
		
		needleAngle = -130.0f;
	
	}
	return self;
}


-(void) displaySpeed:(float)currentSpeed accelerateShip:(BOOL)accelerateShip {
	if (accelerateShip==YES && needleAngle < 110) {
		needleAngle = needleAngle + ((currentSpeed / 1300.0f) * 180.0f);
	}
	else if (accelerateShip==NO && needleAngle > -130) {
		needleAngle = needleAngle - ((currentSpeed / 1050.0f) * 180.0f);
	}
	[needle setRotation:needleAngle];
}

@end
