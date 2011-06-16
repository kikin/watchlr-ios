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

- (id) initWithAccount: (NSString*)accountId appName:(NSString*)appName version:(NSString*)version {
    if ((self = [super init])) {
		[[GANTracker sharedTracker] startTrackerWithAccountID:accountId dispatchPeriod:kGANDispatchPeriodSec delegate:nil];
		
		NSError* error;
		// set a custom variable so that we know which app and version it is
		if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1 name:appName value:version withError:&error]) {
			NSLog(@"ERROR: failed to set custom variable %@", error);
		}
	}
	return self;
}

- (void)flush {
	/*@try {
		[[GANTracker sharedTracker] dispatch];
	} @catch (NSException* e) {
		NSLog(@"ERROR: failed to flush data %@", e);
	}*/
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
			NSLog(@"ERROR: failed to track error %@", error);
		}
	}
		
	// log it in the console anyway
	NSString* finalString = [NSString stringWithFormat:@"%@ : %@ > %@", typeString, _from, _text];
	NSLog(@"%@", finalString);
}

- (void)event: (NSString*)type from:(NSString*)from value:(NSString*)value {
	NSError *error;
	if (![[GANTracker sharedTracker] trackEvent:from action:type label:value value:-1 withError:&error]) {
		NSLog(@"ERROR: failed to track event %@ %@ %@ %@", type, from, value, error);
	}
}

@end
