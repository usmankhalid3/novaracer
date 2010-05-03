//
//  Speedometer.m
//  NovaRacer
//
//  Created by adeel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Speedometer.h"


@implementation Speedometer

-(id) init {
	
	if ((self = [super init])) {
		speedometer = [CCSprite spriteWithFile:@"speedometer1.jpg"];
		speedometer.position = ccp(20, 20);
		speedometer.anchorPoint = ccp(0, 0);
		speedometer.scale = 0.20f;
		[self addChild:speedometer];
		
		needle = [CCSprite spriteWithFile:@"needle.png"];
		needle.position = ccp(68, 70);
		needle.anchorPoint = ccp(0, 0);
		needle.scale = 0.20f;
		[self addChild:needle];
	}
	return self;
}


-(void) displaySpeed:(float)force {
	float angleDegrees = 50.0f;
    float cocosAngle = -1 * angleDegrees;
    [needle runAction:[CCSequence actions: [CCRotateTo actionWithDuration:0.05f angle:cocosAngle], nil]];
	needleAngle = needleAngle + angleDegrees;
	speed = speed + force;
}

@end
