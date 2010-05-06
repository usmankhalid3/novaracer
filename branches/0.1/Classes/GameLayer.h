
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameCamera.h"
#import "SpaceLayer.h"
#import "Speedometer.h"
#import "GameButton.h"

// HelloWorld Layer
@interface GameLayer : CCLayer
{
	BOOL accelerateShip;
	GameCamera * camera;
	SpaceLayer * spaceLayer;
	Speedometer * speedometer;
	float acceleration;	// in meters per second
	float damping;		// in percentage
	float rotationAngle;	// in degrees
	GameButton * accelerateButton;
	GameButton * rotateLeftButton;
	GameButton * rotateRightButton;
}

@property(nonatomic, readwrite) float acceleration;
@property(nonatomic, readwrite) float damping;
@property(nonatomic, readwrite) float rotationAngle;


// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) accelerateButtonTapStarted;
-(void) decelerateButtonTapEnded;
-(void) rotateLeftButtonTapped;
-(void) rotateRightButtonTapped;
-(void) setupButtons;
-(void) setupCameraWithSize:(CGSize)size;
-(void) setupBackground;
-(void) setupSpeedometer;

@end
