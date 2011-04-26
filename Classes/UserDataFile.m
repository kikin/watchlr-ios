//
//  UserDataFile.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserDataFile.h"

@implementation UserDataFile

@synthesize userId;

- (id) init {
	if (self = [super init:@"UserData"]) {
		[self load];
	}
	return self;
}

- (void) dealloc {
	[userId release];
	[super dealloc];
}

- (void) load {
	// load data and fill up this object
	NSDictionary* fileData = [super load];
	if (fileData != nil) {
		self.userId = [fileData objectForKey:@"userId"];
	}
}

- (void) save {
	// create dictionnary and save it
	NSMutableDictionary* fileData = [[NSMutableDictionary alloc] init];
	if (userId != nil) {
		[fileData setObject:userId forKey: @"userId"];
	}
	[super save:fileData];
	[fileData release];
}

@end
