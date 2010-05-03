//
//  SpaceLayer.h
//  NovaRacer
//
//  Created by adeel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import "cocos2d.h"
//#import "GameObject.h"
#import "SpaceShip.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ContactListener.h"


@interface SpaceLayer : CCLayer {
	b2World * world;
	GLESDebugDraw *m_debugDraw;
	NSMutableArray * spaceObjects;
	SpaceShip * spaceShip;
	float damping;
	ContactListener *contactListener;
}

@property(nonatomic, readonly) SpaceShip * spaceShip;
@property(nonatomic, readwrite) float damping;

-(void) createWorldOfSize:(CGSize)size;
-(void) initPhysicsWorldOfSize:(CGSize)size;
-(void) addObject:(GameObject*)gameObject;
-(CGPoint) cameraPositionOf:(GameObject*)object;
-(void) setCameraPosition:(CGPoint)cameraPosition; // applies to all objects in this layer
-(void) addPhysicsBody:(GameObject*)object;
-(void) tick:(ccTime)dt;

@end
