//
//  LinkDeviceRequest.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LinkDeviceRequest.h"


@implementation LinkDeviceRequest

- (void) doLinkDeviceRequest:(NSString*)token {
	// build params list
	NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
	[params setObject:token forKey:@"token"];
	
	// do request	
	[self doGetRequest:@"http://video.kikin.com/api/enable" params:params];
}

- (void) onRequestSuccess: (id)jsonObject {
	LinkDeviceResponse* response = [[LinkDeviceResponse alloc] initWithResponse:jsonObject];
	[successHandlerObject performSelector:successHandlerSelector withObject:response];
}

- (void) onRequestFailed: (NSString*)errorMessage {
	[errorHandlerObject performSelector:errorHandlerSelector withObject:errorMessage];
}

@end
