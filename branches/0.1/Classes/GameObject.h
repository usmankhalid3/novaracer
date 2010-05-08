//
//  GameObject.h
//  NovaRacer
//
//  Created by adeel on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface GameObject : NSObject {
	CCSprite * sprite;
	CGPoint worldPosition;
	float scaledBy;
	int objectTag;
}

@property(nonatomic, readonly) CCSprite * sprite;
@property(nonatomic, readwrite) CGPoint worldPosition;
@property(nonatomic, readonly) float scaledBy;
@property(nonatomic, readwrite) int objectTag;

-(void) setState:(NSString*)spriteName worldPosition:(CGPoint)position tag:(int)tag;
-(void) scaleObjectBy:(float)factor;
-(CGPoint) cameraPosition;
-(void) setCameraPosition:(CGPoint)cameraPosition;
-(NSArray*) getSprites;


@end
