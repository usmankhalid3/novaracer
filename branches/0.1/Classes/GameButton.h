//
//  GameButton.h
//  NovaRacerBox2d
//
//  Created by adeel on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface GameButton : NSObject {
	CCSprite * button;
	CGRect buttonRect;
	SEL tapStarted;
	SEL tapEnded;
	id associatedObject;
	NSInvocation * invocation;
}

@property(nonatomic, readonly) CGRect buttonRect;
@property(nonatomic, readonly) CCSprite * button;

//-(id) initButtonAtLocation:(NSString*)filename location:(CGPoint)location target:(id) t tapStarted:(SEL)ts tapEnded:(SEL)te;
-(id) initButtonAtLocation:(NSString*)filename location:(CGPoint)location;
-(void) tapStarted;
-(void) tapEnded;

@end
