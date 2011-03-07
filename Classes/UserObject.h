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
	NSString* userId;
	
}

- (id) init;
- (NSString*) userId;
- (void) setUserId: (NSString*)value;

+ (UserObject*) instance;
+ (UserObject*) getUser;

@property(nonatomic,assign) UserDataFile* userDataFile;

@end
