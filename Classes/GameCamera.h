//
//  GameCamera.h
//  NovaRacer
//
//  Created by adeel on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GameCamera : NSObject {
	CGPoint anchorPoint;
	CGSize cameraSize;
}

@property(nonatomic, readwrite) CGPoint anchorPoint;
@property(nonatomic, readwrite) CGSize cameraSize;

-(CGPoint) worldToCameraPosition:(CGPoint)worldPosition;
-(void) updateCamera:(CGPoint)shipPosition;

@end
