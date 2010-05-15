//
//  CollisionEffect.m
//  NovaRacerBox2d
//
//  Created by adeel on 5/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CollisionEffect.h"


@implementation CollisionEffect

-(id) initWithTotalParticles:(int)p {
	
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration
	duration = 0.05f;
	
	// gravity
	gravity.x = 0;
	gravity.y = 0;
	
	// angle
	angle = 90;
	angleVar = 360;
	
	// speed of particles
	speed = 30;
	speedVar = 0;
	
	// radial
	radialAccel = 0;
	radialAccelVar = 0;
	
	// tagential
	tangentialAccel = 0;
	tangentialAccelVar = 0;
	
	// emitter position
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	self.position = ccp(winSize.width/2, winSize.height/2);
	posVar = CGPointZero;
	
	// life of particles
	life = 2.0f;
	lifeVar = 0;
	
	// size, in pixels
	startSize = 5.0f;
	startSizeVar = 0;
	endSize = kParticleStartSizeEqualToEndSize;
	
	// emits per second
	emissionRate = totalParticles/duration;
	
	// color of particles
	/*startColor.r = 0.7f;
	startColor.g = 0.1f;
	startColor.b = 0.2f;
	startColor.a = 1.0f;
	startColorVar.r = 0.5f;
	startColorVar.g = 0.5f;
	startColorVar.b = 0.5f;
	startColorVar.a = 0.0f;
	endColor.r = 0.5f;
	endColor.g = 0.5f;
	endColor.b = 0.5f;
	endColor.a = 0.0f;
	endColorVar.r = 0.5f;
	endColorVar.g = 0.5f;
	endColorVar.b = 0.5f;
	endColorVar.a = 0.0f;*/
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
	
	// additive
	blendAdditive = NO;
	
	return self;
}


@end
