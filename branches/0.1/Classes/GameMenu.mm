//
//  GameMenu.m
//  NovaRacerBox2d
//
//  Created by adeel on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameMenu.h"

@implementation GameMenu

+(id) scene
{
	CCScene *scene = [CCScene node];
	GameMenu * menuLayer = [GameMenu node];
	[scene addChild:menuLayer z:5];	
	return scene;
}

-(id) init {

	if (( self = [super initWithColor:ccc4(0, 0, 0, 0)] )) {
		CCMenuItem * playItem = [CCMenuItemFont itemFromString:@"Play Game" target:self selector:@selector(onPlay:)];
		CCMenuItem * settingsItem = [CCMenuItemFont itemFromString:@"Load Game" target:self selector:@selector(onLoad:)];
		CCMenuItem * helpItem = [CCMenuItemFont itemFromString:@"Help" target:self selector:@selector(onHelp:)];
		CCMenuItem * aboutItem = [CCMenuItemFont itemFromString:@"About" target:self selector:@selector(onAbout:)];
		CCMenu * menu = [CCMenu menuWithItems:playItem, settingsItem, helpItem, aboutItem, nil];
		[menu alignItemsVertically];
		
		[self addChild:menu];
	}
	return self;
}

-(void) onPlay:(id) sender {
	[[CCDirector sharedDirector] replaceScene:[CCRotoZoomTransition transitionWithDuration:1.0 scene:[GameLayer node]]];
}

-(void) onLoad:(id) sender {
	id layer = [[[GameLayer alloc] initFromStoredState] autorelease];
	[[CCDirector sharedDirector] replaceScene:[CCRotoZoomTransition transitionWithDuration:1.0 scene:layer]];	
}

-(void) onHelp:(id) sender {
	
}

-(void) onAbout:(id) sender {
	
}

@end
