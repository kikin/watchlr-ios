//
//  UserDataFile.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserDataFile.h"

@implementation UserDataFile

@synthesize userId, sessionId;

- (id) init {
	if ((self = [super init:@"UserData"])) {
		[self load];
	}
	return self;
}

- (void) dealloc {
	[sessionId release];
	[super dealloc];
}

- (NSDictionary*) load {
	// load data and fill up this object
	NSDictionary* fileData = [super load];
	if (fileData != nil) {
		self.userId = [[fileData objectForKey:@"userId"] intValue];
        self.sessionId = [fileData objectForKey:@"session_id"];
	}
    return fileData;
}

- (void) save {
	// create dictionnary and save it
	NSMutableDictionary* fileData = [[NSMutableDictionary alloc] init];
	if (sessionId != nil) {
		[fileData setObject:[[NSNumber numberWithInt:userId] stringValue] forKey: @"userId"];
        [fileData setObject:sessionId forKey:@"session_id"];
	}
	
    [super save:fileData];
	[fileData release];
}

@end
