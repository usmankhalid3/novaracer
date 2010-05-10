//
//  GameButton.m
//  NovaRacerBox2d
//
//  Created by Usman Khalid on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameButton.h"


@implementation GameButton

@synthesize buttonRect, button;

-(id) initButtonAtLocation:(NSString*)filename location:(CGPoint)location{
	
	if ((self = [super init])) {
		button = [CCSprite spriteWithFile:filename];
		button.position = location;
		float actualX = button.position.x - ([button contentSize].width/2);
		float actualY = button.position.y - ([button contentSize].height/2);
		float buttonWidth = [button contentSize].width;
		float buttonHeight = [button contentSize].height;
		buttonRect = CGRectMake(actualX, actualY, buttonWidth, buttonHeight);
		/*associatedObject = t;
		tapStarted = ts;
		tapEnded = te;
		NSMethodSignature * sig = [[t class] instanceMethodSignatureForSelector:ts]; 
		invocation = [NSInvocation invocationWithMethodSignature:sig];
		[invocation setTarget:t];
		[invocation setSelector:ts];
		//[invocation retain];*/
	}
	return self;
}

-(void) tapStarted {
	//[self performSelector:tapStarted];
	//[invocation invoke];
}

-(void) tapEnded {	
	//[self performSelector:tapEnded];
}

-(void) dealloc {
	
	//[invocation release];
	[super dealloc];
}

@end
