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
	//Adjust the texture matrix 
	glMatrixMode(GL_TEXTURE); 
	
	glPushMatrix(); 
	glLoadIdentity();
	
	glTranslatef( texOffset.x/self.contentSize.width, texOffset.y/self.contentSize.height, 0); 
		
	//Draw the texture 
	glDisableClientState(GL_COLOR_ARRAY);
	[self.texture drawAtPoint:CGPointZero]; 
	glEnableClientState(GL_COLOR_ARRAY);    
		
	//Restore texture matrix and switch back to modelview matrix
	glPopMatrix();
	glMatrixMode(GL_MODELVIEW);
}

-(void) scrollWithVelocity:(CGPoint)velocity collided:(BOOL)collided {
	if (collided==NO) {
		texOffset.x += velocity.x;
		texOffset.y += velocity.y;
	}
	else {
		texOffset.x -= velocity.x;
		texOffset.y -= velocity.y;
	}
}

@end
