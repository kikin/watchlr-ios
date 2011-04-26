//
//  GoogleAnalyticsLogger.m
//  KikinIos
//
//  Created by ludovic cabre on 4/15/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "GoogleAnalyticsLogger.h"
#import "GANTracker.h"

@implementation GoogleAnalyticsLogger

// Dispatch period in seconds
static const NSInteger kGANDispatchPeriodSec = 5;

- (id) init {
	if (self = [super init]) {
		[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-4788978-1" dispatchPeriod:kGANDispatchPeriodSec delegate:nil];
	}
	return self;
}

- (void) dealloc {
	[[GANTracker sharedTracker] stopTracker];
	[super dealloc];
}

- (void)log: (int)_level from:(NSString*)_from text:(NSString*)_text {
	// do not log if the level is too low
	if (_level < level) return;
	
	// get the level as a string
	NSString* typeString = [Logger levelToString:_level];
	
	if (_level >= LOGGER_WARN) {
		NSError *error;
		if (![[GANTracker sharedTracker] trackEvent:[typeString lowercaseString] action:_from label:_text value:-1 withError:&error]) {
			NSLog(@"ERROR: failed to track error $@", error);
		}
	}
		
	// log it in the console anyway
	NSString* finalString = [NSString stringWithFormat:@"%@ : %@ > %@", typeString, _from, _text];
	NSLog(@"%@", finalString);
}

- (void)event: (NSString*)type from:(NSString*)from value:(NSString*)value {
	NSError *error;
	if (![[GANTracker sharedTracker] trackEvent:from action:type label:value value:-1 withError:&error]) {
		NSLog(@"ERROR: failed to track event $@", error);
	}
}

@end
