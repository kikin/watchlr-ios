//
//  KikinVideoAppDelegate.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "KikinVideoAppDelegate.h"
#import "LoginViewController.h"
#import "UserObject.h"
#import <CommonIos/DeviceUtils.h>
#import "MostViewedViewController.h"

@implementation KikinVideoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// create the main window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	window.backgroundColor = [UIColor whiteColor];
	
	//UserObject* user = [UserObject getUser];
	//if (user.sessionId != nil) {
	//	// create the list view
	//	viewController = [[MostViewedViewController alloc] init];
	//} else {
		// create the login view
		viewController = [[LoginViewController alloc] init];
	//}
	window.rootViewController = viewController;
	[window makeKeyAndVisible];
	
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	LoginViewController* loginViewController = (LoginViewController*)viewController;
    return [loginViewController.facebook handleOpenURL:url]; 
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// track the stop time
	if (startDate != nil) {
		NSTimeInterval time = [[NSDate date] timeIntervalSinceDate: startDate];
		LOG_EVENT(@"eventStopApp", EVENT_LOCATION_APPLICATION, [NSString stringWithFormat:@"%ld", (int)time]);
	} else {
		LOG_EVENT(@"eventStopApp", EVENT_LOCATION_APPLICATION, @"no_date");
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// update the start date
	[startDate release], startDate = nil;
	startDate = [[NSDate alloc] init];
	
	// track that
	LOG_EVENT(@"eventStartApp", EVENT_LOCATION_APPLICATION);
}

- (void)applicationWillTerminate:(UIApplication *)application {

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	// track if the application receive fatal memory issues
	int level = [DeviceUtils currentMemoryLevel];
	if (level > OSMemoryNotificationLevelWarning) {
		LOG_ERROR(@"memory warning level %ld", level);
	}
}

- (void)dealloc {
	[startDate release];
    [viewController release];
    [window release];
    [super dealloc];
}

@end

