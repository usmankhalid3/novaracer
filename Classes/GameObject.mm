//
//  GameObject.m
//  NovaRacer
//
//  Created by Usman Khalid on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject
@synthesize sprite, scaledBy, worldPosition, positionIndex;

-(id) init {
	if ((self = [super init])) {
		scaledBy = 1.0f;
	}
	return self;
}

-(void) setState:(NSString*)spriteName worldPosition:(CGPoint)position tag:(int)tag positionIndex:(int)posIndex{
	sprite = [CCSprite spriteWithFile:spriteName];
	[sprite setPosition:position];
	[sprite setTag:tag];
	worldPosition = position;
	positionIndex = posIndex;
}

-(void) scaleObjectBy:(float)factor {
	sprite.scale = factor;
	scaledBy = factor;
}

-(void) setCameraPosition:(CGPoint)cameraPosition {
	CGPoint newLocation = worldPosition;
	newLocation.x = newLocation.x - cameraPosition.x;
	newLocation.y = newLocation.y - cameraPosition.y;
	[sprite setPosition:newLocation];
}

@end
