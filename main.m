//
//  main.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoListRequest.h"
#import "KikinVideoAppDelegate.h"
#import "VideoObject.h"
#import <CommonIos/GoogleAnalyticsLogger.h>
#import <CommonIos/ConsoleLogger.h>

int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// setup the logger
	Logger* logger = nil;
#ifdef RELEASE
	//logger = [[ConsoleLogger alloc] init];
	logger = [[GoogleAnalyticsLogger alloc] initWithAccount:@"UA-4788978-1" appName:@"kikinVideoIos" version:@"v1.0"];
	logger.level = LOGGER_WARN;
#elif DEBUG
	logger = [[ConsoleLogger alloc] init];
	logger.level = LOGGER_TRACE;
#endif
	[Logger setLogger:logger];
	
	// launch application
    int retVal = UIApplicationMain(argc, argv, nil, @"KikinVideoAppDelegate");
	
    [pool release];
    return retVal;
}

