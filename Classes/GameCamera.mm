//
//  GameCamera.m
//  NovaRacer
//
//  Created by adeel on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameCamera.h"

@implementation GameCamera
@synthesize anchorPoint, cameraSize;

-(CGPoint) worldToCameraPosition:(CGPoint) worldPosition {
	CGPoint cameraPosition = worldPosition;
	cameraPosition.x = cameraPosition.x - anchorPoint.x;
	cameraPosition.y = cameraPosition.y - anchorPoint.y;
	return cameraPosition;
}

-(void) updateCamera:(CGPoint) shipPosition {
	anchorPoint.x = shipPosition.x - (cameraSize.width / 2);
	anchorPoint.y = shipPosition.y - (cameraSize.height / 2);
	//NSLog(@"new camera at:(%f, %f)", anchorPoint.x, anchorPoint.y);
}

@end
