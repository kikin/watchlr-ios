//
//  LinkDeviceResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultResponse.h"

@interface LinkDeviceResponse : DefaultResponse {
	NSString* sessionId;
}

- (NSString*) sessionId;
- (id) initWithResponse: (NSDictionary*)jsonObject;

@end
