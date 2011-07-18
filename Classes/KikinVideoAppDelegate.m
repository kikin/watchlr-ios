//
//  KikinVideoAppDelegate.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "KikinVideoAppDelegate.h"
#import "LoginViewController.h"
#import "SavedVideosViewController.h"
#import "LikedVideosViewController.h"
#import "UserObject.h"
#import <CommonIos/DeviceUtils.h>
#import <CommonIos/Callback.h>

@implementation KikinVideoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// create the main window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	window.backgroundColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
	
    // when application starts show the logged view
    // if user is logged in, application will automatically 
    // show the tabbed view.
	LoginViewController* loginViewController = [[[LoginViewController alloc] init] autorelease];
    loginViewController.onLoginSuccessCallback = [Callback create:self selector:@selector(onLoginSuccess)];
	window.rootViewController = loginViewController;
	[window makeKeyAndVisible];
	
    return YES;
}

/*- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    LOG_DEBUG(@"Get called in handleOpen url.");
	LoginViewController* loginViewController = (LoginViewController*)viewController;
    return [loginViewController.facebook handleOpenURL:url]; 
}*/

- (void)applicationWillResignActive:(UIApplication *)application {
	// track the stop time
	if (startDate != nil) {
        if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
            [((KikinVideoViewController*)((UITabBarController*)window.rootViewController).selectedViewController) onApplicationBecomeInactive];
        }
        
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

- (void) onLoginSuccess {
    // create saved videos tab
    SavedVideosViewController* savedVideosViewController = [[[SavedVideosViewController alloc] initWithNibName:@"SavedVideosView" bundle:nil] autorelease];
    UIImage* savedTabImage = [UIImage imageNamed:@"save_video.png"];
    savedVideosViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Saved" image:savedTabImage tag:1] autorelease];
    savedVideosViewController.onLogoutCallback = [Callback create:self selector:@selector(onLogout)];
    
    // create liked videos tab
    LikedVideosViewController* likedVideosViewController = [[[LikedVideosViewController alloc] initWithNibName:@"LikedVideosView" bundle:nil] autorelease];
    UIImage* likedTabImage = [UIImage imageNamed:@"29-heart.png"];
    likedVideosViewController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Liked" image:likedTabImage tag:1] autorelease];
    likedVideosViewController.onLogoutCallback = [Callback create:self selector:@selector(onLogout)];
    
    // create the tabbed view
    UITabBarController* tabBarController = [[[UITabBarController alloc] init] autorelease];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:savedVideosViewController, likedVideosViewController, nil] animated:YES];
    // tabBarController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [tabBarController setSelectedViewController:savedVideosViewController];
    
    // set the tabbed view as the root view
    window.rootViewController = tabBarController;
}



- (void) onLogout {
    // set the login view as the root view.
    LoginViewController* loginViewController = [[[LoginViewController alloc] init] autorelease];
    loginViewController.onLoginSuccessCallback = [Callback create:self selector:@selector(onLoginSuccess)];
	window.rootViewController = loginViewController;
}

- (void)dealloc {
	[startDate release];
    [window release];
    [super dealloc];
}

@end

