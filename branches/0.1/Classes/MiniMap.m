//
//  MiniMap.m
//  NovaRacerBox2d
//
//  Created by Usman Khalid on 5/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MiniMap.h"


@implementation MiniMap

-(void) draw {
	[super draw];
	glLineWidth(1.0f);
	ccDrawLine(ccp(400, 50), ccp(420, 50));
	glPointSize(1.0f);
	glColor4f(1.0, 0.5, 0, 1);
	//ccDrawPoint(ccp(400, 30));
	ccDrawCircle(ccp(400,30), 2.0f, 0, 10, NO);
}

@end
