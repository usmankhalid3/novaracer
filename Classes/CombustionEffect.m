//
//  CombustionEffect.m
//  NovaRacerBox2d
//
//  Created by adeel on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CombustionEffect.h"


@implementation CombustionEffect

-(id) initWithTotalParticles:(int) p
{
	if( !(self=[super initWithTotalParticles:30]) )
		return nil;
	
	// additive
	blendAdditive = YES;
	
	// duration
	duration = -1;
	
	// gravity
	gravity.x = 0;
	gravity.y = 0;
	
	// angle
	angle = -90;
	angleVar = 0;
	
	// radial acceleration
	radialAccel = 0;
	radialAccelVar = 0;	
	
	// emitter position
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	self.position = ccp(winSize.width/2, winSize.height/2 - 42);
	posVar = CGPointZero;
	
	// life of particles
	life = 1;
	lifeVar = 0;
	
	// speed of particles
	speed = 50;
	speedVar = 0;
	
	// size, in pixels
	startSize = 30.0f;
	startSizeVar = 10.0f;
	endSize = kParticleStartSizeEqualToEndSize;
	
	// emits per seconds
	emissionRate = totalParticles/life;
	
	// color of particles
	startColor.r = 0.76f;
	startColor.g = 0.25f;
	startColor.b = 0.12f;
	startColor.a = 1.0f;
	startColorVar.r = 0.0f;
	startColorVar.g = 0.0f;
	startColorVar.b = 0.0f;
	startColorVar.a = 0.0f;
	endColor.r = 0.0f;
	endColor.g = 0.0f;
	endColor.b = 0.0f;
	endColor.a = 1.0f;
	endColorVar.r = 0.0f;
	endColorVar.g = 0.0f;
	endColorVar.b = 0.0f;
	endColorVar.a = 0.0f;
	
	self.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
	
	return self;
}

@end
