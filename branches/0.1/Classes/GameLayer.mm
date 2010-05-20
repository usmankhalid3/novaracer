//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "GameLayer.h"

@implementation GameLayer
@synthesize acceleration, damping, rotationAngle;

/*+(id) scene
{
	CCScene *scene = [CCScene node];
	GameLayer * gameLayer = [GameLayer node];
	[scene addChild:gameLayer z:1];	
	return scene;
}*/

-(void) setupBackground {
	background = [[ScrollingBackground alloc] initWithFile:@"space.png"]; 
	ccTexParams params = { GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT }; 
	[background.texture setTexParameters:&params]; 
	background.position = CGPointMake(240, 160); 
	[self addChild:background z:0];
}

-(void) setupScoreLabel {
	scoreLabel = [[ScoreLabel alloc] init];
	NSArray * content = [scoreLabel getContent];
	NSEnumerator * enumerator = [content objectEnumerator];
	CCNode * node;
	while ((node = [enumerator nextObject])) {
		[self addChild:node];
	}	
}

-(void) setupSpeedometer {
	speedometer = [Speedometer node];
	[self addChild:speedometer z:3];	
}

- (void)accelerateButtonTapStarted {
    accelerateShip = YES;
	[emitter resetSystem];
}

- (void)accelerateButtonTapEnded {
	accelerateShip = NO;
	[emitter stopSystem];
}

- (void)rotateLeftButtonTapStarted{
	rotateShip = 1;
	[emitter resetSystem];
}

-(void) rotateLeftButtonTapEnded {
	rotateShip = 0;
	[emitter stopSystem];
}

- (void) rotateRightButtonTapStarted {
	rotateShip = -1;
	[emitter resetSystem];
}

-(void) rotateRightButtonTapEnded {
	rotateShip = 0;
	[emitter stopSystem];
}

-(void) saveButtonTapped:(id) sender {
	[spaceLayer saveGame:emitter.position];
}

-(void) setupButtons {
	accelerateButton = [[GameButton alloc] initButtonAtLocation:@"top.png" location:CGPointMake(240, 70)];
	rotateLeftButton = [[GameButton alloc] initButtonAtLocation:@"left.png" location:CGPointMake(170, 20)];
	rotateRightButton = [[GameButton alloc] initButtonAtLocation:@"right.png" location:CGPointMake(310, 20)];

	[self addChild:[accelerateButton button] z:4];
	[self addChild:[rotateLeftButton button] z:4];
	[self addChild:[rotateRightButton button] z:4];
	
	CCMenuItem * saveItem = [CCMenuItemFont itemFromString:@"Save" target:self selector:@selector(saveButtonTapped:)];
	saveItem.position = ccp(200, 130);
	CCMenu * menu = [CCMenu menuWithItems:saveItem, nil];
	[self addChild:menu z:4];
}

-(void) setupSpaceLayer {	
	spaceLayer = [SpaceLayer node];
	[spaceLayer setDamping:damping];
	[[spaceLayer spaceShip] setCurrentRotation:-90];
	[self addChild:spaceLayer z:2];
}

-(void) setupMiniMap {
	CCSprite * mapBackground = [CCSprite spriteWithFile:@"map.png"];
	[mapBackground setScale:0.45];
	[mapBackground setPosition:CGPointMake(420, 55)];
	[self addChild:mapBackground z:4];
	
	mmap = [MiniMap node];
	[mmap initForWorldOfSize:CGSizeMake(3000, 3000)];
	[mmap addFlagPositions:[spaceLayer spaceObjects]];
	[mmap addPlanetPositions:[spaceLayer spaceObjects]];
	[mmap addSpaceshipPosition:[[spaceLayer spaceShip] worldPosition]];
	[self addChild:mmap z:4];	
}

-(id) initFromStoredState {
	if (( self = [self init] )) {	// NOT [super init]
		CGPoint emitterPosition = [spaceLayer loadGame];
		emitter.position = emitterPosition;
		[self updateEmitterPosition];
		[scoreLabel updateScore:[[spaceLayer spaceShip] flagsScored]];
	}
	return self;
}

-(id) init
{
	if( (self=[super init] )) {
		
		isTouchEnabled = true;
		
		acceleration = 20.0f;
		rotationAngle = 10.0f;
		damping = 0.015f;
	
		[self setupBackground];
		[self setupScoreLabel];
		[self setupSpeedometer];
		[self setupButtons];
		[self setupSpaceLayer];
		[self setupMiniMap];
		
		emitter = [[CombustionEffect alloc] initWithTotalParticles:100];
		[emitter stopSystem];
		[self addChild:emitter z:4];
		
		[self schedule:@selector(tick:)];
		
	}
	return self;
}

-(void) updateEmitterPosition {
	CGPoint emitterPosition = emitter.position;
	float currentRotation = [[spaceLayer spaceShip] currentRotation];
	float cosValue = cos(CC_DEGREES_TO_RADIANS(-1*rotateShip));
	float sinValue = sin(CC_DEGREES_TO_RADIANS(rotateShip));
	emitterPosition.x = emitterPosition.x - 240;
	emitterPosition.y = emitterPosition.y - 160;
	emitterPosition.x = (emitterPosition.x * cosValue) - (emitterPosition.y * sinValue);
	emitterPosition.y = (emitterPosition.x * sinValue) + (emitterPosition.y * cosValue);
	emitterPosition.x = emitterPosition.x + 240;
	emitterPosition.y = emitterPosition.y + 160;
	emitter.position = emitterPosition;
	[emitter setAngle:currentRotation];
}

- (void) gameBounds
{
	CGPoint boundaries = [[spaceLayer spaceShip] worldPosition];
	float sCurrentRotation = [[spaceLayer spaceShip] currentRotation];
	CGPoint reset;
	
	if (boundaries.x >= 2500)
	{
		accelerateShip = NO;
		if (boundaries.x >= 3000)
		{
			reset = ccp (2999, boundaries.y);
			[[spaceLayer spaceShip] haultShip];
			[[spaceLayer spaceShip] setWorldPosition:reset];
		}
	}
	
	if (boundaries.y >= 2500)
	{
		accelerateShip = NO;
		if (boundaries.y >= 3000)
		{
			reset = ccp (boundaries.y, 2999);
			[[spaceLayer spaceShip] haultShip];
			[[spaceLayer spaceShip] setWorldPosition:reset];
		}
	}
	
	if (boundaries.x <= 350)
	{
		accelerateShip = NO;
		if (boundaries.x <= 0)
		{
			reset = ccp (1, boundaries.y);
			[[spaceLayer spaceShip] haultShip];
			[[spaceLayer spaceShip] setWorldPosition:reset];
		}
	}
	
	if (boundaries.y <= 350)
	{
		accelerateShip = NO;
		if (boundaries.x <= 0)
		{
			reset = ccp (boundaries.x, 1);
			[[spaceLayer spaceShip] haultShip];
			[[spaceLayer spaceShip] setWorldPosition:reset];
		}
	}
}

-(void) tick:(float) dt {
	
	if ([[spaceLayer spaceShip] capturedFlag]==YES) {
		[[spaceLayer spaceShip] setCapturedFlag:NO];
		[scoreLabel updateScore:[[spaceLayer spaceShip] flagsScored]];
	}


	float force = 0.0f;
	if (accelerateShip == YES) {
		force = acceleration * dt;
	}
	if (rotateShip!=0) {
		[[spaceLayer spaceShip] setCurrentRotation:rotateShip];
		[self updateEmitterPosition];
	}
	BOOL collided = [[spaceLayer spaceShip] collided];
	if (collided == YES) {
		accelerateShip = NO;
	}
	
	[self gameBounds];
	[speedometer displaySpeed:[[spaceLayer spaceShip] speed] accelerateShip:accelerateShip];
	[[spaceLayer spaceShip] accelerateShipBy:force];
	[spaceLayer tick:dt];
	[background scrollWithVelocity:[[spaceLayer spaceShip] worldVelocity] collided:collided];
	[mmap updateSpaceshipPosition:[[spaceLayer spaceShip] worldPosition]];
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	for (UITouch * touch in touches) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		if (CGRectContainsPoint([accelerateButton buttonRect], location)) {
			[self accelerateButtonTapStarted];
		}
		else if (CGRectContainsPoint([rotateLeftButton buttonRect], location)) {
			[self rotateLeftButtonTapStarted];
		}
		else if (CGRectContainsPoint([rotateRightButton buttonRect], location)) {
			[self rotateRightButtonTapStarted];
		}
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self accelerateButtonTapEnded];
	[self rotateRightButtonTapEnded];
	[self rotateLeftButtonTapEnded];
}

- (void) dealloc
{
	// cocos2d will automatically release all the children (Label)
	
	[accelerateButton release];
	[rotateLeftButton release];
	[rotateRightButton release];
	[spaceLayer release];
	[emitter release];
	[super dealloc];
}
@end
