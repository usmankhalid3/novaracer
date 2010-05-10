//
//  ScoreLabel.m
//  NovaRacerBox2d
//
//  Created by adeel on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScoreLabel.h"


@implementation ScoreLabel

-(id) init {
	
	if ((self = [super init])) {
		score = 0;
		flagImage = [CCSprite spriteWithFile:@"red-flag.png"];
		[flagImage setPosition:CGPointMake(32, 300)];
		[flagImage setScale:0.15f];
		label = [CCLabel labelWithString:[NSString stringWithFormat:@"%i", score] fontName:@"Arial" fontSize:20];
		[label setPosition:CGPointMake(54, 300)];
	}
	return self;
}

-(NSArray*) getContent {	
	NSArray * array = [[NSArray alloc] initWithObjects:flagImage, label, nil];
	[array autorelease];
	return array;
}

-(void) dealloc {
	[label dealloc];
	[flagImage dealloc];
	[super dealloc];
}

-(void) updateScore:(int) newScore {
	score = newScore;
	[label setString:[NSString stringWithFormat:@"%i", score]];
}

@end
