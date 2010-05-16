//
//  SpaceLayer.m
//  NovaRacer
//
//  Created by Usman Khalid on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SpaceLayer.h"

#define PTM_RATIO 32

@implementation SpaceLayer

@synthesize spaceObjects, spaceShip, damping;

typedef enum objectTypes {
	kSpaceShip = 1,
	kPlanet,
	kFlag
} SpaceObjectType;


-(void) setupMusic {
	NSString * soundPath = [[NSBundle mainBundle] pathForResource:@"soulfly" ofType:@"mp3"];
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
	[audioPlayer prepareToPlay];
	[audioPlayer play];
	audioPlayer.volume = 0.1;
	audioPlayer.numberOfLoops = -1;	// repeat forever
	sndFxPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
}

-(void) playSndFx:(NSString*)filename {
	NSString * soundPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"wav"];
	[sndFxPlayer initWithContentsOfURL:[NSURL fileURLWithPath:soundPath] error:nil];
	sndFxPlayer.volume = 0.3;
	[sndFxPlayer prepareToPlay];
	[sndFxPlayer play];
}

-(id) init {

	if ((self = [super init])) {
		CGSize size = [[CCDirector sharedDirector] winSize];
		[self setupCameraOfSize:size];
		[self createWorldOfSize:size];
		[self updateCamera];
		[self createPhysicsWorldOfSize:size];
		[self setupMusic];
		collisionEmitter = [[CollisionEffect alloc] initWithTotalParticles:300];
		[collisionEmitter stopSystem];
		[self addChild:collisionEmitter];
		
		[self loadGame];
	}
	return self;
}

-(void) updateCamera {
	[camera updateCamera: [spaceShip worldPosition]];
	[self setCameraPosition:[camera anchorPoint]];
}

-(void)setupCameraOfSize:(CGSize) size {
	camera = [[GameCamera alloc] init];
	[camera setAnchorPoint:CGPointZero];
	[camera setCameraSize:size];
}

-(void) createWorldOfSize:(CGSize)size {
	//CGPoint spaceShipPosition = ccp(size.width/2, size.height/2);
	CGPoint spaceShipPosition = ccp(1500, 400);
	CGPoint planetPosition = ccp(100, 250);
	CGPoint flagPosition = ccp(100, 300);
	
	spaceShip = [[SpaceShip alloc] init]; 
	[spaceShip setState:@"spaceship.png" worldPosition:spaceShipPosition tag:kSpaceShip positionIndex:-1];
	[spaceShip scaleObjectBy:0.5f];
	[self addObject:spaceShip];

	[self loadWorld];
}

-(void) createPhysicsWorldOfSize:(CGSize)size {
	
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
	[self addChild:[object sprite] z:4];
}

-(void) setCameraPosition:(CGPoint)cameraPosition {
	NSEnumerator * enumerator = [spaceObjects objectEnumerator];
	GameObject * object;
	while ((object = [enumerator nextObject])) {
		[object setCameraPosition:cameraPosition];
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
	CGPoint position = [camera worldToCameraPosition:[object worldPosition]];
	bodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
	bodyDef.userData = object;
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	float objectScale = [object scaledBy];
	if (associatedSprite.tag == kSpaceShip) {
		int num = 6;
		b2Vec2 verts[] = {
			b2Vec2(-3.0f * objectScale / PTM_RATIO, 78.0f * objectScale / PTM_RATIO),
			b2Vec2(-64.0f * objectScale / PTM_RATIO, -16.0f * objectScale / PTM_RATIO),
			b2Vec2(-64.0f * objectScale / PTM_RATIO, -76.0f * objectScale / PTM_RATIO),
			b2Vec2(57.0f * objectScale / PTM_RATIO, -75.0f * objectScale / PTM_RATIO),
			b2Vec2(57.0f * objectScale / PTM_RATIO, -14.0f * objectScale / PTM_RATIO),
			b2Vec2(-3.0f * objectScale / PTM_RATIO, 76.0f * objectScale / PTM_RATIO)
		};
		dynamicBox.Set(verts, num);
	}
	else if (associatedSprite.tag == kPlanet) {
		int num = 7;
		b2Vec2 verts[] = {
			b2Vec2(1.0f * objectScale  / PTM_RATIO, 158.6f * objectScale / PTM_RATIO),
			b2Vec2(-147.7f * objectScale / PTM_RATIO, 117.0f * objectScale / PTM_RATIO),
			b2Vec2(-152.9f * objectScale / PTM_RATIO, -104.5f * objectScale / PTM_RATIO),
			b2Vec2(10.4f * objectScale / PTM_RATIO, -178.4f * objectScale / PTM_RATIO),
			b2Vec2(158.1f * objectScale  / PTM_RATIO, -88.9f * objectScale / PTM_RATIO),
			b2Vec2(157.0f * objectScale / PTM_RATIO, 84.8f * objectScale / PTM_RATIO),
			b2Vec2(3.1f * objectScale / PTM_RATIO, 159.6f * objectScale / PTM_RATIO)
		};
		dynamicBox.Set(verts, num);
	}
	else if (associatedSprite.tag == kFlag) {
		int num = 4;
		b2Vec2 verts[] = {
			b2Vec2(-66.5f * objectScale / PTM_RATIO, 73.5f * objectScale / PTM_RATIO),
			b2Vec2(-65.5f * objectScale / PTM_RATIO, -71.5f * objectScale / PTM_RATIO),
			b2Vec2(68.5f * objectScale / PTM_RATIO, 15.5f * objectScale / PTM_RATIO),
			b2Vec2(-65.5f * objectScale / PTM_RATIO, 70.5f * objectScale / PTM_RATIO)
		};
		dynamicBox.Set(verts, num);
	}
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
	b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
	world = new b2World(gravity, false);
	//world->SetContinuousPhysics(true);
	
	// Debug Draw functions
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	//flags += b2DebugDraw::e_shapeBit;
	//		flags += b2DebugDraw::e_jointBit;
	//		flags += b2DebugDraw::e_aabbBit;
	//		flags += b2DebugDraw::e_pairBit;
	//		flags += b2DebugDraw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	contactListener = new ContactListener();
	world->SetContactListener(contactListener);	
}

- (void)tick:(ccTime)dt {
	
	[self updateCamera];
	
	b2Vec2 b2Position;
    world->Step(dt, 10, 10);
    for(b2Body *b = world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            GameObject *object = (GameObject *)b->GetUserData();
			CCSprite * sprite = [object sprite];
			CGPoint position = [camera worldToCameraPosition:[object worldPosition]];
			//if (sprite.tag!=kSpaceShip) {
				b2Position = b2Vec2(position.x/PTM_RATIO, position.y/PTM_RATIO);
			//}
			if (sprite.tag==kSpaceShip) {
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
				[self playSndFx:@"flag"];
			} else if (spriteA.tag == kSpaceShip && spriteB.tag == kFlag) {
				toDestroy.push_back(bodyB);
				[objA captureFlag];
				[self playSndFx:@"flag"];
			}
			
			if (spriteA.tag == kSpaceShip && spriteB.tag == kPlanet) {
				[objA setCollided:YES];
				[self playSndFx:@"collision"];
				collisionEmitter.position = spriteB.position;
				[collisionEmitter resetSystem];
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
	NSArray * keys = [map allKeys];
	NSString * key;
	for (key in [keys objectEnumerator]) {
		NSDictionary * coords = [map objectForKey:key];
		GameObject * gameObject = [[GameObject alloc] init];
		NSString * x = [coords objectForKey:@"x"];
		NSString * y = [coords objectForKey:@"y"];
		NSNumber * positionIndex = [coords objectForKey:@"positionIndex"];
		CGPoint position = CGPointMake([x intValue], [y intValue]);
		NSString * planet = @"planet";
		if ([planet isEqualToString:[coords objectForKey:@"type"]]) {
			[gameObject setState:@"earth.png" worldPosition:position tag:kPlanet positionIndex:[positionIndex intValue]];	
			[gameObject scaleObjectBy:0.15f];
		}
		else {
			[gameObject setState:@"red-flag.png" worldPosition:position tag:kFlag positionIndex:[positionIndex intValue]];	
			[gameObject scaleObjectBy:0.15f];
		}
		[self addObject:gameObject];
	}

	
	[map release];
}

-(void) setupFileForUse:(NSString*) filename {
	//Check to see if file exists
	NSString * completeFileName = [NSString stringWithFormat:@"%@.plist", filename];
	//Resouce directory path
	NSString *resourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", completeFileName]];
	
	//Documents directory path
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *DataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:completeFileName];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	//see if Data.plist exists in the Documents directory
	if (![fileManager fileExistsAtPath:DataPath]) {
		[fileManager copyItemAtPath:resourcePath toPath:DataPath error:nil];
	}	
}


-(void) loadGame {
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString * documentsPath = [paths objectAtIndex:0];
	NSString * finalPath = [documentsPath stringByAppendingPathComponent:@"data.plist"];
	
	NSFileManager * fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:finalPath] ) {
		finalPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"];
	}
		
	NSDictionary * map = [[NSDictionary dictionaryWithContentsOfFile:finalPath] retain];
	NSArray * keys = [map allKeys];
	NSString * key;
	for (key in [keys objectEnumerator]) {
		NSLog(@"%@", [map objectForKey:key]);
	}
	
	[map release];
}

-(void) saveGame {
	[self setupFileForUse:@"data"];

	NSString * errorDesc;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *DataPath = [documentsDirectory stringByAppendingPathComponent:@"data.plist"];

	NSString * posX = [[NSString alloc] init];
	posX = @"usman";
	
	NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: posX, nil] forKeys:[NSArray arrayWithObjects:@"posX", nil]];
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDesc];
	if (plistData) {
		[plistData writeToFile:DataPath atomically:YES];
	}
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
	[camera dealloc];
	[audioPlayer dealloc];
	[sndFxPlayer dealloc];
	[collisionEmitter dealloc];
	[super dealloc];
}

@end
