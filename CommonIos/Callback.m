//
//  Callback.m
//  KikinIos
//
//  Created by ludovic cabre on 4/4/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "Callback.h"

@implementation Callback

@synthesize handlerObject, handlerSelector;

- (id) init: (id)object selector:(SEL)selector {
	if ((self = [super init])) {
		self.handlerObject = object;
		self.handlerSelector = selector;
	}
	return self;
}

- (void) dealloc {
	self.handlerObject = nil;
	self.handlerSelector = nil;
	[super dealloc];
}

- (id) execute: (id)parameter {
	return [handlerObject performSelector:handlerSelector withObject:parameter];
}

+ (id) create: (id)object selector:(SEL)selector {
	Callback* callback = [[[Callback alloc] init:object selector:selector] autorelease];
	return callback;
}

@end
