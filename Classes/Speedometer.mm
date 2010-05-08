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
		speedometer = [CCSprite spriteWithFile:@"speedometer1.jpg"];
		speedometer.position = ccp(20, 20);
		speedometer.anchorPoint = ccp(0, 0);
		speedometer.scale = 0.20f;
		[self addChild:speedometer];
		
		needle = [CCSprite spriteWithFile:@"needle.png"];
		needle.position = ccp(70, 68);
		needle.anchorPoint = ccp(0, 0);
		needle.scale = 0.20f;
		[self addChild:needle];
		
		[needle runAction:[CCSequence actions: [CCRotateTo actionWithDuration:0.2f angle:-130.0f], nil]];
	
	}
	return self;
}


-(void) displaySpeed:(float)currentSpeed {
	//NSLog(@"speed: %f", speed);
	if (speed > 0.0f) {
		float angleDegrees = needleAngle - ((speed / 50.0f) * 180.0f);
		//NSLog(@"angle : %f", angleDegrees);
		float cocosAngle = -1 * angleDegrees;
		[needle runAction:[CCSequence actions: [CCRotateTo actionWithDuration:0.2f angle:cocosAngle], nil]];
		needleAngle = angleDegrees;
		speed = 0;
	}
	speed += currentSpeed;
}

@end
