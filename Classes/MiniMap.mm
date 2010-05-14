//
//  MiniMap.m
//  NovaRacerBox2d
//
//  Created by Usman Khalid on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MiniMap.h"

@implementation MiniMap

typedef enum objectTypes {
	kSpaceShip = 1,
	kPlanet,
	kFlag
} SpaceObjectType;

-(void) initForWorldOfSize:(CGSize) size {
	flagPositions = [[NSMutableArray alloc] init];
	planetPositions = [[NSMutableArray alloc] init];
	dimensions.width = 80;
	dimensions.height = 60;
	xOffset = 380;
	yOffset = 25;
	worldSize = size;
}

-(void) draw {
	[super draw];
	glLineWidth(1.0f);
	glPointSize(5.0f);
	glColor4f(0.84, 0.1, 0.56, 1.0);
	[self drawPositions:flagPositions];
	glColor4f(0.12, 0.14, 0.91, 1.0);
	[self drawPositions:planetPositions];
	glColor4f(1, 1, 1, 1.0);
	ccDrawPoint(ssPosition);
}

-(void) drawPositions:(NSArray*)positions {
	int size = [positions count];
	NSValue * pos1 = nil;
	NSValue * pos2 = nil;
	if (positions!=nil && size > 0) {
		for (int i=0; i< size; i++) {
			pos2 = (NSValue*)[positions objectAtIndex:i];
			ccDrawPoint([pos2 CGPointValue]);
			//ccDrawCircle([pos2 CGPointValue], 2.5f, 0, 10, NO);
			if (i > 0 && (i!=8)) {
				pos1 = (NSValue*)[positions objectAtIndex:(i-1)];
				ccDrawLine([pos1 CGPointValue], [pos2 CGPointValue]);
			}
		}
		pos1 = (NSValue*)[positions objectAtIndex:0];
		pos2 = (NSValue*)[positions objectAtIndex:7];
		ccDrawLine([pos1 CGPointValue], [pos2 CGPointValue]);
		if (size > 8) {
			pos1 = (NSValue*)[positions objectAtIndex:8];
			pos2 = (NSValue*)[positions objectAtIndex:size-1];
			ccDrawLine([pos1 CGPointValue], [pos2 CGPointValue]);
		}
	}
}

NSComparisonResult compareGameObjects(id gObject1, id gObject2, void * context) {
	GameObject * object1 = (GameObject*) gObject1;
	GameObject * object2 = (GameObject*) gObject2;
	if ([object1 positionIndex] < [object2 positionIndex]) {
		return NSOrderedAscending;
	}
	else if ([object1 positionIndex] > [object2 positionIndex]) {
		return NSOrderedDescending;
	}
	return NSOrderedSame;
}

-(NSArray*) getObjectPositions:(NSArray*)pos ofType:(int) t {
	int size = [pos count];
	NSMutableArray * array = [[[NSMutableArray alloc] init] autorelease];
	for (int i=0; i< size; i++) {
		GameObject * obj = [pos objectAtIndex:i];
		if ([obj sprite].tag == t) {
			[array addObject:obj];
		}
	}
	return array;
}

-(CGPoint) localizePosition:(CGPoint)position {
	position.x = ((position.x / worldSize.width) * dimensions.width) + xOffset;
	position.y = ((position.y / worldSize.height) * dimensions.height) + yOffset;
	return position;
}

-(void) addSpaceshipPosition:(CGPoint)position {
	ssPosition = [self localizePosition:position];
}

-(void) addFlagPositions:(NSArray*) positions {
	[self addPositions:flagPositions positions:positions ofType:kFlag];
}

-(void) addPlanetPositions:(NSArray*) positions {
	[self addPositions:planetPositions positions:positions ofType:kPlanet];
}

-(void) addPositions:(NSMutableArray*) source positions:(NSArray*) positions ofType:(int)t {
	NSArray * sortedPositions = [[self getObjectPositions:positions ofType:t] sortedArrayUsingFunction:compareGameObjects context:NULL];
	int size = [sortedPositions count];
	for (int i=0; i< size; i++) {
		GameObject * obj = (GameObject*)[sortedPositions objectAtIndex:i];
		[self addPosition:source pos:[obj worldPosition]];
	}	
}

-(void) addPosition:(NSMutableArray*)positions pos:(CGPoint)pos {
	[positions addObject:[NSValue valueWithCGPoint:[self localizePosition:pos]]];
}

-(void) updateSpaceshipPosition:(CGPoint)position {
	ssPosition = [self localizePosition:position];
}

-(void) dealloc {	
	[flagPositions dealloc];
	[planetPositions dealloc];
	[super dealloc];
}

@end
