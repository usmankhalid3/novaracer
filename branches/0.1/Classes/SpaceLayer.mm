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

typedef enum objectTypes {
	kSpaceShip = 1,
	kPlanet,
	kFlag
} SpaceObjectType;

-(id) init {

	if ((self = [super init])) {
		CGSize size = [[CCDirector sharedDirector] winSize];
		[self createWorldOfSize:size];
	}
	CGPoint p = [self anchorPoint];
	//NSLog(@"position : (%f, %f)", p.x, p.y);
	return self;
}

-(void) createWorldOfSize:(CGSize)size {
	CGPoint spaceShipPosition = ccp(1500, 300);//ccp(size.width/2, size.height/2);
	CGPoint planetPosition = ccp(100, 300);
	
	spaceShip = [[SpaceShip alloc] init];
	[spaceShip setState:@"spaceShip.png" worldPosition:spaceShipPosition tag:kSpaceShip];
	//[self addChild:[spaceShip sprite]];
	[self addObject:spaceShip];
	
	/*GameObject * planet = [[GameObject alloc] init];
	[planet setState:@"red-flag.png" worldPosition:planetPosition tag:kFlag];		
	[planet scaleObjectBy:0.15f];
	[self addObject:planet];*/
	
	[self loadWorld];
	
	[self initPhysicsWorldOfSize:size];
	
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
	NSArray * sprites = [object getSprites];
	NSEnumerator * enumerator = [sprites objectEnumerator];
	CCSprite * sprite = nil;
	while ((sprite = [enumerator nextObject])) {
		[self addChild:sprite];
	}
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

-(void) setCameraPosition:(CGPoint)cameraPosition {
	NSEnumerator * enumerator = [spaceObjects objectEnumerator];
	GameObject * object;
	while ((object = [enumerator nextObject])) {
		[object setCameraPosition:cameraPosition];
	}
	/*CGPoint newLocation = worldPosition;
	newLocation.x = newLocation.x - cameraPosition.x;
	newLocation.y = newLocation.y - cameraPosition.y;
	self.position = newLocation;*/
}

-(void) setDamping:(float)d {
	damping = d;
	[spaceShip setDampingPercentage:d];
}

-(void) addPhysicsBody:(GameObject*)object {
	NSArray * sprites = [object getSprites];
	NSEnumerator * enumerator = [sprites objectEnumerator];
	CCSprite * associatedSprite = nil;
	while ((associatedSprite = [enumerator nextObject])) {
		
		b2BodyDef bodyDef;
		bodyDef.type = b2_dynamicBody;
		
		bodyDef.position.Set(associatedSprite.position.x/PTM_RATIO, associatedSprite.position.y/PTM_RATIO);
		bodyDef.userData = object;
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
	b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
	world = new b2World(gravity, false);
	//world->SetContinuousPhysics(true);
	
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
	b2Vec2 b2Position;
    world->Step(dt, 10, 10);
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            GameObject *object = (GameObject *)b->GetUserData();
			CCSprite * sprite = [object sprite];
			if (sprite.tag!=kSpaceShip) {
				b2Position = b2Vec2(sprite.position.x/PTM_RATIO, sprite.position.y/PTM_RATIO);
			}
			else {
				b2Position = b2Vec2(b->GetPosition().x, b->GetPosition().y);
			}
			float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
			b->SetTransform(b2Position, b2Angle);
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
			GameObject * objA = (GameObject *)bodyA->GetUserData();
			GameObject * objB = (GameObject *)bodyB->GetUserData();
			CCSprite *spriteA = [objA sprite];
			CCSprite *spriteB = [objB sprite];
			
			if (spriteA.tag == kFlag && spriteB.tag == kSpaceShip) {
				toDestroy.push_back(bodyA);
				[objB captureFlag];
			} else if (spriteA.tag == kSpaceShip && spriteB.tag == kFlag) {
				toDestroy.push_back(bodyB);
				[objA captureFlag];
			}
			
			if (spriteA.tag == kSpaceShip && spriteB.tag == kPlanet) {
				[objA setCollided:YES];
			}
		}        
	}
	
	std::vector<b2Body *>::iterator pos2;
	for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
		b2Body *body = *pos2;     
		if (body->GetUserData() != NULL) {
			GameObject *object = (GameObject *) body->GetUserData();
			[self removeChild:[object sprite] cleanup:YES];
			[spaceObjects removeObject:object];
		}
		world->DestroyBody(body);
	}
}

-(void) loadWorld {
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsPath = [paths objectAtIndex:0];
	NSString * finalPath = [documentsPath stringByAppendingPathComponent:@"map.plist"];
	
	NSFileManager * fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:finalPath] ) {
		finalPath = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"plist"];
	}
	
	NSDictionary * map = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
	NSLog(@"data : %@", map);
	NSArray * keys = [map allKeys];
	NSString * key;
	for (key in [keys objectEnumerator]) {
		NSDictionary * coords = [map objectForKey:key];
		GameObject * gameObject = [[GameObject alloc] init];
		NSString * x = [coords objectForKey:@"x"];
		NSString * y = [coords objectForKey:@"y"];
		CGPoint position = CGPointMake([x intValue], [y intValue]);
		NSString * planet = @"planet";
		if ([planet isEqualToString:[coords objectForKey:@"type"]]) {
			[gameObject setState:@"earth.png" worldPosition:position tag:kPlanet];	
			[gameObject scaleObjectBy:0.15f];
		}
		else {
			[gameObject setState:@"red-flag.png" worldPosition:position tag:kFlag];	
			[gameObject scaleObjectBy:0.15f];
		}
		[self addObject:gameObject];
	}

	
	[map release];
}

-(void) dealloc {

	if (spaceObjects!=nil) {
		[spaceObjects dealloc];
	}
	[spaceShip dealloc];
	if (world!=NULL) {
		delete world;
	}
	world = NULL;
	[super dealloc];
}

@end
