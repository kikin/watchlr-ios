//
//  Logger.m
//  KikinIos
//
//  Created by ludovic cabre on 4/14/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "Logger.h"
#import <stdarg.h>

@implementation Logger

@synthesize level;

static Logger* logger;

+ (void)setLogger: (Logger*) instance {
	logger = [instance retain];
}

+ (NSString*)locationToString:(int)location {
	switch (location) {
		case LOGGER_LOCATION_POPOVER_VIDEOS:
			return @"popoverVideos";
		case LOGGER_LOCATION_POPOVER_IMAGES:
			return @"popoverImages";
		case LOGGER_LOCATION_TOP_BAR:
			return @"topBar";
		case LOGGER_LOCATION_POPOVER_SUGGESTIONS:
			return @"popoverSuggestions";
		case LOGGER_LOCATION_POPOVER_SAVE:
			return @"popoverSave";
		case LOGGER_LOCATION_POPOVER_SAVED_URLS:
			return @"popoverSavedUrls";
		case LOGGER_LOCATION_HOME:
			return @"home";
		case LOGGER_LOCATION_POPOVER_SHARE:
			return @"popoverShare";
		case LOGGER_LOCATION_POPOVER_MORE_CONTENT:
			return @"popoverMoreContent";
		case LOGGER_LOCATION_APP:
			return @"application";
		case LOGGER_LOCATION_SEARCH_TOOLBAR:
			return @"searchToolbar";
		default:
			return @"unknownLocation";
	}
}

+ (NSString*)levelToString:(int)level {
	switch (level) {
		case LOGGER_TRACE:
			return @"TRACE";
		case LOGGER_DEBUG:
			return @"DEBUG";
		case LOGGER_INFO:
			return @"INFO";
		case LOGGER_WARN:
			return @"WARN";
		case LOGGER_ERROR:
			return @"ERROR";
		case LOGGER_FATAL:
			return @"FATAL";
		default:
			return @"UNKWN";
	}
}

+ (void)event: (NSString*)type location:(int)location, ... {
	NSString* value = nil;
	id currentObject = nil;
	
	// get the options parameters
    va_list args;
    va_start(args, location);
	for (int i=0; currentObject = va_arg(args, id); i++) {
		if (i == 0) {
			value = currentObject;
		}
	}
    va_end(args);
	
	NSString* locationString = [self locationToString:location];
	
	[self event:type from:locationString value:value];
}

+ (void)event: (NSString*)type from:(NSString*)from value:(NSString*)value {
	if (logger == nil) return;
	
	[logger event:type from:from value:value];
}

+ (void)log: (int)level from:(const char*)from format:(NSString*)format, ... {
	if (logger == nil) return;
	
	// do not log if the level is too low
	if (level < logger.level) return;
	
	// format the message
    va_list args;
    va_start(args, format);
    NSString* formatted = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
	
	// call the logger
	[logger log:level from:[NSString stringWithUTF8String:from] text:formatted];
	
	// release memory
	[formatted release];	
}

@end
