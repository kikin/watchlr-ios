//
//  LinkDeviceResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LinkDeviceResponse.h"


@implementation LinkDeviceResponse

@synthesize userId;

- (id) initWithResponse: (id)jsonObject {
	// get data
	userId = jsonObject;
	return self;
}

@end
