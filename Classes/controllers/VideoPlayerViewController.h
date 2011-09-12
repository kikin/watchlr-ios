//
//  PlayerViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>
#import "VideoPlayerView.h"
#import "VideoObject.h"

@interface VideoPlayerViewController : UIViewController {
	VideoPlayerView* videoPlayerView;
}

@property(retain) Callback* onVideoFinishedCallback;
@property(retain) Callback* onCloseButtonClickedCallback;
@property(retain) Callback* onPreviousButtonClickedCallback;
@property(retain) Callback* onNextButtonClickedCallback;
@property(retain) Callback* onLikeButtonClickedCallback;
@property(retain) Callback* onUnlikeButtonClickedCallback;
@property(retain) Callback* onSaveButtonClickedCallback;
@property(retain) Callback* onPlaybackErrorCallback;
@property(retain) Callback* onViewSourceClickedCallback;

- (void) playVideo:(VideoObject *)videoObject;
- (void) closePlayer;
- (void) sendAllVideosFinishedMessage:(BOOL)nextButtonClicked;

@end
