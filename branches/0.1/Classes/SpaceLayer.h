//
//  SpaceLayer.h
//  NovaRacer
//
//  Created by Usman Khalid on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "cocos2d.h"
//#import "GameObject.h"
#import "SpaceShip.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"
#import "GameCamera.h"

@interface SpaceLayer : CCLayer {
	b2World * world;
	GameCamera * camera;
	GLESDebugDraw *m_debugDraw;
	NSMutableArray * spaceObjects;
	SpaceShip * spaceShip;
	float damping;
	ContactListener *contactListener;
	CGPoint worldPosition;
}

@property(nonatomic, readonly) SpaceShip * spaceShip;
@property(nonatomic, readwrite) float damping;

-(void) createWorldOfSize:(CGSize)size;
-(void) createPhysicsWorldOfSize:(CGSize)size;
-(void) setupCameraOfSize:(CGSize)size;
-(void) updateCamera;
-(void) initPhysicsWorldOfSize:(CGSize)size;
-(void) addObject:(GameObject*)gameObject;
-(void) setCameraPosition:(CGPoint)cameraPosition; // applies to all objects in this layer
-(void) addPhysicsBody:(GameObject*)object;
-(void) tick:(ccTime)dt;
-(void) loadWorld;

@end
