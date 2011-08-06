//
//  ConnectMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "VideoObject.h"
#import "VideoRequest.h"
#import "VideoResponse.h"
#import "SeekVideoRequest.h"

@interface VideoPlayerView : UIView<UIGestureRecognizerDelegate> {
    UIView* moviePlayer;
    UIButton *closeButton;
    UILabel* titleLabel;
    UIView* topSeparator;
    UIButton* likeButton;
    UIButton* saveButton;
    // UIView* faviconBackground;
    UIImageView* favicon;
    UILabel* description;
    UIView* bottomSeparator;
    
    UIButton* prevButton;
    UIButton* nextButton;
    
    MPMoviePlayerController *moviePlayerController;
    UIActivityIndicatorView* loadingActivity;
    UILabel* countdown;
    UILabel* errorMessage;
    
    UIView* fullScreenModeView;
    UIActivityIndicatorView* fullScreenLoadingActivity;
    UILabel* fullScreenCountdown;
    UILabel* fullScreenErrorMessage;

    // UIView* moviePlayerNativeControlView;
    // UIView* videosListView;
    
    VideoObject* video;
    SeekVideoRequest* seekRequest;
    
    Callback* onVideoFinishedCallback;
    Callback* onCloseButtonClickedCallback;
    Callback* onPreviousButtonClickedCallback;
    Callback* onNextButtonClickedCallback;
    Callback* onLikeButtonClickedCallback;
    Callback* onUnlikeButtonClickedCallback;
    Callback* onSaveButtonClickedCallback;
    Callback* onPlaybackErrorCallback;
    
    bool isVimeoVideo;
    bool isYoutubeVideo;
    bool areControlsVisible;
    bool isLeanBackMode;
    bool hasUserInitiatedVideoFinished;
    bool isFullScreenMode;
    bool shouldPlayVideo;
    
    NSString* currentlyPlayingVideoUrl;
}

@property(retain) VideoObject* video;
@property(retain) Callback* onVideoFinishedCallback;
@property(retain) Callback* onCloseButtonClickedCallback;
@property(retain) Callback* onPreviousButtonClickedCallback;
@property(retain) Callback* onNextButtonClickedCallback;
@property(retain) Callback* onLikeButtonClickedCallback;
@property(retain) Callback* onUnlikeButtonClickedCallback;
@property(retain) Callback* onSaveButtonClickedCallback;
@property(retain) Callback* onPlaybackErrorCallback;

- (void) playVideo:(VideoObject*) videoObject;
- (void) onVideoRequestFailed:(NSString*) errorMessage;
- (void) onVideoRequestSuccess:(VideoResponse*) aResponse;
- (void) closePlayer;
- (void) onAllVideosPlayed;

@end
