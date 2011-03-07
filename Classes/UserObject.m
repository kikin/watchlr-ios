//
//  UserObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UserObject.h"
#import "UserDataFile.h"

static UserObject* userInstance = nil;

@implementation UserObject

@synthesize userDataFile;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.userDataFile = [[UserDataFile alloc] init];
		self.userId = userDataFile.userId;
		[userDataFile retain];
	}
	return self;
}

- (void) dealloc
{
	[userDataFile release];
	[super dealloc];
}


- (NSString*) userId {
	return userId;
}

- (void) setUserId: (NSString*)value {
	[userId autorelease];
	userId = [value retain];
	
	// save to the file too
	userDataFile.userId = userId;
	[userDataFile save];
}

+ (UserObject*) instance {
	return userInstance;
}

+ (UserObject*) getUser {
	if (userInstance == nil) {
		userInstance = [[[UserObject alloc] init] retain];
	}
	return userInstance;
}

@end
