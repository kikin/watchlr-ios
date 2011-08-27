//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoPlayerView.h"
#import "SourceObject.h"
#import <QuartzCore/QuartzCore.h>
#import "VideoRequest.h"
#import "VideoResponse.h"
#import "GetRequest.h"
#import "GetResponse.h"

@implementation VideoPlayerView

@synthesize video, onVideoFinishedCallback, onCloseButtonClickedCallback, onLikeButtonClickedCallback, onUnlikeButtonClickedCallback, onPreviousButtonClickedCallback, onNextButtonClickedCallback, onSaveButtonClickedCallback, onPlaybackErrorCallback, onViewSourceClickedCallback, isFullScreenMode;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {

        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        self.autoresizesSubviews = YES;
        
        // LOG_DEBUG(@"Frame coordinates: %f, %f, %f, %f", frame.size.width, frame.size.height, frame.origin.x, frame.origin.y);
        moviePlayer = [[UIView alloc] initWithFrame:CGRectMake((frame.size.width - 580)/2, (frame.size.height - 365)/ 2, 580, 365)];
        moviePlayer.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        moviePlayer.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
        moviePlayer.autoresizesSubviews = YES;
        moviePlayer.layer.shadowRadius = 5.0f;
        moviePlayer.layer.shadowOpacity = 0.5;
        moviePlayer.layer.shadowOffset = CGSizeMake(15, 20);
        moviePlayer.layer.cornerRadius = 10.0f;
        [self addSubview:moviePlayer];
        
        // create the close button
        closeButton = [[UIButton alloc] init];
        [closeButton setImage:[UIImage imageNamed:@"closeX.png"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(onCloseButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [moviePlayer addSubview:closeButton];
        
        // create the title label
        titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:20];
        titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        titleLabel.numberOfLines = 1;
        [moviePlayer addSubview:titleLabel];
        
        // create the top separator
        topSeparator = [[UIView alloc] init];
        topSeparator.backgroundColor = [UIColor blackColor];
        topSeparator.layer.shadowRadius = 5.0f;
        topSeparator.layer.shadowColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.15].CGColor;
        topSeparator.layer.shadowOpacity = 1.0;
        topSeparator.layer.shadowOffset = CGSizeMake(10, 10);
        [moviePlayer addSubview:topSeparator];
        
        // create the favicon background
        //faviconBackground = [[UIView alloc] init];
        // faviconBackground.backgroundColor = [UIColor whiteColor];
        // [moviePlayer addSubview:faviconBackground];
        
        // create the favicon
        favicon = [[UIImageView alloc] init];
        [favicon setBackgroundColor:[UIColor clearColor]];
		[moviePlayer addSubview:favicon];
        
        // create the description label
        description = [[UILabel alloc] init];
        description.backgroundColor = [UIColor clearColor];
        description.textColor = [UIColor whiteColor];
        description.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        description.font = [UIFont systemFontOfSize:12];
        description.lineBreakMode = UILineBreakModeCharacterWrap | UILineBreakModeTailTruncation;
        description.textAlignment = UITextAlignmentLeft;
        //description.baselineAdjustment = UIBaselineAdjustmentNone;
        description.numberOfLines = 2;
        [moviePlayer addSubview:description];
        
        // create the like button
        likeButton = [[UIButton alloc] init];
        [likeButton addTarget:self action:@selector(onLikeButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [moviePlayer addSubview:likeButton];
        
        // create the save button
        saveButton = [[UIButton alloc] init];
        [saveButton addTarget:self action:@selector(onSaveButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [saveButton setImage:[UIImage imageNamed:@"save_video.png"] forState:UIControlStateNormal];
        [moviePlayer addSubview:saveButton];
        
        // create the bottom separator
        bottomSeparator = [[UIView alloc] init];
        bottomSeparator.backgroundColor = [UIColor blackColor];
        [moviePlayer addSubview:bottomSeparator];
        
        // create the previous button
        prevButton = [[UIButton alloc] init];
        [prevButton addTarget:self action:@selector(onPreviousButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [prevButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
        prevButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
        prevButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [self addSubview:prevButton];
        
        // create the next button
        nextButton = [[UIButton alloc] init];
        [nextButton addTarget:self action:@selector(onNextButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [nextButton setImage:[UIImage imageNamed:@"fwd_arrow.png"] forState:UIControlStateNormal];
        nextButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        nextButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
        [self addSubview:nextButton];
        
        // create the movie player
        moviePlayerController = [[MPMoviePlayerController alloc] init];
        // moviePlayerController.shouldAutoplay = TRUE;
        if([moviePlayerController respondsToSelector:@selector(setAllowsAirPlay:)])
        {
            [moviePlayerController setAllowsAirPlay:YES];
        }
        
        // moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
        // moviePlayerController.controlStyle = MPMovieControlStyleEmbedded;
        // moviePlayerController.repeatMode = NO;
        moviePlayerController.view.autoresizesSubviews = YES;
        [moviePlayer addSubview:moviePlayerController.view];
        // moviePlayerNativeControlView = nil;
        
        // create the video list
        // videosListView = [[UIView alloc] init];
        // videosListView.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:1.0];
        // [self addSubview:videosListView];
        
        // add the tap recognizer to movie player view
        UITapGestureRecognizer* tapGesture = [[[UITapGestureRecognizer alloc] init] autorelease];
        [tapGesture setNumberOfTapsRequired:1];
        [tapGesture setNumberOfTouchesRequired:1];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(handleSwipeLeft:)];
        
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [[moviePlayerController view] addGestureRecognizer:swipeLeft];
        [swipeLeft release];
        
        // Swipe Right
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                                initWithTarget:self action:@selector(handleSwipeRight:)];
        
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [[moviePlayerController view] addGestureRecognizer:swipeRight];
        [swipeRight release];
        
        // add the loading view to movie player
        loadingActivity = [[UIActivityIndicatorView alloc] init];
        loadingActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [loadingActivity setHidesWhenStopped:YES];
        [moviePlayerController.view addSubview:loadingActivity];
        [moviePlayerController.view bringSubviewToFront:loadingActivity];
        
        // add the countdown to loading activity
        countdown = [[UILabel alloc] init];
        countdown.textColor = [UIColor whiteColor];
        countdown.backgroundColor = [UIColor clearColor];
        countdown.font = [UIFont systemFontOfSize:25];
        countdown.textAlignment = UITextAlignmentCenter;
        countdown.numberOfLines = 1;
        countdown.hidden = YES;
        [loadingActivity addSubview:countdown];
        
        // add the error message to movie player
        errorMessage = [[UILabel alloc] init];
        errorMessage.text = @"We could not play this video.";
        errorMessage.textColor = [UIColor whiteColor];
        errorMessage.backgroundColor = [UIColor clearColor];
        errorMessage.font = [UIFont systemFontOfSize:20];
        errorMessage.textAlignment = UITextAlignmentCenter;
        errorMessage.numberOfLines = 1;
        errorMessage.hidden = YES;
        [moviePlayerController.view addSubview:errorMessage];
        
        // add the watch here link to movie player
        watchHereButton = [[UIButton alloc] init];
        [watchHereButton addTarget:self action:@selector(onViewSourceClicked) forControlEvents:UIControlEventTouchDown];
        [watchHereButton setTitle:@"Watch here" forState:UIControlStateNormal];
        [watchHereButton setTitleColor:[UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0] forState:UIControlStateNormal];
        watchHereButton.backgroundColor = [UIColor clearColor];
        watchHereButton.titleLabel.font = [UIFont systemFontOfSize:20];
        watchHereButton.hidden = YES;
        [moviePlayerController.view addSubview:watchHereButton];
        
        // add the "nect video will play in" message to movie player
        nextVideoWillPlayInMessage = [[UILabel alloc] init];
        nextVideoWillPlayInMessage.text = @"Your next video will play in";
        nextVideoWillPlayInMessage.textColor = [UIColor whiteColor];
        nextVideoWillPlayInMessage.backgroundColor = [UIColor clearColor];
        nextVideoWillPlayInMessage.font = [UIFont systemFontOfSize:20];
        nextVideoWillPlayInMessage.textAlignment = UITextAlignmentCenter;
        nextVideoWillPlayInMessage.numberOfLines = 1;
        nextVideoWillPlayInMessage.hidden = YES;
        [moviePlayerController.view addSubview:nextVideoWillPlayInMessage];
        
        // listen for events from movie player
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVideoFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVideoLoadingStateChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:moviePlayerController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVideoPlaybackStateChanged:) name: MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayerController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFullScreenMode:) name: MPMoviePlayerDidEnterFullscreenNotification object:moviePlayerController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullScreenMode:) name: MPMoviePlayerWillExitFullscreenNotification object:moviePlayerController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEmbededMode:) name: MPMoviePlayerDidExitFullscreenNotification object:moviePlayerController];
        
        // LOG_DEBUG(@"Reinitializing video player.");
        isLeanBackMode = false;
        isFullScreenMode = false;
    }
    return self;
}

/*
 * Override layout sub views to render custom controls properly.
 */
 
- (void) layoutSubviews {
    [super layoutSubviews];
    if (!DeviceUtils.isIphone && !isFullScreenMode) {
        moviePlayer.frame = CGRectMake((self.frame.size.width - 580)/2, (self.frame.size.height - 435)/ 2, 580, 435);
        closeButton.frame = CGRectMake(moviePlayer.frame.size.width - 37, 4, 32, 32);
        titleLabel.frame = CGRectMake(10, 0, moviePlayer.frame.size.width - 47, 40);
        topSeparator.frame = CGRectMake(0, 40, moviePlayer.frame.size.width, 1);
        // faviconBackground.frame = CGRectMake(0, moviePlayer.frame.size.height - 40, 40, 40);
        favicon.frame = CGRectMake(10, moviePlayer.frame.size.height - 40, 20, 20);
        likeButton.frame = CGRectMake(moviePlayer.frame.size.width - 35, moviePlayer.frame.size.height - 42, 25, 25);
        saveButton.frame = CGRectMake(moviePlayer.frame.size.width - 70, moviePlayer.frame.size.height - 42, 25, 25);
        description.frame = CGRectMake(50, moviePlayer.frame.size.height - 45, 
                                       (moviePlayer.frame.size.width - (/*faviconBackground.frame.size.width*/40 + likeButton.frame.size.width + saveButton.frame.size.width + 40)), 
                                       30);
        bottomSeparator.frame = CGRectMake(0, moviePlayer.frame.size.height - 50, moviePlayer.frame.size.width, 1);
        
        prevButton.frame = CGRectMake(moviePlayer.frame.origin.x - 37, ((moviePlayer.frame.size.height - 63) / 2) + moviePlayer.frame.origin.y, 37, 63);
        nextButton.frame = CGRectMake(moviePlayer.frame.origin.x + moviePlayer.frame.size.width, ((moviePlayer.frame.size.height - 63) / 2) + moviePlayer.frame.origin.y, 37, 63);
        
        moviePlayerController.view.frame = CGRectMake(10, 50, moviePlayer.frame.size.width - 20, moviePlayer.frame.size.height - 110);
        
        
        int errorMessageHeight = [errorMessage.text sizeWithFont:errorMessage.font].height;
        errorMessage.frame = CGRectMake(0, 20, moviePlayerController.view.frame.size.width, errorMessageHeight);
        
        int watchHereLabelHeight = [watchHereButton.titleLabel.text sizeWithFont:watchHereButton.titleLabel.font].height;
        watchHereButton.frame = CGRectMake(0, errorMessageHeight + 25, moviePlayerController.view.frame.size.width, watchHereLabelHeight);
        
        int nextVideoMessageHeight = [nextVideoWillPlayInMessage.text sizeWithFont:nextVideoWillPlayInMessage.font].height;
        nextVideoWillPlayInMessage.frame = CGRectMake(0, (errorMessageHeight + watchHereLabelHeight + 35), moviePlayerController.view.frame.size.width, nextVideoMessageHeight);
        
        loadingActivity.frame = CGRectMake(((moviePlayerController.view.frame.size.width - 100) / 2), 
                                           (errorMessageHeight + watchHereLabelHeight + nextVideoMessageHeight + 50), 
                                           100, 100);
        countdown.frame = CGRectMake(((loadingActivity.frame.size.width - 20)/ 2), ((loadingActivity.frame.size.height - 20) / 2) - 4, 20, 20);
        
        // videosListView.frame = CGRectMake(0, (self.frame.size.height - 111), self.frame.size.width, 110);
    }
}

- (void) dealloc {
    [video.videoSource resetFaviconImageLoadedCallback];
    
    // stop listening notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidEnterFullscreenNotification object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerDidExitFullscreenNotification object:moviePlayerController];
    
    moviePlayerController.initialPlaybackTime = -1;
    [moviePlayerController.view removeFromSuperview];
    
    [video release];
    
    [closeButton removeFromSuperview];
    [titleLabel removeFromSuperview];
    [likeButton removeFromSuperview];
    [saveButton removeFromSuperview];
    [prevButton removeFromSuperview];
    [nextButton removeFromSuperview];
    // [moviePlayerNativeControlView release];
    [loadingActivity removeFromSuperview];
    [moviePlayer removeFromSuperview];
    [description removeFromSuperview];
    [favicon removeFromSuperview];
    // [faviconBackground release];
    [topSeparator removeFromSuperview];
    [bottomSeparator removeFromSuperview];
    
    [countdown removeFromSuperview];
    [errorMessage removeFromSuperview];
    [watchHereButton removeFromSuperview];
    [nextVideoWillPlayInMessage removeFromSuperview];
    
    [moviePlayerController release];
    [closeButton release];
    [titleLabel release];
    [likeButton release];
    [saveButton release];
    [prevButton release];
    [nextButton release];
    // [moviePlayerNativeControlView release];
    [loadingActivity release];
    [moviePlayer release];
    [description release];
    [favicon release];
    // [faviconBackground release];
    [topSeparator release];
    [bottomSeparator release];
    
    [countdown release];
    [errorMessage release];
    [watchHereButton release];
    [nextVideoWillPlayInMessage release];
    
    // [videosListView release];
    
    [onLikeButtonClickedCallback release];
    [onNextButtonClickedCallback release];
    [onPreviousButtonClickedCallback release];
    [onCloseButtonClickedCallback release];
    [onUnlikeButtonClickedCallback release];
    [onSaveButtonClickedCallback release];
    [onPlaybackErrorCallback release];
    [onViewSourceClickedCallback release];
    [onVideoFinishedCallback release];
    
    currentlyPlayingVideoUrl = nil;
    
    moviePlayerController = nil;
    closeButton = nil;
    titleLabel = nil;
    likeButton = nil;
    saveButton = nil;
    prevButton = nil;
    nextButton = nil;
    // [moviePlayerNativeControlView release];
    loadingActivity = nil;
    moviePlayer = nil;
    description = nil;
    favicon = nil;
    // [faviconBackground release];
    topSeparator = nil;
    bottomSeparator = nil;
    
    countdown = nil;
    errorMessage = nil;
    watchHereButton = nil;
    nextVideoWillPlayInMessage = nil;
    
    onLikeButtonClickedCallback = nil;
    onNextButtonClickedCallback = nil;
    onLikeButtonClickedCallback = nil;
    onCloseButtonClickedCallback = nil;
    onUnlikeButtonClickedCallback = nil;
    onSaveButtonClickedCallback = nil;
    onPlaybackErrorCallback = nil;
    onViewSourceClickedCallback = nil;
    onVideoFinishedCallback = nil;
    
    video = nil;
    
    [super dealloc];
}


// -------------------------------------------------------------------------
//                              Private functions
// -------------------------------------------------------------------------

/*
 * Update the video seek time (means how many seconds user has
 * watched the video. This function is called when user closes the 
 * video either by clicking on close button or previous or next button.
 * This function is also called when video finished playing.
 */
- (void) updatePauseTime:(NSNumber*)pauseTime {
    // NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    // if request object is never created, create it
    VideoRequest* updateSeekRequest = [[[VideoRequest alloc] init] autorelease];
    updateSeekRequest.successCallback = [Callback create:self selector:@selector(onSeekRequestSuccess:)];
    updateSeekRequest.errorCallback = [Callback create:self selector:@selector(onSeekRequestFailure:)];
    
    // convert the pause time in string with 2 decimal digits.
    // It seems if you send anything more than 2 decimal digits
    // server does not likes it.
    NSString* videoPauseTime = [NSString stringWithFormat:@"%.2f", [pauseTime floatValue]];
    video.seek = [pauseTime doubleValue];
    shouldPlayVideo = false;
    [updateSeekRequest updateSeekTime:videoPauseTime forVideo:video];
    LOG_DEBUG(@"Get called in update pause time.");
    // [pool release];
}

/*
 * Updates the countdown
 */
- (void) updateCountdown: (NSNumber*)value {
    int countDownTime = [value intValue];
    if (countDownTime > 0) {
        if (isFullScreenMode) {
            fullScreenCountdown.text = [NSString stringWithFormat:@"%d", countDownTime];
        } else {
            countdown.text = [NSString stringWithFormat:@"%d", countDownTime];
        }
        [self performSelector:@selector(updateCountdown:) withObject:[NSNumber numberWithInt:(countDownTime -1)] afterDelay:1.0];
    } else {
        if (isFullScreenMode) {
            fullScreenCountdown.hidden = YES;
            fullScreenErrorMessage.hidden = YES;
            fullScreenWatchHereButton.hidden = YES;
            fullScreenNextVideoWillPlayInMessage.hidden = YES;
        } else {
            countdown.hidden = YES;
            errorMessage.hidden = YES;
            watchHereButton.hidden = YES;
            nextVideoWillPlayInMessage.hidden = YES;
        }
        [self performSelectorOnMainThread:@selector(onNextButtonClicked:) withObject:nil waitUntilDone:NO];
    }
}

/*
 * Show the watchlr custom controls on the MPMoviePlayer.
 */
-(void) showCustomControls {
    if (isFullScreenMode) {
        fullScreenPreviousButton.hidden = NO;
        fullScreenNextButton.hidden = NO;
        fullScreenLikeButton.hidden = NO;
        
        if (!video.saved || video.savedInCurrentTab) {
            fullScreenSaveButton.hidden = NO;
        }
        areControlsVisible = true;
    }
}

/*
 * hide watchlr custom controls
 */
- (void) hideCustomControls {
    if (isFullScreenMode) {
        fullScreenPreviousButton.hidden = YES;
        fullScreenNextButton.hidden = YES; 
        fullScreenLikeButton.hidden = YES;
        fullScreenSaveButton.hidden = YES;
        areControlsVisible = false;
    }
}

/*
 * Play the video with given url and initial position.
 */
-(void) play:(NSString*)videoUrl withInitialPlaybackTime:(double)seekTime {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (![[NSThread currentThread] isCancelled]) {
        hasUserInitiatedVideoFinished = false;
        moviePlayerController.contentURL = [NSURL URLWithString:videoUrl];
        moviePlayerController.initialPlaybackTime = seekTime;
        [moviePlayerController performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
    }
    
    [pool release];
}

/*
 * load the video.
 *
 * If user is in lean back mode play the video from the start
 * else start the video from where user left it last time.
 *
 * To know the last seek position we should ping the server again.
 * It may happen that user play their video on some other device 
 * and does not refresh the current list loaded. Then we have an 
 * invalid start position.
 */
- (void) loadVideo:(NSString*) videoUrl {
    currentlyPlayingVideoUrl = [videoUrl copy];
    if (isLeanBackMode) {
        [self play:videoUrl withInitialPlaybackTime:0.0];
    } else {
        // if request object is never created, create it
        VideoRequest* seekRequest = [[[VideoRequest alloc] init] autorelease];
        seekRequest.successCallback = [Callback create:self selector:@selector(onSeekRequestSuccess:)];
        seekRequest.errorCallback = [Callback create:self selector:@selector(onSeekRequestFailure:)];
        
        shouldPlayVideo = true;
        [seekRequest getSeekTime:video];
    }
}

/*
 * Shows the error message if we cannot play the video.
 */
- (void) showErrorMessage:(NSString*) message {
    [self performSelector:@selector(onPlaybackError) withObject:[NSNumber numberWithInt:4] afterDelay:1.0];
    
    if (isFullScreenMode) {
        fullScreenErrorMessage.text = message;
        fullScreenErrorMessage.hidden = NO;
        fullScreenCountdown.hidden = NO;
        fullScreenWatchHereButton.hidden = NO;
        fullScreenNextVideoWillPlayInMessage.hidden = NO;
        fullScreenCountdown.text = @"5";
    } else {
        errorMessage.text = message;
        errorMessage.hidden = NO;
        countdown.hidden = NO;
        watchHereButton.hidden = NO;
        nextVideoWillPlayInMessage.hidden = NO;
        countdown.text = @"5";
    }
    
    [self performSelector:@selector(updateCountdown:) withObject:[NSNumber numberWithInt:4] afterDelay:1.0];
}

/*
 * Check if video is a vimeo video. 
 */
- (BOOL) isVimeoVideo:(NSString*) videoSrc {
    // Look for 'vimeo' in videoSrc
    NSError *error = NULL;
    NSRegularExpression *vimeoSrcRegex = [NSRegularExpression regularExpressionWithPattern:@"vimeo"
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
    if (error == NULL) {
        NSRange rangeOfMatchedString = [vimeoSrcRegex rangeOfFirstMatchInString:videoSrc options:0 range:NSMakeRange(0, [videoSrc length])];
        return !NSEqualRanges(rangeOfMatchedString, NSMakeRange(NSNotFound, 0));
    }
    
    return FALSE;
}

/*
 * Check if video is a youtube video.
 */
- (BOOL) isYoutubeVideo:(NSString*) videoSrc {
    // Look for 'youtube' in videoSrc
    NSError *error = NULL;
    NSRegularExpression *youtubeSrcRegex = [NSRegularExpression regularExpressionWithPattern:@"youtube"
                                                                                     options:NSRegularExpressionCaseInsensitive
                                                                                       error:&error];
    if (error == NULL) {
        NSRange rangeOfMatchedString = [youtubeSrcRegex rangeOfFirstMatchInString:videoSrc options:0 range:NSMakeRange(0, [videoSrc length])];
        return !NSEqualRanges(rangeOfMatchedString, NSMakeRange(NSNotFound, 0));
    }
    
    return FALSE;
}

/*
 * Returns the URL from where youtube meta data can be fetched. 
 */
- (NSString*) getYoutubeVideoMetaDataUrl: (NSString*)videoSrc {
    NSString* youtubeVideoId = NULL;
    NSError* error = NULL;
    
    // Extract the youtube video id
    NSRegularExpression *videoIdRegex = [NSRegularExpression regularExpressionWithPattern:@"embed\\/([\\S]+?)\\?"
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error];
    
    // If there is no error in regex, try to find all the matches in regex 
    if (error == NULL) {
        NSRange rangeOfvideoIdString = [videoIdRegex rangeOfFirstMatchInString:videoSrc options:0 range:NSMakeRange(0, [videoSrc length])];
        if (!NSEqualRanges(rangeOfvideoIdString, NSMakeRange(NSNotFound, 0))) {
            
            // If we matched the timestamp regex in the metadata
            // remove the first 6 characters('embed/') and last 9 
            // characters('?') from the matched string
            youtubeVideoId = [videoSrc substringWithRange:rangeOfvideoIdString];
            youtubeVideoId = [youtubeVideoId substringWithRange:NSMakeRange(6, ([youtubeVideoId length] - 7))];
            // LOG_DEBUG(@"youtube video id for video: %@", youtubeVideoId);
        } else {
            LOG_ERROR(@"Unable to found any match for youtube video id.");
        }
    } else {
        LOG_ERROR(@"Error in youtube video id regex.");
    }
    
    // build the youtube meta data URL using youtube video id.
    if (youtubeVideoId != NULL) {
        return [NSString stringWithFormat:@"http://www.youtube.com/get_video_info?video_id=%@&html5=1&eurl=unknown&el=embedded", youtubeVideoId];
    }
    
    return NULL;
}

/*
 * Extract vimeo clip id
 */
-(NSString*) getVimeoVideoClipId: (NSString*)videoSrc {
    NSString* vimeoVideoId = NULL;
    NSError* error = NULL;
    
    // Extract the vimeo video id
    NSRegularExpression *videoIdRegex = [NSRegularExpression regularExpressionWithPattern:@"video\\/[\\d]+"
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error];
    
    // If there is no error in regex, try to find all the matches in regex 
    if (error == NULL) {
        NSRange rangeOfvideoIdString = [videoIdRegex rangeOfFirstMatchInString:videoSrc options:0 range:NSMakeRange(0, [videoSrc length])];
        if (!NSEqualRanges(rangeOfvideoIdString, NSMakeRange(NSNotFound, 0))) {
            
            // If we matched the timestamp regex in the metadata
            // remove the first 6 characters('video/') from the matched string
            vimeoVideoId = [videoSrc substringWithRange:rangeOfvideoIdString];
            vimeoVideoId = [vimeoVideoId substringWithRange:NSMakeRange(6, ([vimeoVideoId length] - 6))];
            // LOG_DEBUG(@"vimeo video id for video: %@", vimeoVideoId);
        } else {
            LOG_ERROR(@"Unable to found any match for vimeo video id.");
        }
    } else {
        LOG_ERROR(@"Error in vimeo video id regex.");
    }
    
    return vimeoVideoId;
}

/*
 * Returns the URL from where vimeo meta data can be fecthed.
 */
- (NSString*) getVimeoVideoMetaDataUrl: (NSString*)videoSrc {
    
    NSString* vimeoVideoId = [self getVimeoVideoClipId:videoSrc];
    
    // build the vime meta data URL using video id.
    if (vimeoVideoId != NULL) {
        return [NSString stringWithFormat:@"http://vimeo.com/moogaloop/load/clip:%@", vimeoVideoId];
    }
    
    return NULL;
}

/*
 * Fetches the meta data for the given video.
 */
- (void) getVideoMetaData: (NSString*) videoSrc {
    // If request object is never created, create it
    
    GetRequest *metadataRequest = [[[GetRequest alloc] init] autorelease];
    metadataRequest.errorCallback = [Callback create:self selector:@selector(onVideoRequestFailed:)];
    metadataRequest.successCallback = [Callback create:self selector:@selector(onVideoRequestSuccess:)];
    
    
    // If currently going request is not completed, cancel it.
    if ([metadataRequest isRequesting]) {
        [metadataRequest cancelRequest];
    }
    
    // make the request.
    if (videoSrc != NULL) {
        // LOG_DEBUG(@"Fetching video meta data.");
        [metadataRequest doGetVideoRequest:videoSrc];
    } else {
        LOG_ERROR(@"Unable to fetch video meta data URL: %@", videoSrc);
    }
}

/*
 * Extract the video source from html5 embed code.
 */
- (NSString*) extractSourceFromHtml:(NSString*) htmlCode {
    if (htmlCode == NULL) {
        return NULL;
    }
    NSString *srcString = NULL;
    NSError *error = NULL;

    
    // Look for something 'src="....."'
    NSRegularExpression *srcRegex = [NSRegularExpression regularExpressionWithPattern:@"src=\"http:\\/\\/[\\S]+?\""
                                                                              options:NSRegularExpressionCaseInsensitive
                                                                                error:&error];
    // If there is no error in regex, try to find all the matches in regex 
    if (error == NULL) {
        NSRange rangeOfSrcString = [srcRegex rangeOfFirstMatchInString:htmlCode options:0 range:NSMakeRange(0, [htmlCode length])];
        if (!NSEqualRanges(rangeOfSrcString, NSMakeRange(NSNotFound, 0))) {
            
            // If we matched the src regex in the html5 video embed
            // remove the first 5 characters('src="') and the last 
            // character('"') from the matched string
            srcString = [htmlCode substringWithRange:rangeOfSrcString];
            srcString = [srcString substringWithRange:NSMakeRange(5, ([srcString  length] - 6))];
            // LOG_DEBUG(@"src for video: %@", srcString);
            
        } else {
            LOG_ERROR(@"Unable to found the source regex in HTML code: \n%@", htmlCode);
        }
    } else {
        LOG_ERROR(@"Malformed regular expression for extracting source from the HTML embed. Reason: \n%@", error);
    }
    
    return srcString;
}

/*
 * Play vimeo video using the meta dat fetched.
 */
- (void) playVimeoVideo:(NSString*) metadata {
    // LOG_DEBUG(@"Body of the page. \n:%@", metadata);
    // LOG_DEBUG(@"Playing vimeo video.");
    NSString *timestamp = NULL; 
    NSString *signature = NULL;
    NSString *clipId = NULL;
    NSError *error = NULL;
    
    // Extract the timetstamp for the signature
    // Look for something '<request_signature_expires>1309564328</request_signature_expires>'
    NSRegularExpression *timestampRegex = [NSRegularExpression regularExpressionWithPattern:@"\\<request_signature_expires\\>\\d+\\<\\/request_signature_expires\\>"
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:&error];
    
    // If there is no error in regex, try to find all the matches in regex 
    if (error == NULL) {
        NSRange rangeOfTimestampString = [timestampRegex rangeOfFirstMatchInString:metadata options:0 range:NSMakeRange(0, [metadata length])];
        if (!NSEqualRanges(rangeOfTimestampString, NSMakeRange(NSNotFound, 0))) {
            
            // If we matched the timestamp regex in the metadata
            // remove the first 27 characters('<request_signature_expires>') 
            // and last 28 characters('</request_signature_expires>') 
            // from the matched string
            timestamp = [metadata substringWithRange:rangeOfTimestampString];
            timestamp = [timestamp substringWithRange:NSMakeRange(27, ([timestamp  length] - 55))];
            // LOG_DEBUG(@"timestamp for video: %@", timestamp);
        } else {
            LOG_ERROR(@"Unable to found any match for timestamp.");
        }
    } else {
        LOG_ERROR(@"Error in timestamp regex.");
    }
    
    // Extract the signature
    // Look for something '<request_signature>520b2a5cd76522e0a4e7daaa5e803063</request_signature>'
    NSRegularExpression *signatureRegex = [NSRegularExpression regularExpressionWithPattern:@"\\<request_signature\\>\\S+\\<\\/request_signature\\>"
                                                                                    options:NSRegularExpressionCaseInsensitive
                                                                                      error:&error];
    
    // If there is no error in regex, try to find all the matches in regex 
    if (error == NULL) {
        NSRange rangeOfSignatureString = [signatureRegex rangeOfFirstMatchInString:metadata options:0 range:NSMakeRange(0, [metadata length])];
        if (!NSEqualRanges(rangeOfSignatureString, NSMakeRange(NSNotFound, 0))) {
            
            // If we matched the timestamp regex in the metadata
            // remove the first 19 characters('<request_signature>') and 
            // last 20 characters('</request_signature>') from the matched string
            signature = [metadata substringWithRange:rangeOfSignatureString];
            signature = [signature substringWithRange:NSMakeRange(19, ([signature  length] - 39))];
            // LOG_DEBUG(@"signature for video: %@", signature);
        } else {
            LOG_ERROR(@"Unable to found any match for signature.");
        }
    } else {
        LOG_ERROR(@"Error in signature regex.");
    }
    
    // Extract the video id
    // Look for something '<clip_id>11661167</clip_id>'
    NSRegularExpression *clipIdRegex = [NSRegularExpression regularExpressionWithPattern:@"\\<clip_id\\>\\d+\\<\\/clip_id\\>"
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
    
    // If there is no error in regex, try to find all the matches in regex 
    if (error == NULL) {
        NSRange rangeOfClipIdString = [clipIdRegex rangeOfFirstMatchInString:metadata options:0 range:NSMakeRange(0, [metadata length])];
        if (!NSEqualRanges(rangeOfClipIdString, NSMakeRange(NSNotFound, 0))) {
            
            // If we matched the timestamp regex in the metadata
            // remove the first 9 characters('<clip_id>') and 
            // last 10 charactera('</clip_id>) from the matched string
            clipId = [metadata substringWithRange:rangeOfClipIdString];
            clipId = [clipId substringWithRange:NSMakeRange(9, ([clipId  length] - 19))];
            // LOG_DEBUG(@"clip id for video: %@", clipId);
        } else {
            LOG_ERROR(@"Unable to found any match for vimeo clipId. Using fallback method.");
            NSString* videoSource = [self extractSourceFromHtml:video.htmlCode];
            if (videoSource != NULL) {
                clipId = [self getVimeoVideoClipId:videoSource];
            } else {
                LOG_ERROR(@"Error in fetching vimeo clip id from source.");
            }
        }
    } else {
        LOG_ERROR(@"Error in clipid regex.");
    }
    
    // If we extracted all the information correctly
    // play the video.
    if (timestamp != NULL && signature != NULL && clipId != NULL) {
        NSString* videoSource = [NSString stringWithFormat:@"http://vimeo.com/moogaloop/play/clip:%@/%@/%@", clipId, signature, timestamp];
        // LOG_DEBUG(@"Video source for vimeo: %@", videoSource);
        [self loadVideo:videoSource];
    } else {
        LOG_ERROR(@"Unable to found the URL for vimeo video stream.");
        [self showErrorMessage:@"We could not play this video."];
    }
    
}

/*
 * play youtube video using the meta data fetched.
 */
-(void) playYoutubeVideo:(NSString*) metadata {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    // LOG_DEBUG(@"Playing youtube video.");
    NSString *videoUrlHD = NULL;
    NSString *videoUrl = NULL;
    
    NSArray* params = [metadata componentsSeparatedByString:@"&"];
    NSMutableDictionary* paramsDict = [[[NSMutableDictionary alloc] init] autorelease];
    for (int i = 0; i < [params count]; i++) {
        NSString* keyValuePair = (NSString*)[params objectAtIndex:i];
        // LOG_DEBUG(@"\n%@\n\n\n", keyValuePair);
        NSUInteger equalPos = [keyValuePair rangeOfString:@"="].location;
        [paramsDict setValue:[keyValuePair substringFromIndex:(equalPos + 1)] forKey:[keyValuePair substringToIndex:equalPos]];
    }
    
    // if meta data URL returns status as false,
    // then video is not embeddable and we cannot play that video.
    if (NSOrderedSame != [(NSString*)[paramsDict valueForKey:@"status"] caseInsensitiveCompare:@"ok"]) {
        LOG_ERROR(@"Youtube video is not embeddable. Status: %@", (NSString*)[paramsDict valueForKey:@"status"]);
        [self showErrorMessage:@"Embedding disabled by request."];
        return;
    }
    
    NSString* url_encoded_fmt_stream_map = (NSString*)[paramsDict valueForKey:@"url_encoded_fmt_stream_map"];
    if (url_encoded_fmt_stream_map == nil || [url_encoded_fmt_stream_map length] == 0) {
        LOG_ERROR(@"Unable to fetch the url_encoded_fmt_stream_map");
        [self showErrorMessage:@"We could not play this video."];
        return;
    }
    
    // decode the meta data fetched
    url_encoded_fmt_stream_map = [url_encoded_fmt_stream_map stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    // LOG_DEBUG(@"url_encoded_fmt_stream_map:\n%@\n\n", url_encoded_fmt_stream_map);
    
    NSArray* urls = [url_encoded_fmt_stream_map componentsSeparatedByString:@","];
    for (int i = 0; i < [urls count]; i++) {
        NSString* url = [urls objectAtIndex:i];
        if (NSOrderedSame == [[url substringFromIndex:[url length] - 2] caseInsensitiveCompare:@"22"]) {
            NSRange range = [url rangeOfString:@"url="];
            url = [[url substringFromIndex:(range.location + range.length)] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            range = [url rangeOfString:@"type=video/mp4"];
            videoUrlHD = [url substringToIndex:(range.location + range.length)]; 
            break;
        } else if (NSOrderedSame == [[url substringFromIndex:[url length] - 2] caseInsensitiveCompare:@"18"]) {
            NSRange range = [url rangeOfString:@"url="];
            url = [[url substringFromIndex:(range.location + range.length)] stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
            range = [url rangeOfString:@"type=video/mp4"];
            videoUrl = [url substringToIndex:(range.location + range.length)];
        }
    }
    
    // If we found the video URL, play the video.
    if (videoUrlHD != NULL) {
        [self loadVideo: videoUrlHD];
    } else if (videoUrl !=NULL) {
        [self loadVideo: videoUrl];
    } else {
        LOG_ERROR(@"Unable to found the URL for youtube video stream.");
        [self showErrorMessage:@"We could not play this video."];
    }
    
    [pool release];
}

/*
 * Find the movie player native controls view.
 */
/*- (UIView*) findMoviePlayerNativeControlView:(UIView*)view {
    LOG_DEBUG(@"Movie palyer class name: %@", NSStringFromClass([view class]));
    if([view isKindOfClass:NSClassFromString(@"MPInlineVideoOverlay")]) {
        //Add any additional controls you want to have fade with the standard controls here
        LOG_DEBUG(@"Found native controller view.");
        return view;
    } else {
        for(UIView *child in [view subviews]) {
            UIView* nativeControllerView = [self findMoviePlayerNativeControlView:child];
            if (nativeControllerView != nil) {
                return nativeControllerView;
            }
        }
    }
    
    return nil;
}*/

- (void) onFaviconImageLoaded:(UIImage*)faviconImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (faviconImage != nil) {
        if (![[NSThread currentThread] isCancelled]) {
            [favicon performSelectorOnMainThread:@selector(setImage:) withObject:faviconImage waitUntilDone:YES];
            favicon.hidden = NO;
        }
    } else {
        favicon.hidden = YES;
    }
    [pool release];
}

/*
 * downloads favicon image.
 */
- (void) downloadFaviconImage:(SourceObject*) source  {
    [source setFaviconImageLoadedCallback:[Callback create:self selector:@selector(onFaviconImageLoaded:)]];
    [source performSelector:@selector(loadImage)];
}

/**
 * Loads the images
 */
- (void) loadImages {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    if (video.videoSource != nil) {
        // set the favicon image
        if (video.videoSource.isFaviconImageLoaded) {
            if (video.videoSource.faviconImage != nil) {
                // make sure the thread was not killed
                if (![[NSThread currentThread] isCancelled]) {
                    [favicon performSelectorOnMainThread:@selector(setImage:) withObject:video.videoSource.faviconImage waitUntilDone:YES];
                    favicon.hidden = NO;
                }
            } else {
                favicon.hidden = YES;
            }
        } else {
            [self performSelector:@selector(downloadFaviconImage:) withObject:video.videoSource];
        }
    }
    
    [pool release];
}

- (void) hideErrorMessage {
    if (isFullScreenMode) {
        if (fullScreenErrorMessage != nil && fullScreenErrorMessage.hidden == NO) {
            [fullScreenErrorMessage setHidden:YES];
        }
        
        if (fullScreenCountdown != nil && fullScreenCountdown.hidden == NO) {
            [fullScreenCountdown setHidden:YES];
        }
        
        if (fullScreenWatchHereButton != nil && fullScreenWatchHereButton.hidden == NO) {
            [fullScreenWatchHereButton setHidden:YES];
        }
        
        if (fullScreenNextVideoWillPlayInMessage != nil && fullScreenNextVideoWillPlayInMessage.hidden == NO) {
            [fullScreenNextVideoWillPlayInMessage setHidden:YES];
        }
    } else {
        if (errorMessage != nil && errorMessage.hidden == NO) {
            [errorMessage setHidden:YES];
        }
        
        if (countdown != nil && countdown.hidden == NO) {
            [countdown setHidden:YES];
        }
        
        if (watchHereButton != nil && watchHereButton.hidden == NO) {
            [watchHereButton setHidden:YES];
        }
        
        if (nextVideoWillPlayInMessage != nil && nextVideoWillPlayInMessage.hidden == NO) {
            [nextVideoWillPlayInMessage setHidden:YES];
        }
    }
}

- (void) hideLoadingActivity {
    if (isFullScreenMode) {
        if (fullScreenLoadingActivity != nil) {
            [fullScreenLoadingActivity stopAnimating]; 
        }
    } else {
        [loadingActivity stopAnimating];
    }
}

- (void) stopCountdown {
    [UIApplication cancelPreviousPerformRequestsWithTarget:self];
    [self hideErrorMessage];
}

// -------------------------------------------------------------------------
//                       Request callback functions
// -------------------------------------------------------------------------
- (void) onSeekRequestSuccess:(VideoResponse*)response {
    if (response.success) {
        [video updateFromDictionary:response.videoResponse];
    }
    
    double seekTime = video.seek;
    
    if (shouldPlayVideo) {
        if (currentlyPlayingVideoUrl != NULL) {
            // LOG_DEBUG(@"Video url: %@", currentlyPlayingVideoUrl);
            [self play:currentlyPlayingVideoUrl withInitialPlaybackTime:seekTime];
        } else {
            LOG_ERROR(@"Unable to found the URL for vimeo video stream.");
            [self showErrorMessage:@"We could not play this video."];
        }
    }
}

- (void) onSeekRequestFailure:(VideoResponse*)response {
    if (shouldPlayVideo) {
        if (currentlyPlayingVideoUrl != NULL) {
            [self play:currentlyPlayingVideoUrl withInitialPlaybackTime:video.seek];
        } else {
            LOG_ERROR(@"Unable to found the URL for vimeo video stream.");
            [self showErrorMessage:@"We could not play this video."];
        }
    }
}

// -------------------------------------------------------------------------
//                              Callback functions
// -------------------------------------------------------------------------
- (void) onCloseButtonClicked:(UIButton*) sender {
    [self stopCountdown];
    // LOG_DEBUG(@"User closed the player");
    isLeanBackMode = false;
    hasUserInitiatedVideoFinished = true;
    float currentPlaybackTime = moviePlayerController.currentPlaybackTime;
    [moviePlayerController stop];
    if (onCloseButtonClickedCallback != nil) {
        [onCloseButtonClickedCallback execute:nil];
        // LOG_DEBUG(@"Current playback time: %f", currentPlaybackTime);
        [self updatePauseTime:[NSNumber numberWithDouble:currentPlaybackTime]];
    }
}

- (void) onLikeButtonClicked:(UIButton*) sender {
    if (video.liked) {
        if (onUnlikeButtonClickedCallback != nil) {
            [likeButton setImage:[UIImage imageNamed:@"heart_grey.png"] forState:UIControlStateNormal];
            if (fullScreenLikeButton != nil) {
                [fullScreenLikeButton setImage:[UIImage imageNamed:@"heart_grey.png"] forState:UIControlStateNormal];
            }
            [onUnlikeButtonClickedCallback execute:video];
        }
    } else {
        if (onLikeButtonClickedCallback != nil) {
            [likeButton setImage:[UIImage imageNamed:@"heart_red.png"] forState:UIControlStateNormal];
            if (fullScreenLikeButton != nil) {
                [fullScreenLikeButton setImage:[UIImage imageNamed:@"heart_red.png"] forState:UIControlStateNormal];
            }
            [onLikeButtonClickedCallback execute:video];
            
        }
    }
    // LOG_DEBUG(@"Like button clicked.");
}

- (void) onSaveButtonClicked:(UIButton*) sender {
    if (onSaveButtonClickedCallback != nil) {
        [saveButton setImage:[UIImage imageNamed:@"check_mark_green.png"] forState:UIControlStateNormal];
        if (fullScreenSaveButton != nil) {
            [fullScreenSaveButton setImage:[UIImage imageNamed:@"check_mark_green.png"] forState:UIControlStateNormal];
        }
        [onSaveButtonClickedCallback execute:video];
    }
    
    // LOG_DEBUG(@"Save button clicked.");
}

- (void) onPreviousButtonClicked:(UIButton*) sender {
    [self stopCountdown];
    isLeanBackMode = true;
    hasUserInitiatedVideoFinished = true;
    [moviePlayerController stop];
    if (onPreviousButtonClickedCallback != nil) {
        [onPreviousButtonClickedCallback execute:nil];
    }
}

- (void) onNextButtonClicked:(UIButton*) sender {
    [self stopCountdown];
    isLeanBackMode = true;
    hasUserInitiatedVideoFinished = true;
    [moviePlayerController stop];
    if (onNextButtonClickedCallback != nil) {
        [onNextButtonClickedCallback execute:nil];
    }
}

-(void) onPlaybackError {
    isLeanBackMode = true;
    hasUserInitiatedVideoFinished = true;
    [moviePlayerController stop];
    if (onPlaybackErrorCallback != nil) {
        [onPlaybackErrorCallback execute:nil];
    }
}

- (void) onViewSourceClicked {
    [self hideLoadingActivity];
    if (isFullScreenMode) {
        [moviePlayerController setFullscreen:NO animated:NO];
        wasPlayingInFullScreenMode = false;
    }
    
    // hide error message displayed if any
    [self stopCountdown];
    
    [self onCloseButtonClicked:nil];
    
    if (onViewSourceClickedCallback != nil) {
        if (video.hostUrl != nil) {
            [onViewSourceClickedCallback execute:video.hostUrl];
        } else {
            [onViewSourceClickedCallback execute:video.videoUrl];
        }
    }
}

- (void) onFullScreenMode: (NSNotification*) aNotification {
//    moviePlayerController.controlStyle = MPMovieControlStyleEmbedded;
    isFullScreenMode = true;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window)
    {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    fullScreenModeView = [[window subviews] objectAtIndex:0];
    
    // tap gesture
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.delegate= self;
    [fullScreenModeView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    // swipe left
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(handleSwipeLeft:)];
    
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [fullScreenModeView addGestureRecognizer:swipeLeft];
    [swipeLeft release];
    
    // Swipe Right
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(handleSwipeRight:)];
    
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [fullScreenModeView addGestureRecognizer:swipeRight];
    [swipeRight release];
    
    
    
    // add the loading view to movie player
    fullScreenLoadingActivity = [[UIActivityIndicatorView alloc] init];
    fullScreenLoadingActivity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [fullScreenLoadingActivity setHidesWhenStopped:YES];
    fullScreenLoadingActivity.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [fullScreenModeView addSubview:fullScreenLoadingActivity];
    [fullScreenModeView bringSubviewToFront:fullScreenLoadingActivity];
    
    // add the countdown to loading activity
    fullScreenCountdown = [[UILabel alloc] init];
    fullScreenCountdown.textColor = [UIColor whiteColor];
    fullScreenCountdown.backgroundColor = [UIColor clearColor];
    fullScreenCountdown.textAlignment = UITextAlignmentCenter;
    fullScreenCountdown.font = [UIFont systemFontOfSize:25];
    fullScreenCountdown.numberOfLines = 1;
    fullScreenCountdown.hidden = YES;
    fullScreenCountdown.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [fullScreenLoadingActivity addSubview:fullScreenCountdown];
    
    // add the error message to movie player
    fullScreenErrorMessage = [[UILabel alloc] init];
    fullScreenErrorMessage.text = @"We could not play this video.";
    fullScreenErrorMessage.textColor = [UIColor whiteColor];
    fullScreenErrorMessage.backgroundColor = [UIColor clearColor];
    fullScreenErrorMessage.textAlignment = UITextAlignmentCenter;
    fullScreenErrorMessage.font = [UIFont systemFontOfSize:25];
    fullScreenErrorMessage.numberOfLines = 1;
    fullScreenErrorMessage.hidden = YES;
    fullScreenErrorMessage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [fullScreenModeView addSubview:fullScreenErrorMessage];
    
    // add the watch here button to movie player
    fullScreenWatchHereButton = [[UIButton alloc] init];
    [fullScreenWatchHereButton addTarget:self action:@selector(onViewSourceClicked) forControlEvents:UIControlEventTouchDown];
    [fullScreenWatchHereButton setTitle:@"Watch here" forState:UIControlStateNormal];
    [fullScreenWatchHereButton setTitleColor:[UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0] forState:UIControlStateNormal];
    fullScreenWatchHereButton.backgroundColor = [UIColor clearColor];
    fullScreenWatchHereButton.titleLabel.font = [UIFont systemFontOfSize:25];
    fullScreenWatchHereButton.hidden = YES;
    fullScreenWatchHereButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [fullScreenModeView addSubview:fullScreenWatchHereButton];

    
    // add the error message to movie player
    fullScreenNextVideoWillPlayInMessage = [[UILabel alloc] init];
    fullScreenNextVideoWillPlayInMessage.text = @"Your next video will play in";
    fullScreenNextVideoWillPlayInMessage.textColor = [UIColor whiteColor];
    fullScreenNextVideoWillPlayInMessage.backgroundColor = [UIColor clearColor];
    fullScreenNextVideoWillPlayInMessage.textAlignment = UITextAlignmentCenter;
    fullScreenNextVideoWillPlayInMessage.font = [UIFont systemFontOfSize:25];
    fullScreenNextVideoWillPlayInMessage.numberOfLines = 1;
    fullScreenNextVideoWillPlayInMessage.hidden = YES;
    fullScreenNextVideoWillPlayInMessage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [fullScreenModeView addSubview:fullScreenNextVideoWillPlayInMessage];
    
    // add the previous button
    // create the previous button
    fullScreenPreviousButton = [[UIButton alloc] init];
    [fullScreenPreviousButton addTarget:self action:@selector(onPreviousButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [fullScreenPreviousButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    fullScreenPreviousButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:0.5];
    fullScreenPreviousButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    fullScreenPreviousButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [fullScreenModeView addSubview:fullScreenPreviousButton];
    
    // create the next button
    fullScreenNextButton = [[UIButton alloc] init];
    [fullScreenNextButton addTarget:self action:@selector(onNextButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [fullScreenNextButton setImage:[UIImage imageNamed:@"fwd_arrow.png"] forState:UIControlStateNormal];
    fullScreenNextButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    fullScreenNextButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:0.5];
    fullScreenNextButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [fullScreenModeView addSubview:fullScreenNextButton];
    
    // create the like button
    fullScreenLikeButton = [[UIButton alloc] init];
    [fullScreenLikeButton addTarget:self action:@selector(onLikeButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [fullScreenLikeButton setImage:[UIImage imageNamed:(video.liked ? @"heart_red.png" : @"heart_grey.png")] forState:UIControlStateNormal];
    fullScreenLikeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    fullScreenLikeButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:0.5];
    fullScreenLikeButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [fullScreenModeView addSubview:fullScreenLikeButton];
    
    // create the save button
    fullScreenSaveButton = [[UIButton alloc] init];
    [fullScreenSaveButton addTarget:self action:@selector(onSaveButtonClicked:) forControlEvents:UIControlEventTouchDown];
    [fullScreenSaveButton setImage:[UIImage imageNamed:(video.saved ? @"check_mark_green.png" : @"save_video.png")] forState:UIControlStateNormal];
    fullScreenSaveButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    fullScreenSaveButton.backgroundColor = [UIColor colorWithRed:(51.0/255.0) green:(51.0/255.0) blue:(51.0/255.0) alpha:0.5];
    fullScreenSaveButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    if (video.saved && !video.savedInCurrentTab) {
        fullScreenSaveButton.hidden = YES;
    }
    [fullScreenModeView addSubview:fullScreenSaveButton];
    
    
    // adjust the positions
    if (DeviceUtils.isIphone) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            fullScreenLoadingActivity.frame = CGRectMake(((window.frame.size.height - 75) / 2), 
                                                         ((window.frame.size.width - 75) / 2), 
                                                         75, 75);
        } else {
            fullScreenLoadingActivity.frame = CGRectMake(((window.frame.size.width - 75) / 2), 
                                                         ((window.frame.size.height - 75) / 2), 
                                                         75, 75);
        }
        
        fullScreenCountdown.font = [UIFont systemFontOfSize: 18];
        fullScreenCountdown.frame = CGRectMake(((fullScreenLoadingActivity.frame.size.width - 15)/ 2), ((fullScreenLoadingActivity.frame.size.height - 15) / 2), 15, 15);
        
        fullScreenErrorMessage.font = [UIFont systemFontOfSize:15];
        fullScreenErrorMessage.frame = CGRectMake(0, 10, fullScreenModeView.frame.size.width, 75);
    } else {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        
        int loadingActivityStartPos = 0;
        int screenWidth = 0;
        int screenHeight = 0;
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            screenWidth = fullScreenModeView.frame.size.height;
            screenHeight = fullScreenModeView.frame.size.width;
            
        } else {
            screenWidth = fullScreenModeView.frame.size.width;
            screenHeight = fullScreenModeView.frame.size.height;
        }
        
        fullScreenLoadingActivity.frame = CGRectMake(((screenWidth - 150) / 2), 
                                                     ((screenHeight - 150) / 2), 
                                                     150, 150);
        loadingActivityStartPos = fullScreenLoadingActivity.frame.origin.y;
        
        int nextMessageHeight = [fullScreenNextVideoWillPlayInMessage.text sizeWithFont:fullScreenNextVideoWillPlayInMessage.font].height;
        fullScreenNextVideoWillPlayInMessage.frame = CGRectMake(0, (loadingActivityStartPos - (nextMessageHeight + 20)), screenWidth, nextMessageHeight);
        
        int watchHereLabelHeight = [fullScreenWatchHereButton.titleLabel.text sizeWithFont:fullScreenWatchHereButton.titleLabel.font].height;
        fullScreenWatchHereButton.frame = CGRectMake(0, (loadingActivityStartPos - (nextMessageHeight + watchHereLabelHeight + 35)), screenWidth, watchHereLabelHeight);
        
        int errorMessageHeight = [fullScreenErrorMessage.text sizeWithFont:fullScreenErrorMessage.font].height;
        fullScreenErrorMessage.frame = CGRectMake(0, (loadingActivityStartPos - (nextMessageHeight + watchHereLabelHeight + errorMessageHeight + 45)) , screenWidth, errorMessageHeight);
        
        fullScreenCountdown.font = [UIFont systemFontOfSize: 25];
        fullScreenCountdown.frame = CGRectMake(((fullScreenLoadingActivity.frame.size.width - 20)/ 2), ((fullScreenLoadingActivity.frame.size.height - 20) / 2) - 4, 20, 20);
        
        fullScreenPreviousButton.frame = CGRectMake(10, ((screenHeight - 63) / 2) , 37, 63);
        fullScreenNextButton.frame = CGRectMake(screenWidth - 47, ((screenHeight - 63) / 2), 37, 63);
        
        fullScreenLikeButton.frame = CGRectMake(screenWidth - 45, 80, 35, 35);
        fullScreenSaveButton.frame = CGRectMake(screenWidth - 45, 130, 35, 35);
    }
    
}

- (void) handleFullScreenTap {
    
}

-(void) willExitFullScreenMode: (NSNotification*) aNotification {
    
    for (UIGestureRecognizer* gestureRecognizer in fullScreenModeView.gestureRecognizers) {
        [fullScreenModeView removeGestureRecognizer:gestureRecognizer];
    }
    
    [fullScreenLikeButton removeFromSuperview];
    [fullScreenSaveButton removeFromSuperview];
    [fullScreenPreviousButton removeFromSuperview];
    [fullScreenNextButton removeFromSuperview];
    [fullScreenCountdown removeFromSuperview];
    [fullScreenLoadingActivity removeFromSuperview];
    [fullScreenErrorMessage removeFromSuperview];
    [fullScreenWatchHereButton removeFromSuperview];
    [fullScreenNextVideoWillPlayInMessage removeFromSuperview];
    
    [fullScreenLikeButton release];
    [fullScreenSaveButton release];
    [fullScreenPreviousButton release];
    [fullScreenNextButton release];
    [fullScreenCountdown release];
    [fullScreenLoadingActivity release];
    [fullScreenErrorMessage release];
    [fullScreenWatchHereButton release];
    [fullScreenNextVideoWillPlayInMessage release];
    
    fullScreenLikeButton = nil;
    fullScreenSaveButton = nil;
    fullScreenPreviousButton = nil;
    fullScreenNextButton = nil;
    fullScreenCountdown = nil;
    fullScreenLoadingActivity = nil;
    fullScreenErrorMessage = nil;
    fullScreenWatchHereButton = nil;
    fullScreenNextVideoWillPlayInMessage = nil;
    
    wasPlayingInFullScreenMode = (moviePlayerController.playbackState == MPMoviePlaybackStatePlaying);
    
    isFullScreenMode = false;
}

- (void) onEmbededMode: (NSNotification*) aNotification {
    if (DeviceUtils.isIphone) {
        [self closePlayer];
    } else {
        if (wasPlayingInFullScreenMode) {
            [moviePlayerController play];
        }
    }
    
    [self layoutSubviews];
    
    // LOG_DEBUG(@"Exited full screen mode.");
    // find the native controller view so that we can 
    // show/hide the controls when native controls show/hide 
    // moviePlayerNativeControlView = nil;
    // [self findMoviePlayerNativeControlView:moviePlayerController.view];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (isFullScreenMode) {
            CGPoint touchLocation = [touch locationInView:fullScreenModeView];
            bool shouldPerformActionOnTouchGesture = true;
            
            // check if user has tapped on next button
            CGRect nextButtonRect = [fullScreenNextButton bounds];
            nextButtonRect = [fullScreenNextButton convertRect:nextButtonRect toView:fullScreenModeView];
            if (CGRectContainsPoint(nextButtonRect, touchLocation)) {
                shouldPerformActionOnTouchGesture = false;
            }
            
            // check if user has tapped on previous button
            CGRect prevButtonRect = [fullScreenPreviousButton bounds];
            prevButtonRect = [fullScreenPreviousButton convertRect:prevButtonRect toView:fullScreenModeView];
            if (CGRectContainsPoint(prevButtonRect, touchLocation)) {
                shouldPerformActionOnTouchGesture = false;
            }
            
            // check if user has tapped on save button
            CGRect saveButtonRect = [fullScreenSaveButton bounds];
            saveButtonRect = [fullScreenSaveButton convertRect:saveButtonRect toView:fullScreenModeView];
            if (CGRectContainsPoint(saveButtonRect, touchLocation)) {
                shouldPerformActionOnTouchGesture = false;
            }
            
            // check if user has tapped on like button
            CGRect likeButtonRect = [fullScreenLikeButton bounds];
            likeButtonRect = [fullScreenLikeButton convertRect:likeButtonRect toView:fullScreenModeView];
            if (CGRectContainsPoint(likeButtonRect, touchLocation)) {
                shouldPerformActionOnTouchGesture = false;
            }
            
            if (areControlsVisible) {
                [UIApplication cancelPreviousPerformRequestsWithTarget:self];
                if (shouldPerformActionOnTouchGesture) {
                    // If controls are visible and user has tapped on the control 
                    // don't perform any action
                    [self hideCustomControls];
                } else {
                    [self performSelector:@selector(hideCustomControls) withObject:nil afterDelay:5.0];
                }    
                
            } else {
                [self showCustomControls];
                [self performSelector:@selector(hideCustomControls) withObject:nil afterDelay:5.0];
            }
            
            
        } else {
            CGPoint touchLocation = [touch locationInView:self];
            bool shouldPerformActionOnTouchGesture = true;
            
            // LOG_DEBUG(@"native control view: %ld", moviePlayerNativeControlView);
            // check if user has tapped on one of the native controls.
            /*if (moviePlayerNativeControlView) {
             CGRect nativeControlRect = [moviePlayerNativeControlView bounds];
             nativeControlRect = [moviePlayerNativeControlView convertRect:nativeControlRect toView:moviePlayerController.view];
             if (CGRectContainsPoint(nativeControlRect, touchLocation)) {
             shouldPerformActionOnTochGesture = false;
             }
             }*/
            
            // check if user has tapped on the next button
            CGRect nextButtonRect = [nextButton bounds];
            nextButtonRect = [nextButton convertRect:nextButtonRect toView:self];
            if (CGRectContainsPoint(nextButtonRect, touchLocation)) {
                shouldPerformActionOnTouchGesture = false;
            }
            
            // check if user has tapped on the previous button
            CGRect prevButtonRect = [prevButton bounds];
            prevButtonRect = [prevButton convertRect:prevButtonRect toView:self];
            if (CGRectContainsPoint(prevButtonRect, touchLocation)) {
                shouldPerformActionOnTouchGesture = false;
            }
            
            // check if user has tapped on the movie player
            CGRect moviePlayerRect = [moviePlayer bounds];
            moviePlayerRect = [moviePlayer convertRect:moviePlayerRect toView:self];
            if (CGRectContainsPoint(moviePlayerRect, touchLocation)) {
                shouldPerformActionOnTouchGesture = false;
            }
            
            if (shouldPerformActionOnTouchGesture) {
                [self onCloseButtonClicked:nil];
            }
        }
    } 
    else if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) { // SWIPE Gesture
        LOG_DEBUG(@"Swipe gesture from base calass gesture recognizer.");
    }
    return YES;
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)recognizer {
    // If user swipes on the scrubber to backward the movie
    // we think its a next button swipe
    
    // We have to do this wierd magic over here
    // as we don't know the moviePlayer controller view
    // or the bounds of movie player controller view.
    UIView* moviePlayerView = (isFullScreenMode ? fullScreenModeView : moviePlayerController.view);
    CGPoint touchLocation = [recognizer locationInView:moviePlayerView];
    CGRect viewRect = [moviePlayerView bounds];
    viewRect.origin.y = viewRect.size.height * (isFullScreenMode ? .1 : 0);
    viewRect.size.height *= (isFullScreenMode ? .7 : .9); 
    if (CGRectContainsPoint(viewRect, touchLocation)) {
        [self onNextButtonClicked:nil];
    }   
}

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)recognizer {
    // If user swipes on the scrubber to forward the movie
    // we think its a previous button swipe
    
    // We have to do this wierd magic over here
    // as we don't know the moviePlayer controller view
    // or the bounds of movie player controller view.
    UIView* moviePlayerView = (isFullScreenMode ? fullScreenModeView : moviePlayerController.view);
    CGPoint touchLocation = [recognizer locationInView:moviePlayerView];
    CGRect viewRect = [moviePlayerView bounds];
    viewRect.origin.y = viewRect.size.height * (isFullScreenMode ? .1 : 0);
    viewRect.size.height *= (isFullScreenMode ? .7 : .9); 
    if (CGRectContainsPoint(viewRect, touchLocation)) {
        [self onPreviousButtonClicked:nil];
    }
}

- (void) onVideoFinished:(NSNotification*)aNotification {
    LOG_DEBUG(@"Video finished for URL:%@", video.videoUrl);
    NSDictionary *userInfo = [aNotification userInfo];
    LOG_DEBUG(@"Reason video finished: %d", [[userInfo objectForKey:@"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue]);
    // LOG_DEBUG(@"Has user initiated finish action: %@", (hasUserInitiatedVideoFinished ? @"true" : @"false"));
    
    if (([[userInfo objectForKey:@"MPMoviePlayerPlaybackDidFinishReasonUserInfoKey"] intValue] == MPMovieFinishReasonPlaybackEnded) &&
        (onVideoFinishedCallback != nil) && !hasUserInitiatedVideoFinished) 
    {
        isLeanBackMode = true;
        [onVideoFinishedCallback execute:nil];
        // LOG_DEBUG(@"Updating time because video is finished.");
        [self updatePauseTime:[NSNumber numberWithDouble:0.0]];
    }
}

- (void) onVideoLoadingStateChange:(NSNotification*) aNotification {
    // LOG_DEBUG(@"Movie player load state: %d", moviePlayerController.loadState);
    if (moviePlayerController.loadState == MPMovieLoadStatePlayable) {
        [self hideLoadingActivity];
        [self hideErrorMessage];
        
//        [self showCustomControls];
//        [self performSelector:@selector(hideCustomControls) withObject:nil afterDelay:5.0];
        
        // find the native controller view so that we can 
        // show/hide the controls when native controls show/hide 
        // moviePlayerNativeControlView = nil;
        // [self findMoviePlayerNativeControlView:moviePlayerController.view];
    } 
}

- (void) onVideoPlaybackStateChanged:(NSNotification*) aNotification {
     [UIApplication cancelPreviousPerformRequestsWithTarget:self];
     if (moviePlayerController.playbackState == MPMoviePlaybackStatePlaying) {
         if (isFullScreenMode) {
             [self performSelector:@selector(hideCustomControls) withObject:nil afterDelay:5.0];
         }
     } else {
        if (isFullScreenMode && !areControlsVisible) {
            [self showCustomControls];
        }
     }
    
    if (moviePlayerController.playbackState == MPMoviePlaybackStatePaused && moviePlayerController.loadState != MPMovieLoadStateStalled) {
        LOG_DEBUG(@"Updating time because user has paused the video.");
        [self updatePauseTime:[NSNumber numberWithDouble:moviePlayerController.currentPlaybackTime]];
    }
}

- (void) onVideoRequestFailed:(NSString*) errorMessage {
    // LOG_DEBUG(@"Error while fetching the page. Reason:%@", errorMessage);
}

- (void) onVideoRequestSuccess:(GetResponse*) aResponse {
    if (isVimeoVideo) {
        // LOG_DEBUG(@"This is a vimeo video.");
        [self playVimeoVideo:aResponse.responseBody];
    } else if (isYoutubeVideo) {
        // LOG_DEBUG(@"This is a youtube video.");
        [self playYoutubeVideo:aResponse.responseBody];
    } else {
        LOG_ERROR(@"This is not a supported video.");
    }
}

// -------------------------------------------------------------------------
//                              Public functions
// -------------------------------------------------------------------------

/*
 * play video
 */
- (void) playVideo:(VideoObject*) videoObject {
    
    if (DeviceUtils.isIphone && !isFullScreenMode) {
        [moviePlayerController setFullscreen:YES animated:YES];
    }
    
    // hide error message displayed if any
    [self hideErrorMessage];
    
    // show the loading indicator
    if (isFullScreenMode) {
        if (fullScreenLoadingActivity != nil) {
            [fullScreenLoadingActivity startAnimating]; 
        }
    } else {
        [loadingActivity startAnimating];
    }
    
    // save the video object
    if (video != nil) {
        [video.videoSource resetFaviconImageLoadedCallback];
        [video release];
        video = nil;
    }
    video = [videoObject retain];
    
    // set the title
    titleLabel.text = video.title;
    
    // set the description
    if (video.description != nil) {
        description.text = video.description;
        description.hidden = NO;
    } else {
        description.hidden = YES;
    }
    
    // set the like button image
    [likeButton setImage:[UIImage imageNamed:(video.liked ? @"heart_red.png" : @"heart_grey.png")] forState:UIControlStateNormal];
    if (fullScreenLikeButton != nil) {
        [fullScreenLikeButton setImage:[UIImage imageNamed:(video.liked ? @"heart_red.png" : @"heart_grey.png")] forState:UIControlStateNormal];
    }
    
    // set whether we should show the save button
    if (video.saved) {
        [saveButton setImage:[UIImage imageNamed:@"check_mark_green.png"] forState:UIControlStateNormal];
        if (!video.savedInCurrentTab) {
            saveButton.hidden = YES;
        }
        
        if (fullScreenSaveButton != nil) {
            [fullScreenSaveButton setImage:[UIImage imageNamed:@"check_mark_green.png"] forState:UIControlStateNormal];
            if (!video.savedInCurrentTab) {
                fullScreenSaveButton.hidden = YES;
            }
        }
    } else {
        [saveButton setImage:[UIImage imageNamed:@"save_video.png"] forState:UIControlStateNormal];
        saveButton.hidden = NO;
        if (fullScreenSaveButton != nil) {
            [fullScreenSaveButton setImage:[UIImage imageNamed:@"save_video.png"] forState:UIControlStateNormal];
            fullScreenSaveButton.hidden = NO;
        }
    }
    
    // set the favicon
    [self performSelector:@selector(loadImages) withObject:nil];

    // reset all the variables
    isYoutubeVideo = false;
    isVimeoVideo = false;
    areControlsVisible = false;
    
    // Fetch the source of the video from HTML5 video object
    NSString * htmlCode = video.htmlCode;
    NSString* videoSource = [self extractSourceFromHtml:htmlCode];
    
    // If we have a valid src string, play the movie in movie player.
    if (videoSource != NULL) {
        // Youtube and Vimeo gives the iframe rather than an html video emebd tag.
        // So we cannot directly play the video using that source. For that we have
        // to create the video source by fetching the meta dat from the iframe video
        // source.
        
        // We'll play youtube or vime video once we fetched the meta data about
        // the videos.
        if ([self isYoutubeVideo:videoSource]) {
            // LOG_DEBUG(@"This is a youtube video.");
            isYoutubeVideo = true;
            videoSource = [self getYoutubeVideoMetaDataUrl:videoSource];
        } else if ([self isVimeoVideo:videoSource]) {
            // LOG_DEBUG(@"This is a vimeo video.");
            isVimeoVideo = true;
            videoSource = [self getVimeoVideoMetaDataUrl:videoSource];
        }
        
        if (isYoutubeVideo || isVimeoVideo) {
            // fetch the meta data URL.
            if (videoSource != NULL) {
                [self getVideoMetaData:videoSource];
            }
        } else {
            [self loadVideo:videoSource];
        }
    } else {
        LOG_ERROR(@"Unable to found the URL for video stream.");
        [self showErrorMessage:@"We could not play this video."];
    }
}

/*
 * stops the video and closes the player.
 */
- (void) closePlayer {
    if (MPMoviePlaybackStateStopped != moviePlayerController.playbackState) {
        [self onCloseButtonClicked: nil];
    }
}

- (void) onAllVideosPlayed:(bool)nextButtonClicked {
    // show the loading indicator
    [self hideLoadingActivity];
    [self hideErrorMessage];
    
    if (isFullScreenMode) {
        [moviePlayerController setFullscreen:NO animated:NO];
        wasPlayingInFullScreenMode = false;
    }
    
    errorMessage.text = (nextButtonClicked ? @"You have reached at \nend of your playlist." : @"You have reached at \nstart of your playlist.");
    errorMessage.hidden = NO;
}

@end
