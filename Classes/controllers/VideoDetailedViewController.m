    //
//  MostViewedViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoDetailedViewController.h"
#import "UsersViewController.h"
#import "WebViewController.h"

@implementation VideoDetailedViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
    videoDetailView = [[VideoDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    videoDetailView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    videoDetailView.openLikedByUsersListCallback = [Callback create:self selector:@selector(openLikedByUsersList:)];
    videoDetailView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
    videoDetailView.playVideoCallback = [Callback create:self selector:@selector(playVideo:)];
    videoDetailView.closeVideoPlayerCallback = [Callback create:self selector:@selector(closeVideoPlayer)];
    videoDetailView.sendAllVideoFinishedMessageCallback = [Callback create:self selector:@selector(sendAllVideosFinishedMessage:)];
    [self.view addSubview:videoDetailView];
    [self.view sendSubviewToBack:videoDetailView];
}

- (void)didReceiveMemoryWarning {
    if (!isActiveTab) {
        // release memory
        [videoDetailView didReceiveMemoryWarning:true];
        
        // we will not release callbacks 
        // as there is no way to recover them.
        
    } else {
        int level = [DeviceUtils currentMemoryLevel];
        if (level >= OSMemoryNotificationLevelUrgent) {
            [videoDetailView didReceiveMemoryWarning:false];
            
            // we will not release callbacks 
            // as there is no way to recover them.
        }
    }
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    // release memory
    [videoDetailView removeFromSuperview];
	videoDetailView = nil;
    
    if (videoPlayerViewController != nil) {
        [self.navigationController popToViewController:self animated:NO];
        [videoPlayerViewController release];
    }
    
    videoPlayerViewController = nil;
    
    [super dealloc];
}


// --------------------------------------------------------------------------------
//                                  Callbacks
// --------------------------------------------------------------------------------

- (void) onApplicationBecomeActive: (NSNotification*)notification {
//    [self setUserObject:[userProfileView getUserProfile]];
}

- (void) openLikedByUsersList:(NSNumber*)videoId {
    UsersViewController* usersViewController = [[[UsersViewController alloc] init] autorelease];
    [self.navigationController pushViewController:usersViewController animated:YES];
    [usersViewController showLikedByUsersList:[videoId intValue]];
}

- (void) onViewSourceClicked:(NSString*)sourceUrl {
    WebViewController* webViewController = [[[WebViewController alloc] init] autorelease];
    [self.navigationController pushViewController:webViewController animated:YES];
    [webViewController loadUrl:sourceUrl];
    
}

- (void) playVideo:(VideoObject*)video {
    if (videoPlayerViewController == nil) {
        videoPlayerViewController = [[VideoPlayerViewController alloc] init];
        [videoDetailView setVideoPlayerViewControllerCallbacks:videoPlayerViewController];
    }
    
    if (self.modalViewController == nil) {
        
        [self presentModalViewController:videoPlayerViewController animated:NO];
    }
    
    [videoPlayerViewController playVideo:video];
}

- (void) closeVideoPlayer {
    if (videoPlayerViewController != nil) {
        [videoPlayerViewController closePlayer];
    }
}

- (void) sendAllVideosFinishedMessage:(NSNumber*)nextButtonClicked {
    if (videoPlayerViewController != nil) {
        [videoPlayerViewController sendAllVideosFinishedMessage:[nextButtonClicked boolValue]];
    }
}

// --------------------------------------------------------------------------------
//                          Public Functions
// --------------------------------------------------------------------------------

- (void) setVideoObject:(VideoObject *)videoObject shouldAllowVideoRemoval:(BOOL)allowVideoRemoval {
    isActiveTab = true;
    if (videoObject != nil) {
        [videoDetailView setVideoObject:videoObject shouldAllowVideoRemoval:allowVideoRemoval];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) onTabInactivate {
    isActiveTab = false;
//    [userProfileView closePlayer];
}

- (void) onTabActivate {
    isActiveTab = true;
//    if (self == self.navigationController.visibleViewController) {
//        [self setUserObject:[userProfileView getUserProfile]];
//    }
}

- (void) onApplicationBecomeInactive {
    isActiveTab = false;
    [self onTabInactivate];
}

- (BOOL) shouldRotate {
    return NO;
}

@end
