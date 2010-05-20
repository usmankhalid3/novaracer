//
//  GameOverLayer.m
//  NovaRacerBox2d
//
//  Created by adeel on 5/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameOverLayer.h"


@implementation GameOverLayer

- (id) initWithString:(NSString*)message {
	if ((self = [super init])) {
		CCLabel * label = [CCLabel labelWithString:message fontName:@"Arial" fontSize:20];
		CGSize size = [[CCDirector sharedDirector] winSize];
		label.position = ccp(size.width / 2, size.height / 2);
		[self addChild:label];
	}
	return self;
}

@end
