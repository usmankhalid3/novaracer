//
//  SpaceLayer.m
//  NovaRacer
//
//  Created by adeel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpaceLayer.h"

#define PTM_RATIO 32

@implementation SpaceLayer

@synthesize spaceShip, damping;

-(id) init {

	if ((self = [super init])) {
		CGSize size = [[CCDirector sharedDirector] winSize];
		[self createWorldOfSize:size];
	}
	return self;
}

-(void) createWorldOfSize:(CGSize)size {
	CGPoint spaceShipPosition = ccp(size.width/2, size.height/2);
	CGPoint planetPosition = ccp(100, 300);
	
	spaceShip = [[SpaceShip alloc] init];
	[spaceShip setState:@"spaceShip.png" worldPosition:spaceShipPosition tag:2];
	[self addChild:[spaceShip sprite]];
	
	GameObject * planet = [[GameObject alloc] init];
	[planet setState:@"earth.png" worldPosition:planetPosition tag:1];		
	[planet scaleObjectBy:0.15f];
	[self addObject:planet];
	
	[self initPhysicsWorldOfSize:size];
	
	[self addPhysicsBody:spaceShip];
	
	NSEnumerator * enumerator = [spaceObjects objectEnumerator];
	GameObject * object;
	while ((object = [enumerator nextObject])) {
		[self addPhysicsBody:object];
	}
}

-(void) addObject:(GameObject*)object {
	if (spaceObjects==nil) {
		spaceObjects = [[NSMutableArray alloc] init];
	}
	[spaceObjects addObject:object];
	[self addChild:[object sprite]];	
}

-(CGPoint) cameraPositionOf:(GameObject*)gameObject {
	NSEnumerator * enumerator = [spaceObjects objectEnumerator];
	GameObject * object;
	while ((object = [enumerator nextObject])) {
		CCSprite * sprite1 = [object sprite];
		CCSprite * sprite2 = [gameObject sprite];
		if (sprite1 == sprite2) {
			return [object cameraPosition];
		}
	}
	return CGPointZero;
}

-(void) setCameraPosition:(CGPoint)position {
	NSEnumerator * enumerator = [spaceObjects objectEnumerator];
	GameObject * object;
	while ((object = [enumerator nextObject])) {
		[object setCameraPosition:position];
	}
}

-(void) setDamping:(float)d {
	damping = d;
	[spaceShip setDampingPercentage:d];
}

-(void) addPhysicsBody:(GameObject*)object {

	CCSprite * associatedSprite = [object sprite];

	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	
	bodyDef.position.Set(associatedSprite.position.x/PTM_RATIO, associatedSprite.position.y/PTM_RATIO);
	bodyDef.userData = associatedSprite;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox((associatedSprite.contentSize.width * [object scaledBy])/PTM_RATIO/2, (associatedSprite.contentSize.height * [object scaledBy])/PTM_RATIO/2);//These are mid points for our sprite
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.isSensor = true; // should set to true when you want to know when objects will collide but without triggering a collision response
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
}

-(void) initPhysicsWorldOfSize:(CGSize)size {
	b2Vec2 gravity = b2Vec2(0.0f, -10.0f);
	world = new b2World(gravity, true);
	world->SetContinuousPhysics(true);
	
	// Debug Draw functions
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2DebugDraw::e_shapeBit;
	//		flags += b2DebugDraw::e_jointBit;
	//		flags += b2DebugDraw::e_aabbBit;
	//		flags += b2DebugDraw::e_pairBit;
	//		flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	contactListener = new ContactListener();
	world->SetContactListener(contactListener);	
}

- (void)tick:(ccTime)dt {
	
    world->Step(dt, 10, 10);
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *)b->GetUserData();			
            b2Vec2 b2Position = b2Vec2(sprite.position.x/PTM_RATIO,
                                       sprite.position.y/PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
            b->SetTransform(b2Position, b2Angle);
			//NSLog(@"position: (%f, %f)", b->GetPosition().x, b->GetPosition().y);
        }
    }
	
	std::vector<b2Body *>toDestroy; 
	std::vector<MyContact>::iterator pos;
	for(pos = contactListener->_contacts.begin(); 
		pos != contactListener->_contacts.end(); ++pos) {
		MyContact contact = *pos;
		
		b2Body *bodyA = contact.fixtureA->GetBody();
		b2Body *bodyB = contact.fixtureB->GetBody();
		if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
			CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
			CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
			
			if (spriteA.tag == 1 && spriteB.tag == 2) {
				toDestroy.push_back(bodyA);
			} else if (spriteA.tag == 2 && spriteB.tag == 1) {
				toDestroy.push_back(bodyB);
			} 
		}        
	}
	
	std::vector<b2Body *>::iterator pos2;
	GameObject * objToDelete = nil;
	for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
		b2Body *body = *pos2;     
		if (body->GetUserData() != NULL) {
			CCSprite *sprite = (CCSprite *) body->GetUserData();
			NSEnumerator * enumerator = [spaceObjects objectEnumerator];
			GameObject * object;
			while ((object = [enumerator nextObject])) {
				CCSprite * tempSprite = [object sprite];
				if (sprite == tempSprite) {
					objToDelete = object;
				}
			}
			[self removeChild:sprite cleanup:YES];
		}
		world->DestroyBody(body);
	}
	if (objToDelete!=nil) {
		[spaceObjects removeObject:objToDelete];
	}
}

-(void) dealloc {
	
	if (world!=NULL) {
		delete world;
	}
	world = NULL;
	if (spaceObjects!=nil) {
		[spaceObjects release];
	}
	[spaceShip dealloc];
	[super dealloc];
}

@end
