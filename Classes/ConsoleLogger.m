//
//  ConsoleLogger.m
//  KikinIos
//
//  Created by ludovic cabre on 4/14/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ConsoleLogger.h"

@implementation ConsoleLogger

- (void)log: (int)_level from:(NSString*)_from text:(NSString*)_text {
	// do not log if the level is too low
	if (_level < level) return;
	
	// get the level as a string
	NSString* typeString = [Logger levelToString:_level];
	NSString* finalString = [NSString stringWithFormat:@"%@ : %@ > %@", typeString, _from, _text];
	
	// log it in the console
	NSLog(@"%@", finalString);
}

- (void)event: (NSString*)type from:(NSString*)from value:(NSString*)value {
	NSString* finalString = [NSString stringWithFormat:@"EVENT : %@:%@:%@", type, from, value];
	
	// log it in the console
	NSLog(@"%@", finalString);
}

@end
