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
	background.position = ccp(0, 0);
	background.anchorPoint = ccp(0, 0);
	[self addChild:background];
}

-(void) setupSpeedometer {
	speedometer = [Speedometer node];
	[self addChild:speedometer z:3];	
}

-(void)setupCameraWithSize:(CGSize) size {
	camera = [[GameCamera alloc] init];
	[camera setAnchorPoint:CGPointZero];
	[camera setCameraSize:size];
}

- (void)accelerateButtonTapped:(id)sender {
    accelerateShip = YES;
}

-(void)decelerateButtonTapped:(id)sender {
	accelerateShip = NO;
}

- (void)rotateLeftButtonTapped:(id)sender {
    float angleDegrees = [[spaceLayer spaceShip] currentRotation] + rotationAngle;
    float cocosAngle = -1 * angleDegrees;
    [[[spaceLayer spaceShip] sprite] runAction:[CCSequence actions: [CCRotateTo actionWithDuration:0.2f angle:cocosAngle], nil]];
	[[spaceLayer spaceShip] setCurrentRotation:angleDegrees];
}

- (void)rotateRightButtonTapped:(id)sender {
    float angleDegrees = [[spaceLayer spaceShip] currentRotation] - rotationAngle;
    float cocosAngle = -1 * angleDegrees;
    [[[spaceLayer spaceShip] sprite] runAction:[CCSequence actions: [CCRotateTo actionWithDuration:0.2f angle:cocosAngle], nil]];
	[[spaceLayer spaceShip] setCurrentRotation:angleDegrees];
}

-(void) setupButtons {
	CCMenuItem *accelerateButton = [CCMenuItemImage 
									itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
									target:self selector:@selector(accelerateButtonTapped:)];
    accelerateButton.position = ccp(400, 120);
	
	CCMenuItem *decelerateButton = [CCMenuItemImage 
									itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
									target:self selector:@selector(decelerateButtonTapped:)];
    decelerateButton.position = ccp(400, 60);
	
	CCMenuItem *rotateLeftButton = [CCMenuItemImage 
									itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
									target:self selector:@selector(rotateLeftButtonTapped:)];
    rotateLeftButton.position = ccp(350, 90);
	
	CCMenuItem *rotateRightButton = [CCMenuItemImage 
									itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png" 
									target:self selector:@selector(rotateRightButtonTapped:)];
    rotateRightButton.position = ccp(450, 90);
	
    CCMenu *starMenu = [CCMenu menuWithItems:accelerateButton, decelerateButton, rotateLeftButton, rotateRightButton, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu];	
}


// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		acceleration = 10.0f;
		rotationAngle = 10.0f;
		damping = 0.05f;
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		//[self setupBackground];
		//[self setupSpeedometer];
		[self setupButtons];
		[self setupCameraWithSize:size];
		spaceLayer = [SpaceLayer node];
		[spaceLayer setDamping:damping];
		[self addChild:spaceLayer z:2];
		[self schedule:@selector(tick:)];
		
	}
	return self;
}

-(void) tick:(float) dt {
	float force = 0.0f;
	if (accelerateShip == YES) {
		force = acceleration * dt;
	}
	//[speedometer displaySpeed:force];
	[[spaceLayer spaceShip] accelerateShipBy:force];
	[camera updateCamera: [[spaceLayer spaceShip] worldPosition]];
	[spaceLayer setCameraPosition:[camera anchorPoint]];
	[spaceLayer tick:dt];
}


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[spaceLayer release];
	[camera dealloc];
	[super dealloc];
}
@end
