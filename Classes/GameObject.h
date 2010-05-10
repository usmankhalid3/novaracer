//
//  GameObject.h
//  NovaRacer
//
//  Created by adeel on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"


@interface GameObject : NSObject {
	CCSprite * sprite;
	float scaledBy;
	CGPoint worldPosition;
}

@property(nonatomic, readonly) CCSprite * sprite;
@property(nonatomic, readonly) float scaledBy;
@property(nonatomic, readwrite) CGPoint worldPosition;

-(void) setState:(NSString*)spriteName worldPosition:(CGPoint)position tag:(int)tag;
-(void) scaleObjectBy:(float)factor;
-(void) setCameraPosition:(CGPoint)cameraPosition;
-(CGPoint) worldPosition;

@end
