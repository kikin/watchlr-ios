//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "WatchlrViewController.h"
#import "VideoDetailView.h"
#import "VideoObject.h"
#import "VideoPlayerViewController.h"

@interface VideoDetailedViewController: WatchlrViewController {
    VideoDetailView* videoDetailView;
    VideoPlayerViewController* videoPlayerViewController;
    
    bool isActiveTab;
}

- (void) setVideoObject:(VideoObject*)videoObject shouldAllowVideoRemoval:(BOOL)allowVideoRemoval;

@end
