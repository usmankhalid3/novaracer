//
//  ScrollingBackground.m
//  NovaRacerBox2d
//
//  Created by Usman Khalid on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScrollingBackground.h"


@implementation ScrollingBackground

@synthesize texOffset;

- (void) draw {
	glEnableClientState( GL_VERTEX_ARRAY); 
	glEnableClientState( GL_TEXTURE_COORD_ARRAY ); 
	glEnable( GL_TEXTURE_2D); 
	//Adjust the texture matrix 
	glMatrixMode(GL_TEXTURE); 
	glPushMatrix(); 
	glLoadIdentity(); 
	//We are just doing horizontal scrolling here so only adjusting x 
	glTranslatef( texOffset.x/self.contentSize.width, texOffset.y/self.contentSize.height, 0); 
	//Draw the texture 
	[self.texture drawAtPoint:CGPointZero]; 
	//Restore texture matrix and switch back to modelview matrix 
	glPopMatrix(); 
	glMatrixMode(GL_MODELVIEW); 
	glColor4ub( 255, 255, 255, 255); 
	glDisable( GL_TEXTURE_2D); 
	glDisableClientState(GL_VERTEX_ARRAY ); 
	glDisableClientState( GL_TEXTURE_COORD_ARRAY ); 	
}



@end
