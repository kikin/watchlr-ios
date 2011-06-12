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

@synthesize userImage, userName, userEmail, pushVideosToFacebook;

- (id) init {
	if ((self = [super init])) {
		userDataFile = [[UserDataFile alloc] init];
		sessionId = [userDataFile.userId retain];
		LOG_DEBUG(@"sessionId = %@", sessionId);
	}
	return self;
}

- (void) dealloc {
	[userDataFile release];
	[sessionId release];
	[super dealloc];
}

- (NSString*) sessionId {
	return sessionId;
}

- (void) setSessionId: (NSString*)_sessionId {
	if (sessionId) [sessionId release];
	sessionId = [_sessionId retain];
	
	// save to the file too
	userDataFile.userId = sessionId;
	[userDataFile save];
}

+ (UserObject*) instance {
	return userInstance;
}

+ (UserObject*) getUser {
	if (userInstance == nil) {
		userInstance = [[UserObject alloc] init];
	}
	return userInstance;
}

@end
