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
#import "ActivityViewController.h"
#import "ProfileViewController.h"
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    LOG_DEBUG(@"Get called in handleOpen url.");
	LoginViewController* loginViewController = (LoginViewController*)window.rootViewController;
    return [loginViewController.facebook handleOpenURL:url]; 
}

/*- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    LOG_DEBUG(@"Get called in handleOpen url.");
	LoginViewController* loginViewController = (LoginViewController*)window.rootViewController;
    return [loginViewController.facebook handleOpenURL:url]; 
}*/

- (void)applicationWillResignActive:(UIApplication *)application {
	// track the stop time
	if (startDate != nil) {
        if ([window.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController* tabBarController = (UITabBarController*)window.rootViewController;
            UINavigationController* navigationController = (UINavigationController*)tabBarController.selectedViewController;
            WatchlrViewController* watchlrController = (WatchlrViewController*)navigationController.topViewController;
            [watchlrController onApplicationBecomeInactive];
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
    savedVideosViewController.onLogoutCallback = [Callback create:self selector:@selector(onLogout)];
    
    UINavigationController * savedTabNavigationController = [[[UINavigationController alloc] initWithRootViewController:savedVideosViewController] autorelease];
    savedTabNavigationController.navigationBar.tintColor =[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
    UIImage* savedTabImage = [UIImage imageNamed:@"save_video.png"];
    savedTabNavigationController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Saved" image:savedTabImage tag:1] autorelease];
    
    // create liked videos tab
    LikedVideosViewController* likedVideosViewController = [[[LikedVideosViewController alloc] initWithNibName:@"LikedVideosView" bundle:nil] autorelease];
    likedVideosViewController.onLogoutCallback = [Callback create:self selector:@selector(onLogout)];
    
    UINavigationController * likedTabNavigationController = [[[UINavigationController alloc] initWithRootViewController:likedVideosViewController] autorelease];
    likedTabNavigationController.navigationBar.tintColor =[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
    UIImage* likedTabImage = [UIImage imageNamed:@"29-heart.png"];
    likedTabNavigationController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Liked" image:likedTabImage tag:1] autorelease];
    
    // create activity videos tab
    ActivityViewController* activitiesViewController = [[[ActivityViewController alloc] initWithNibName:@"ActivitiesView" bundle:nil] autorelease];
    activitiesViewController.onLogoutCallback = [Callback create:self selector:@selector(onLogout)];
    
    UINavigationController * activitiesTabNavigationController = [[[UINavigationController alloc] initWithRootViewController:activitiesViewController] autorelease];
    activitiesTabNavigationController.navigationBar.tintColor =[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
    UIImage* activityTabImage = [UIImage imageNamed:@"77-ekg.png"];
    activitiesTabNavigationController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"Activity" image:activityTabImage tag:1] autorelease];
    
    // create user profile tab
    ProfileViewController* profileViewController = [[[ProfileViewController alloc] initWithNibName:@"ProfileView" bundle:nil] autorelease];
    profileViewController.onLogoutCallback = [Callback create:self selector:@selector(onLogout)];
    
    UINavigationController * profileTabNavigationController = [[[UINavigationController alloc] initWithRootViewController:profileViewController] autorelease];
    profileTabNavigationController.navigationBar.tintColor =[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
    UIImage* profileTabImage = [UIImage imageNamed:@"111-user.png"];
    profileTabNavigationController.tabBarItem = [[[UITabBarItem alloc] initWithTitle:@"My Profile" image:profileTabImage tag:1] autorelease];
                                                                                                 
    // create the tabbed view
    UITabBarController* tabBarController = [[[UITabBarController alloc] init] autorelease];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:activitiesTabNavigationController, savedTabNavigationController, likedTabNavigationController, profileTabNavigationController, nil] animated:YES];
    // tabBarController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [tabBarController setSelectedViewController:activitiesTabNavigationController];
    
    tabBarController.delegate = self;
    
    // set the tabbed view as the root view
    window.rootViewController = tabBarController;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // perform the actions only when user selects the different tab.
    if (viewController != tabBarController.selectedViewController) {
        
        WatchlrViewController* currentViewController = (WatchlrViewController*)((UINavigationController*)tabBarController.selectedViewController).topViewController;
        WatchlrViewController* nextViewController = (WatchlrViewController*)((UINavigationController*)viewController).topViewController;
        
        [currentViewController onTabInactivate];
        [nextViewController onTabActivate];
    }
    
    return YES;
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

