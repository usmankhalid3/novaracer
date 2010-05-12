//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "GameLayer.h"

// HelloWorld implementation
@implementation GameLayer
@synthesize acceleration, damping, rotationAngle;


+(id) scene
{
	CCScene *scene = [CCScene node];
	GameLayer * gameLayer = [GameLayer node];
	[scene addChild:gameLayer z:1];	
	return scene;
}

-(void) setupBackground {
	
	background = [CCSprite spriteWithFile:@"space5.jpg"];
	background.position = ccp(240, 160);
	//background.anchorPoint = ccp(0, 0);
	[self addChild:background];
	
	CCSprite * mapBackground = [CCSprite spriteWithFile:@"map.png"];
	[mapBackground setScale:0.4];
	[mapBackground setPosition:CGPointMake(420, 55)];
	[self addChild:mapBackground z:4];
	
	/*background = [[ScrollingBackground alloc] initWithFile:@"space5.jpg"]; 
	
	ccTexParams params = { GL_LINEAR, GL_LINEAR, GL_REPEAT, GL_REPEAT }; 
	[background.texture setTexParameters:&params]; 
	background.position = CGPointMake(240, 160); 
	[self addChild:background z:1];*/
	
	
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
}

- (void)accelerateButtonTapEnded {
	accelerateShip = NO;
}

- (void)rotateLeftButtonTapStarted{
	rotateShip = 1;
}

-(void) rotateLeftButtonTapEnded {
	rotateShip = 0;
}

- (void) rotateRightButtonTapStarted {
	rotateShip = -1;
}

-(void) rotateRightButtonTapEnded {
	rotateShip = 0;
}

-(void) setupButtons {
	accelerateButton = [[GameButton alloc] initButtonAtLocation:@"top.png" location:CGPointMake(240, 50)];
	rotateLeftButton = [[GameButton alloc] initButtonAtLocation:@"left.png" location:CGPointMake(190, 20)];
	rotateRightButton = [[GameButton alloc] initButtonAtLocation:@"right.png" location:CGPointMake(290, 20)];
	
	[self addChild:[accelerateButton button] z:4];
	[self addChild:[rotateLeftButton button] z:4];
	[self addChild:[rotateRightButton button] z:4];
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		isTouchEnabled = true;
		
		acceleration = 20.0f;
		rotationAngle = 10.0f;
		damping = 0.05f;
		// ask director the the window size
		//CGSize size = [[CCDirector sharedDirector] winSize];
		
		[self setupBackground];
		[self setupScoreLabel];
		[self setupSpeedometer];
		[self setupButtons];
		spaceLayer = [SpaceLayer node];
		[spaceLayer setDamping:damping];
		[[spaceLayer spaceShip] setCurrentRotation:-90];
		[self addChild:spaceLayer z:2];
		mmap = [MiniMap node];
		[mmap initForWorldOfSize:CGSizeMake(3000, 3000)];
		[mmap addFlagPositions:[spaceLayer spaceObjects]];
		[mmap addPlanetPositions:[spaceLayer spaceObjects]];
		[mmap addSpaceshipPosition:[[spaceLayer spaceShip] worldPosition]];
		[self addChild:mmap z:4];
		[self schedule:@selector(tick:)];
		
	}
	return self;
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
	}
	if ([[spaceLayer spaceShip] collided] == YES) {
		accelerateShip = NO;
	}
	
	/*CGPoint texOffset = background.texOffset;
	texOffset.y = texOffset.y - (50*dt);
	texOffset.x = texOffset.x - (50*dt);
	background.texOffset = texOffset;*/
	
	//[speedometer displaySpeed:force];
	[[spaceLayer spaceShip] accelerateShipBy:force];
	[spaceLayer tick:dt];
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

/*-(void) draw {
	[super draw]; 
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	glTranslatef( texOffset.x/[background contentSize].width, texOffset.y/[background contentSize].height, 0); 
	//Draw the texture 
	[background.texture drawAtPoint:CGPointZero];
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
}*/

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[accelerateButton dealloc];
	[rotateLeftButton dealloc];
	[rotateRightButton dealloc];
	[spaceLayer release];
	//[camera dealloc];
	[super dealloc];
}
@end
