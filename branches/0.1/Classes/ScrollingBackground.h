//
//  ScrollingBackground.h
//  NovaRacerBox2d
//
//  Created by Usman Khalid on 5/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface ScrollingBackground : CCSprite {
	CGPoint texOffset;
}

@property(nonatomic, readwrite) CGPoint texOffset;

-(void) draw;

@end
