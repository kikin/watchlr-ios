//
//  UserObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDataFile.h"

@interface UserObject : NSObject {
	UserDataFile * userDataFile;
	NSString* sessionId;
}

- (id) init;
- (NSString*) sessionId;
- (void) setSessionId: (NSString*)_sessionId;

+ (UserObject*) instance;
+ (UserObject*) getUser;

@end
