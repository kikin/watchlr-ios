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
	self = [super init:@"UserData"];
	if (self) {
		[self load];
	}
	return self;
}

- (void) dealloc
{
	[userId release];
	[super dealloc];
}


- (void) load {
	// load data and fill up this object
	NSDictionary* fileData = [super load];
	if (fileData != nil) {
		userId = [[[fileData objectForKey:@"userId"] copy] retain];
	}
}

- (void) save {
	// create dictionnary and save it
	NSMutableDictionary* fileData = [[NSMutableDictionary alloc] init];
	if (self.userId != nil) {
		[fileData setObject: [self.userId copy] forKey: @"userId"];
	}
	[super save:fileData];
}

@end
