//
//  GameCamera.m
//  NovaRacer
//
//  Created by Usman Khalid on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameCamera.h"

@implementation GameCamera
@synthesize anchorPoint, cameraSize;

-(CGPoint) worldToCameraPosition:(CGPoint) worldPosition {
	worldPosition.x = worldPosition.x - anchorPoint.x;
	worldPosition.y = worldPosition.y - anchorPoint.y;
	return worldPosition;
}

-(void) updateCamera:(CGPoint) shipPosition {
	anchorPoint.x = shipPosition.x - (cameraSize.width / 2);
	anchorPoint.y = shipPosition.y - (cameraSize.height / 2);
	//NSLog(@"new camera at:(%f, %f)", anchorPoint.x, anchorPoint.y);
}

@end
