//
//  Speedometer.h
//  NovaRacer
//
//  Created by adeel on 5/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface Speedometer : CCLayer {
	CCSprite * speedometer;
	CCSprite * needle;
	float needleAngle;
	float speed;
}

-(void) displaySpeed:(float)force;


@end
