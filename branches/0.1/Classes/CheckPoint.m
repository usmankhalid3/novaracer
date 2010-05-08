//
//  Barrier.m
//  NovaRacerBox2d
//
//  Created by adeel on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CheckPoint.h"


@implementation CheckPoint

@synthesize gate1, gate2;

- (id) init {
	
	if ((self = [super init])) {
		gate1 = [CCSprite spriteWithFile:@"gate.png"];
		gate1.position = ccp(200, 200);
		gate2 = [CCSprite spriteWithFile:@"gate.png"];
		gate2.position = ccp(285, 285);
		
		gate1Position = ccp(200,200);
		gate2Position = ccp(285, 285);
	}

	return self;
}

-(void) setCameraPosition:(CGPoint)cameraPosition {
	CGPoint newLocation = gate1Position;
	newLocation.x = newLocation.x - cameraPosition.x;
	newLocation.y = newLocation.y - cameraPosition.y;
	gate1.position = newLocation;
	
	newLocation = gate2Position;
	newLocation.x = newLocation.x - cameraPosition.x;
	newLocation.y = newLocation.y - cameraPosition.y;
	gate2.position = newLocation;
}


-(NSArray*) getSprites {
	NSArray * array = [[NSArray alloc] initWithObjects:gate1, gate2, nil];
	[array autorelease];
	return array;
}


@end
