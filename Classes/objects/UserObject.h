//
//  UserObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserDataFile.h"

@interface UserObject : NSObject {
	UserDataFile * userDataFile;
	NSString* sessionId;
    UIImage* userImage;
    NSString* userName;
    NSString* userEmail;
    bool pushVideosToFacebook;
}

- (id) init;
- (NSString*) sessionId;
- (void) setSessionId: (NSString*)_sessionId;

+ (UserObject*) instance;
+ (UserObject*) getUser;

@property(retain) UIImage* userImage;
@property(retain) NSString* userName;
@property(retain) NSString* userEmail;
@property         bool pushVideosToFacebook;

@end
