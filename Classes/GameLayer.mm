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
	CCSprite * background = [CCSprite spriteWithFile:@"space5.jpg"];
	background.position = ccp(240, 160);
	//background.anchorPoint = ccp(0, 0);
	[self addChild:background];
	
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

- (void)rotateLeftButtonTapped{
    float angleDegrees = [[spaceLayer spaceShip] currentRotation] + rotationAngle;
    float cocosAngle = -1 * angleDegrees;
    [[[spaceLayer spaceShip] sprite] runAction:[CCSequence actions: [CCRotateTo actionWithDuration:0.2f angle:cocosAngle], nil]];
	[[spaceLayer spaceShip] setCurrentRotation:angleDegrees];
}

- (void)rotateRightButtonTapped {
    float angleDegrees = [[spaceLayer spaceShip] currentRotation] - rotationAngle;
    float cocosAngle = -1 * angleDegrees;
    [[[spaceLayer spaceShip] sprite] runAction:[CCSequence actions: [CCRotateTo actionWithDuration:0.2f angle:cocosAngle], nil]];
	[[spaceLayer spaceShip] setCurrentRotation:angleDegrees];
}

-(void) setupButtons {
	accelerateButton = [[GameButton alloc] initButtonAtLocation:@"top.png" location:CGPointMake(240, 50)];
	rotateLeftButton = [[GameButton alloc] initButtonAtLocation:@"left.png" location:CGPointMake(190, 20)];
	rotateRightButton = [[GameButton alloc] initButtonAtLocation:@"right.png" location:CGPointMake(290, 20)];
	
	[self addChild:[accelerateButton button]];
	[self addChild:[rotateLeftButton button]];
	[self addChild:[rotateRightButton button]];
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		isTouchEnabled = true;
		
		acceleration = 10.0f;
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
		[self addChild:spaceLayer z:2];
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
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	for (UITouch * touch in touches) {
		CGPoint location = [touch locationInView: [touch view]];
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		if (CGRectContainsPoint([accelerateButton buttonRect], location)) {
			[self accelerateButtonTapStarted];
			//[accelerateButton tapStarted];
		}
		else if (CGRectContainsPoint([rotateLeftButton buttonRect], location)) {
			[self rotateLeftButtonTapped];
		}
		else if (CGRectContainsPoint([rotateRightButton buttonRect], location)) {
			[self rotateRightButtonTapped];
		}
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self accelerateButtonTapEnded];
}

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
