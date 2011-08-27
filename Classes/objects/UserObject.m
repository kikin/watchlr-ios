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

@synthesize userImage, userName, userEmail, pushVideosToFacebook, userId, sessionId;

- (id) init {
	if ((self = [super init])) {
		userDataFile = [[UserDataFile alloc] init];
		self.sessionId = userDataFile.sessionId;
        self.userId = userDataFile.userId;
		// LOG_DEBUG(@"sessionId = %@", sessionId);
	}
	return self;
}

- (void) dealloc {
    [userName release];
    [userImage release];
    [userEmail release];
    
	[userDataFile release];
	[sessionId release];
    
    sessionId = nil;
    userId = 0;
    userName = nil;
    userEmail = nil;
    userImage = nil;
    userDataFile = nil;
    
	[super dealloc];
}

- (void) saveUserProfile {
    // save to the file too
	userDataFile.sessionId = sessionId;
    userDataFile.userId = userId;
	[userDataFile save];
}

- (void) resetUser {
    if (sessionId) 
        [sessionId release];
    
    if (userName)
        [userName release];
    
    if (userEmail) 
        [userEmail release];
    
    if (userImage) 
        [userImage release];
    
    sessionId = nil;
    userId = 0;
    userName = nil;
    userEmail = nil;
    userImage = nil;
    
    userDataFile.sessionId = nil;
    userDataFile.userId = 0;
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
