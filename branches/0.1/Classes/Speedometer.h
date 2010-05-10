//
//  Speedometer.h
//  NovaRacer
//
//  Created by Usman Khalid on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface Speedometer : CCLayer {
	CCSprite * speedometer;
	CCSprite * needle;
	CCSprite * needle2;
	float needleAngle;
	float speed;
}

@property(nonatomic, readonly) CCSprite * needle;

-(void) displaySpeed:(float)speed;


@end
