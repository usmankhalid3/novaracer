
//#import "ScrollingBackground.h"
#import "SpaceLayer.h"
#import "Speedometer.h"
#import "GameButton.h"
#import "ScoreLabel.h"
#import "MiniMap.h"

// HelloWorld Layer
@interface GameLayer : CCLayer
{
	BOOL accelerateShip;
	int rotateShip;
	SpaceLayer * spaceLayer;
	Speedometer * speedometer;
	float acceleration;	// in meters per second
	float damping;		// in percentage
	float rotationAngle;	// in degrees
	GameButton * accelerateButton;
	GameButton * rotateLeftButton;
	GameButton * rotateRightButton;
	ScoreLabel * scoreLabel;
	//ScrollingBackground * background;
}

@property(nonatomic, readwrite) float acceleration;
@property(nonatomic, readwrite) float damping;
@property(nonatomic, readwrite) float rotationAngle;


// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(void) accelerateButtonTapStarted;
-(void) accelerateButtonTapEnded;
-(void) rotateLeftButtonTapStarted;
-(void) rotateLeftButtonTapEnded;
-(void) rotateRightButtonTapStarted;
-(void) rotateRightButtonTapEnded;
-(void) setupButtons;
-(void) setupBackground;
-(void) setupSpeedometer;
-(void) setupScoreLabel;

@end