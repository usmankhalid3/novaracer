//
//  MiniMap.h
//  NovaRacerBox2d
//
//  Created by Usman Khalid on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "GameObject.h"


@interface MiniMap : CCLayer {
	CGSize dimensions;
	int xOffset;
	int yOffset;
	NSMutableArray * flagPositions;
	NSMutableArray * planetPositions;
	CGPoint ssPosition;
	CGSize worldSize;
}

-(CGPoint) localizePosition:(CGPoint)position;
-(void) updateSpaceshipPosition:(CGPoint)position;
-(void) drawPositions:(NSArray*)positions; 
-(void) addFlagPositions:(NSArray*)positions;
-(void) addPlanetPositions:(NSArray*)positions;
-(void) addPositions:(NSMutableArray*)source positions:(NSArray*)positions ofType:(int)t;
-(void) addPosition:(NSMutableArray*)positions pos:(CGPoint)pos;
-(void) addSpaceshipPosition:(CGPoint)position;
-(void) initForWorldOfSize:(CGSize)size;
-(NSArray*) getObjectPositions:(NSArray*)pos ofType:(int) t; 

@end
