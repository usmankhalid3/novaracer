//
//  Barrier.h
//  NovaRacerBox2d
//
//  Created by adeel on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


@interface CheckPoint : GameObject {
	CCSprite * gate1;
	CCSprite * gate2;
	CGPoint gate1Position;
	CGPoint gate2Position;
}

@property(nonatomic, readonly) CCSprite * gate1;
@property(nonatomic, readonly) CCSprite * gate2;

@end
