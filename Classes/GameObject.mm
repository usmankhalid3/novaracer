//
//  GameObject.m
//  NovaRacer
//
//  Created by adeel on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject
@synthesize sprite, worldPosition, scaledBy, objectTag;

-(id) init {
	if ((self = [super init])) {
		scaledBy = 1.0f;
	}
	return self;
}

-(void) setState:(NSString*)spriteName worldPosition:(CGPoint)position tag:(int)tag {
	sprite = [CCSprite spriteWithFile:spriteName];
	sprite.position = position;
	sprite.tag = tag;
	worldPosition = position;
	objectTag = tag;
}

-(void) scaleObjectBy:(float)factor {
	sprite.scale = factor;
	scaledBy = factor;
}

-(void) setCameraPosition:(CGPoint)cameraPosition {
	CGPoint newLocation = worldPosition;
	newLocation.x = newLocation.x - cameraPosition.x;
	newLocation.y = newLocation.y - cameraPosition.y;
	sprite.position = newLocation;
}

-(CGPoint) cameraPosition {
	return sprite.position;
}

-(NSArray*) getSprites {
	NSArray * array = [[NSArray alloc] initWithObjects:sprite, nil];
	[array autorelease];
	return array;
}

@end
