//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileObject.h"

// User activity object
@interface UserActivityObject : NSObject {
	long                timestamp;
    NSString*           action;
    UserProfileObject*  userProfile;
}

@property()			long timestamp;
@property(retain)	NSString* action;
@property(retain)	UserProfileObject* userProfile;

- (id) initFromDictionnary: (NSDictionary*)data;
- (NSDictionary*) toDictionary;

@end