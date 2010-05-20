//
//  TimeLabel.h
//  NovaRacerBox2d
//
//  Created by adeel on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface TimeLabel : NSObject {
	NSDate * startTime;
	CCLabel * label;
}

-(void) updateTime;
-(NSArray*) getContent;

@end
