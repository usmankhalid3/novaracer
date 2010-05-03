
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameCamera.h"
#import "SpaceLayer.h"
#import "Speedometer.h"

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
}

@property(nonatomic, readwrite) float acceleration;
@property(nonatomic, readwrite) float damping;
@property(nonatomic, readwrite) float rotationAngle;


// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) accelerateButtonTapped:(id)sender;
-(void) decelerateButtonTapped:(id)sender;
-(void) rotateLeftButtonTapped:(id)sender;
-(void) rotateRightButtonTapped:(id)sender;
-(void) setupButtons;
-(void) setupCameraWithSize:(CGSize)size;
-(void) setupBackground;
-(void) setupSpeedometer;

@end
