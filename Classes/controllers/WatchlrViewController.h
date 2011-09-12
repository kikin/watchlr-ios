//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileSettingsView.h"
#import "UserSettingsView.h"
#import "CommonIos/Callback.h"


/** Video List View Controller. */
@interface WatchlrViewController : UIViewController {
	
}

- (void) onApplicationBecomeInactive;
- (void) onTabInactivate;
- (void) onTabActivate;
- (BOOL) shouldRotate;

@end
