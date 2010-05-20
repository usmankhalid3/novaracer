//
//  TimeLabel.m
//  NovaRacerBox2d
//
//  Created by adeel on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TimeLabel.h"


@implementation TimeLabel

-(id) init {

	if ((self = [super init])) {
		startTime = [[NSDate date] retain];
		label = [CCLabel labelWithString:@"00:00" fontName:@"Arial" fontSize:20];
		[label setPosition:CGPointMake(240, 300)];
	}
	return self;
}

-(NSArray*) getContent {
	NSArray * array = [[NSArray alloc] initWithObjects:label, nil];
	[array autorelease];
	return array;
}

-(void) updateTime {
	int seconds = ((int)(-1*[startTime timeIntervalSinceNow]));
	int minutes = seconds / 60;
	seconds %= 60;
	NSString * strMinutes;
	NSString * strSeconds;
	if (minutes < 10) {
		strMinutes = [NSString stringWithFormat:@"0%d", minutes];
	}
	else {
		strMinutes = [NSString stringWithFormat:@"%d", minutes];
	}
	if (seconds < 10) {
		strSeconds = [NSString stringWithFormat:@"0%d", seconds];
	}
	else {
		strSeconds = [NSString stringWithFormat:@"%d", seconds];
	}
	
	[label setString:[NSString stringWithFormat:@"%@:%@", strMinutes, strSeconds]];
}

-(NSString*) timeToString {
	int seconds = ((int)(-1*[startTime timeIntervalSinceNow]));
	int minutes = seconds / 60;
	seconds %= 60;
	NSString * strMinutes;
	NSString * strSeconds;
	if (minutes < 10) {
		strMinutes = [NSString stringWithFormat:@"0%d", minutes];
	}
	else {
		strMinutes = [NSString stringWithFormat:@"%d", minutes];
	}
	if (seconds < 10) {
		strSeconds = [NSString stringWithFormat:@"0%d", seconds];
	}
	else {
		strSeconds = [NSString stringWithFormat:@"%d", seconds];
	}
	NSString * timeString = [NSString stringWithFormat:@"%d minutes and %d seconds", minutes, seconds];
	[timeString autorelease];
	return timeString;
}

-(void) dealloc {
	[startTime release];
	[super dealloc];
}

@end
