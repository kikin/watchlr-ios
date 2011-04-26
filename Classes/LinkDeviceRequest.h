//
//  LinkDeviceRequest.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonRequest.h"
#import "LinkDeviceResponse.h"

@interface LinkDeviceRequest : JsonRequest {
	
}

- (void) doLinkDeviceRequest:(NSString*)facebookId;

@end
