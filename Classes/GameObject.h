//
//  GameObject.h
//  NovaRacer
//
//  Created by Usman Khalid on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"


@interface GameObject : NSObject {
	CCSprite * sprite;
	float scaledBy;
	CGPoint worldPosition;
	int positionIndex;
}

@property(nonatomic, readonly) CCSprite * sprite;
@property(nonatomic, readonly) float scaledBy;
@property(nonatomic, readwrite) CGPoint worldPosition;
@property(nonatomic, readwrite) int positionIndex;

-(void) setState:(NSString*)spriteName worldPosition:(CGPoint)position tag:(int)tag positionIndex:(int)posIndex;
-(void) scaleObjectBy:(float)factor;
-(void) setCameraPosition:(CGPoint)cameraPosition;
-(CGPoint) worldPosition;

@end
