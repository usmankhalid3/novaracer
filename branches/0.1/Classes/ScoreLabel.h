//
//  ScoreLabel.h
//  NovaRacerBox2d
//
//  Created by adeel on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface ScoreLabel : NSObject {
	CCSprite * flagImage;
	CCLabel * label;
	int score;
}

-(NSArray*) getContent;
-(void) updateScore:(int) newScore;

@end
