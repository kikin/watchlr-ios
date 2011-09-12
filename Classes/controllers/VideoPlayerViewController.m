    //
//  PlayerViewController.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoPlayerViewController.h"

@implementation VideoPlayerViewController

@synthesize onVideoFinishedCallback, onCloseButtonClickedCallback, onLikeButtonClickedCallback, onUnlikeButtonClickedCallback, onPreviousButtonClickedCallback, onNextButtonClickedCallback, onSaveButtonClickedCallback, onPlaybackErrorCallback, onViewSourceClickedCallback;

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
    
    videoPlayerView = [[VideoPlayerView alloc] init];
    videoPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    videoPlayerView.hidden = YES;
    videoPlayerView.onCloseButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerCloseButtonClicked)];
    videoPlayerView.onNextButtonClickedCallback = onNextButtonClickedCallback;
    videoPlayerView.onPreviousButtonClickedCallback = onPreviousButtonClickedCallback;
    videoPlayerView.onVideoFinishedCallback = onVideoFinishedCallback;
    videoPlayerView.onPlaybackErrorCallback = onPlaybackErrorCallback;
    videoPlayerView.onLikeButtonClickedCallback = onLikeButtonClickedCallback;
    videoPlayerView.onUnlikeButtonClickedCallback = onUnlikeButtonClickedCallback;
    videoPlayerView.onSaveButtonClickedCallback = onSaveButtonClickedCallback;
    videoPlayerView.onViewSourceClickedCallback = onViewSourceClickedCallback;
    videoPlayerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:videoPlayerView];
}

- (void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (void) dealloc {
    [videoPlayerView removeFromSuperview];
    [videoPlayerView release];
    videoPlayerView = nil;
    
    [onVideoFinishedCallback release];
    [onCloseButtonClickedCallback release];
    [onLikeButtonClickedCallback release];
    [onUnlikeButtonClickedCallback release];
    [onPreviousButtonClickedCallback release];
    [onNextButtonClickedCallback release];
    [onSaveButtonClickedCallback release];
    [onPlaybackErrorCallback release];
    [onViewSourceClickedCallback release];
    
    onVideoFinishedCallback = nil;
    onCloseButtonClickedCallback = nil;
    onLikeButtonClickedCallback = nil;
    onUnlikeButtonClickedCallback = nil;
    onPreviousButtonClickedCallback = nil;
    onNextButtonClickedCallback = nil;
    onSaveButtonClickedCallback = nil;
    onPlaybackErrorCallback = nil;
    onViewSourceClickedCallback = nil;
    
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                      Video Player Callback functions
// --------------------------------------------------------------------------------

- (void) onVideoPlayerCloseButtonClicked {
    videoPlayerView.hidden = YES;
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:NO];
//    if (onCloseButtonClickedCallback != nil) {
//        [onCloseButtonClickedCallback execute:nil];
//    }
}

// --------------------------------------------------------------------------------
//                      Video Player functions
// --------------------------------------------------------------------------------

- (void) playVideo:(VideoObject *)videoObject {
    if (videoObject != nil) {
        [videoPlayerView playVideo:videoObject];
    }
}

- (void) closePlayer {
    [videoPlayerView closePlayer];
}

- (void) sendAllVideosFinishedMessage:(BOOL)nextButtonClicked {
    [videoPlayerView onAllVideosPlayed:nextButtonClicked];
}

@end
