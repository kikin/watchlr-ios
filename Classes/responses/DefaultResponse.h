//
//  DefaultResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 4/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultResponse : NSObject {
	BOOL success;
	NSString* errorMessage;
    int errorCode;
}

@property(retain) NSString*errorMessage;
@property         int errorCode;
@property         BOOL success;

- (id) initWithResponse: (id)jsonObject;

@end
