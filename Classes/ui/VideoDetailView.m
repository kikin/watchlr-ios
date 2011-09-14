//
//  ConnectMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoDetailView.h"
#import <QuartzCore/QuartzCore.h>
#import "VideoRequest.h"
#import "VideoResponse.h"
#import "TrackerRequest.h"

@implementation VideoDetailView

@synthesize openLikedByUsersListCallback, onViewSourceClickedCallback, playVideoCallback, closeVideoPlayerCallback, sendAllVideoFinishedMessageCallback;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		// add the rounded rect view over the logo
		self.autoresizesSubviews = YES;
        
        // create the title
		titleLabel = [[UILabel alloc] init];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		titleLabel.font = [UIFont boldSystemFontOfSize:12];
        titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        titleLabel.numberOfLines = 3;
		[self addSubview:titleLabel];
        
        // create the thumbnail
        videoThumbnail = [[UIButton alloc] init];
        [videoThumbnail addTarget:self action:@selector(onPlayButtonClicked:) forControlEvents:UIControlEventTouchDown];
        videoThumbnail.backgroundColor = [UIColor clearColor];
        videoThumbnail.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:videoThumbnail];
        
        // create the play button
        playButton = [[UIButton alloc] init];
        [playButton addTarget:self action:@selector(onPlayButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [playButton setImage:[UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
        playButton.backgroundColor = [UIColor clearColor];
        playButton.autoresizingMask = UIViewAutoresizingNone; 
        [self addSubview:playButton];
		
		// create the description
        descriptionLabel = [[UITextView alloc] init];
        descriptionLabel.backgroundColor = [UIColor clearColor];
        descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        descriptionLabel.font = [UIFont systemFontOfSize:12];
        descriptionLabel.editable = NO;
        descriptionLabel.textAlignment = UITextAlignmentLeft;
        descriptionLabel.layer.cornerRadius = 5.0f;
        [self addSubview:descriptionLabel];
		
		// Create the favicon image
        faviconImage = [[UIImageView alloc] init];
        faviconImage.autoresizingMask = UIViewAutoresizingNone;
        [faviconImage setBackgroundColor:[UIColor clearColor]];
		[self addSubview:faviconImage];
        faviconImage.hidden = YES;
        
        // create the first dot separator
        dotLabelWidth = [@"." sizeWithFont:[UIFont boldSystemFontOfSize:25]].width;
        dot1Label = [[UILabel alloc] init];
		dot1Label.backgroundColor = [UIColor clearColor];
		dot1Label.autoresizingMask = UIViewAutoresizingNone;
		dot1Label.font = [UIFont boldSystemFontOfSize:25];
		dot1Label.text = @".";
        dot1Label.textColor = [UIColor blackColor];
        dot1Label.numberOfLines = 1;
		[self addSubview:dot1Label];
        
        // Create the timestamp label
        timestampLabel = [[UILabel alloc] init];
		timestampLabel.backgroundColor = [UIColor clearColor];
		timestampLabel.autoresizingMask = UIViewAutoresizingNone;
		timestampLabel.font = [UIFont systemFontOfSize:12];
		timestampLabel.textColor = [UIColor colorWithRed:(181.0 / 255.0) green:(181.0 / 255.0) blue:(181.0 / 255.0) alpha:1.0];
        timestampLabel.numberOfLines = 1;
		[self addSubview:timestampLabel];
        
        dot2Label = [[UILabel alloc] init];
		dot2Label.backgroundColor = [UIColor clearColor];
		dot2Label.autoresizingMask = UIViewAutoresizingNone;
		dot2Label.font = [UIFont boldSystemFontOfSize:25];
		dot2Label.text = @".";
        dot2Label.textColor = [UIColor blackColor];
        dot2Label.numberOfLines = 1;
		[self addSubview:dot2Label];
        
        sourceButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        sourceButton.titleLabel.font = [UIFont systemFontOfSize:12];
        sourceButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        sourceButton.backgroundColor = [UIColor clearColor];
        [sourceButton addTarget:self action:@selector(onViewSourceButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [sourceButton setTitleColor:[UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:sourceButton];
        
        // NOTE: save button can also act like a delete button
        // create the save button
        saveButton = [[UICustomButton alloc] init];
        saveButton.titleLabel.font = [UIFont systemFontOfSize:12];
        saveButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        saveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        saveButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [saveButton addTarget:self action:@selector(onSaveButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:saveButton];
        
        likeButton = [[UICustomButton alloc] init];
        likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
        likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        likeButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [likeButton addTarget:self action:@selector(onLikeButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [likeButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:likeButton];
        
        // create the liked by button
        likedByButton = [[UITableView alloc] init];
        likedByButton.rowHeight = 70;
        likedByButton.delegate = self;
        likedByButton.dataSource = self;
        likedByButton.allowsSelection = YES;
        likedByButton.scrollEnabled = NO;
        likedByButton.layer.cornerRadius = 5.0f;
        likedByButton.backgroundColor = [UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:0.5];
        [self addSubview:likedByButton];
        
        if (DeviceUtils.isIphone) {
            UIScreen *screen = [UIScreen mainScreen];
            BOOL isHighRes;
            
            if ([screen respondsToSelector:@selector(scale)]) {
                isHighRes = ([screen scale] > 1);
            } else {
                isHighRes = NO;
            }
            
            if (isHighRes) {
                likedByButton.layer.borderWidth = 0.2f;
                descriptionLabel.layer.borderWidth = 0.2f;
            } else {
                likedByButton.layer.borderWidth = 0.4f;
                descriptionLabel.layer.borderWidth = 0.4f;
            }
        }
        
        videoRemovalAllowed = false;
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat titleLabelHeight = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width - 10, 200) lineBreakMode:UILineBreakModeWordWrap].height;
    titleLabel.frame = CGRectMake(5, 5, self.frame.size.width - 10, titleLabelHeight);
    
    videoThumbnail.frame = CGRectMake(5, titleLabelHeight + 15, 106, 80);
    playButton.frame = CGRectMake(((videoThumbnail.frame.size.width - 15) / 2), (((videoThumbnail.frame.size.height - 15) / 2) + titleLabelHeight + 15), 22, 22);
    
    CGFloat descriptionLabelHeight = [descriptionLabel.text 
                                      sizeWithFont:descriptionLabel.font 
                                      constrainedToSize:CGSizeMake(self.frame.size.width - (videoThumbnail.frame.size.width + 20), self.frame.size.height - (titleLabelHeight + 125)) 
                                      lineBreakMode:UILineBreakModeWordWrap].height;
    
    descriptionLabelHeight = MAX(videoThumbnail.frame.size.height, descriptionLabelHeight);
    descriptionLabel.frame = CGRectMake((videoThumbnail.frame.origin.x + videoThumbnail.frame.size.width + 10), 
                                        titleLabelHeight + 15, 
                                        (self.frame.size.width - (videoThumbnail.frame.size.width + 20)), 
                                        descriptionLabelHeight);
    
    CGFloat faviconImageStartPos = MAX((descriptionLabel.frame.origin.y + descriptionLabelHeight), 
                                       (videoThumbnail.frame.origin.y + videoThumbnail.frame.size.height) + 3);
    faviconImage.frame = CGRectMake(10, 
                                    faviconImageStartPos + 5, 
                                    16, 16);
    
    dot1Label.frame = CGRectMake((faviconImage.frame.origin.x + faviconImage.frame.size. width + 5), 
                                 faviconImageStartPos + 3, 
                                 dotLabelWidth, 15);
    
    CGFloat timestampLabelWidth = [timestampLabel.text sizeWithFont:timestampLabel.font].width;
    timestampLabel.frame = CGRectMake((dot1Label.frame.origin.x + dotLabelWidth + 5), 
                                 faviconImageStartPos + 8, 
                                 timestampLabelWidth, 15);
    
    dot2Label.frame = CGRectMake((timestampLabel.frame.origin.x + timestampLabelWidth + 5), 
                                 faviconImageStartPos + 3, 
                                 dotLabelWidth, 15);
    
    CGFloat sourceButtonWidth = [sourceButton.titleLabel.text sizeWithFont:sourceButton.titleLabel.font].width;
    sourceButton.frame = CGRectMake((dot2Label.frame.origin.x + dotLabelWidth + 5), 
                                      faviconImageStartPos + 8, 
                                      sourceButtonWidth, 15);
    
    
    CGFloat buttonWidth = (self.frame.size.width - 45) / 2;
    likeButton.frame = CGRectMake(15, (faviconImage.frame.origin.y + faviconImage.frame.size.height + 10), buttonWidth, 30);
    saveButton.frame = CGRectMake((likeButton.frame.origin.x + likeButton.frame.size.width + 15), 
                                  (faviconImage.frame.origin.y + faviconImage.frame.size.height + 10), 
                                  buttonWidth, 30);
    
    likedByButton.frame = CGRectMake(15, (likeButton.frame.origin.y + likeButton.frame.size.height + 10), 
                                     (self.frame.size.width - 30), 30);
}

- (void) didReceiveMemoryWarning:(bool)forced {
    
}

- (void)dealloc {
    likedByButton.delegate = nil;
    likedByButton.dataSource = nil;
    
    if (videoPlayerView != nil) {
        [videoPlayerView removeFromSuperview];
        videoPlayerView = nil;
    }
    
    [videoThumbnail removeFromSuperview];
    [playButton removeFromSuperview];
    [titleLabel removeFromSuperview];
    [descriptionLabel removeFromSuperview];
    [faviconImage removeFromSuperview];
    [dot1Label removeFromSuperview];
    [timestampLabel removeFromSuperview];
    [likeButton removeFromSuperview];
    [saveButton removeFromSuperview];
    [likeButton removeFromSuperview];
    [sourceButton removeFromSuperview];
    [likedByButton removeFromSuperview];
    
	videoThumbnail = nil;
    playButton = nil;
    titleLabel = nil;
    descriptionLabel = nil;
    faviconImage = nil;
    dot1Label = nil;
    timestampLabel = nil;
    likeButton = nil;
    saveButton = nil;
    sourceButton = nil;
    likedByButton = nil;
    
    [video release];
    video = nil;
    
    if (openLikedByUsersListCallback != nil) {
        [openLikedByUsersListCallback release];
    }
    
    if (onViewSourceClickedCallback != nil) {
        [onViewSourceClickedCallback release];
    }
    
    if (playVideoCallback != nil) {
        [playVideoCallback release];
    }
    
    if (closeVideoPlayerCallback != nil) {
        [closeVideoPlayerCallback release];
    }
    
    if (sendAllVideoFinishedMessageCallback != nil) {
        [sendAllVideoFinishedMessageCallback release];
    }
    
    openLikedByUsersListCallback = nil;       
    onViewSourceClickedCallback = nil;
    playVideoCallback = nil;
    closeVideoPlayerCallback = nil;
    sendAllVideoFinishedMessageCallback = nil;
    
    [super dealloc];
}

// -------------------------------------------------------------------------
//                              Private functions
// -------------------------------------------------------------------------

- (void) createVideoPlayer {
    // create the video player
    videoPlayerView = [[VideoPlayerView alloc] init];
    videoPlayerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    videoPlayerView.hidden = YES;
    videoPlayerView.onCloseButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerCloseButtonClicked)];
    videoPlayerView.onNextButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerNextButtonClicked:)];
    videoPlayerView.onPreviousButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerPreviousButtonClicked:)];
    videoPlayerView.onVideoFinishedCallback = [Callback create:self selector:@selector(onVideoPlaybackFinished:)];
    videoPlayerView.onPlaybackErrorCallback = [Callback create:self selector:@selector(onPlaybackError:)];
    videoPlayerView.onLikeButtonClickedCallback = [Callback create:self selector:@selector(onVideoLiked:)];
    videoPlayerView.onUnlikeButtonClickedCallback = [Callback create:self selector:@selector(onVideoUnliked:)];
    videoPlayerView.onSaveButtonClickedCallback = [Callback create:self selector:@selector(onVideoSaved:)];
    videoPlayerView.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
    videoPlayerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:videoPlayerView];
}

- (NSString*) getPrettyDate:(double)timeSaved {
    if (timeSaved == 0.0) 
        return @"";
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    int diff = now - timeSaved;
    
    if (diff < 0) { // this should not be possible
        return @"";
    } else if (diff < 10) { // 10 seconds
        return @"just now";
    } else if (diff < 60) { // 1 minute
        return [NSString stringWithFormat:@"%d seconds ago", diff];
    } else if (diff < (2 * 60)) {  // 2 minutes     
        return @"a minute ago";
    } else if (diff < (60 * 60)) {  // 1 hour
        return [NSString stringWithFormat:@"%d minutes ago", (diff / 60)];  // divide by number of minutes
    } else if (diff < (2 * 60 * 60)) {  // 2 hours
        return @"an hour ago";
    } else if (diff < (24 * 60 * 60)) { // 1 day
        return [NSString stringWithFormat:@"%d hours ago", (diff / (60 * 60))]; // divide by number of hours
    } else if (diff < (2 * 24 * 60 * 60)) { // 2 days
        return @"Yesterday";
    } else if (diff < (7 * 24 * 60 * 60)) { // 1 week
        return [NSString stringWithFormat:@"%d days ago", (diff / (24 * 60 * 60))]; // divide by number of days
    } else if (diff < (2 * 7 * 24 * 60 * 60)) { // 2 weeks
        return @"last week";
    } else if (diff < (30 * 24 * 60 * 60)) {    // approx. 1 month
        return [NSString stringWithFormat:@"%d weeks ago", (diff / (7 * 24 * 60 * 60))]; // divide by number of weeks
    } else if (diff < (2 * 30 * 24 * 60 * 60)) {    // approx. 2 months
        return @"a month ago";
    } else if (diff < (365 * 24 * 60 * 60)) {   // approx. 1 year
        return [NSString stringWithFormat:@"%d months ago", (diff / (30 * 24 * 60 * 60))]; // divide by number of months
    } else if (diff < (2 * 365 * 24 * 60 * 60)) { // approx. 2 years
        return @"an year ago";
    } else {
        return [NSString stringWithFormat:@"%d years ago", (diff / (365 * 24 * 60 * 60))]; // divide by number of years
    }
}


- (void) downloadThumbnailImage:(ThumbnailObject*) thumbnail  {
    [thumbnail setThumnailImageLoadedCallback:[Callback create:self selector:@selector(onThumbnailImageLoaded:)]];
    [thumbnail performSelector:@selector(loadImage)];
    
}

- (void) downloadFaviconImage:(SourceObject*) sourceObject  {
    [sourceObject setFaviconImageLoadedCallback:[Callback create:self selector:@selector(onFaviconImageLoaded:)]];
    [sourceObject performSelector:@selector(loadImage)];
}

- (void) loadImage {
    if (![[NSThread currentThread] isCancelled]) {
        // set the like and save button images
        [likeButton setImage:[UIImage imageNamed:(video.liked ? @"heart_red_small.png" : @"heart_grey_small.png")] forState:UIControlStateNormal];
        if (!video.saved) {
            [saveButton setImage:[UIImage imageNamed:@"save_video_small.png"] forState:UIControlStateNormal];
        } else if (videoRemovalAllowed) {
            [saveButton setImage:[UIImage imageNamed:@"x_grey_small.png"] forState:UIControlStateNormal];
        } else {
            [saveButton setImage:[UIImage imageNamed:@"check_mark_green_small.png"] forState:UIControlStateNormal];
        }
    }
    
    // set the thumbnail image
    if (video.thumbnail != nil) {
        if (video.thumbnail.thumbnailImage != nil) {
            // make sure the thread was not killed
            if (![[NSThread currentThread] isCancelled]) {
                [videoThumbnail setImage:video.thumbnail.thumbnailImage forState:UIControlStateNormal];
            }
        } else {
            [self performSelector:@selector(downloadThumbnailImage:) withObject:video.thumbnail];
        }
    } else {
        // make sure the thread was not killed
        if (![[NSThread currentThread] isCancelled]) {
            [videoThumbnail setImage:[UIImage imageNamed:@"default_video_icon.png"] forState:UIControlStateNormal];
        }
    }
    
    // bring play button on top of thumbnail
    [self bringSubviewToFront:playButton];
    
    if (video.videoSource != nil) {
        // set the favicon image
        if (video.videoSource.isFaviconImageLoaded) {
            if (video.videoSource.faviconImage != nil) {
                // make sure the thread was not killed
                if (![[NSThread currentThread] isCancelled]) {
                    [faviconImage performSelectorOnMainThread:@selector(setImage:) withObject:video.videoSource.faviconImage waitUntilDone:YES];
                    faviconImage.hidden = NO;
                }
            } else {
                faviconImage.hidden = YES;
            }
        } else {
            [self performSelector:@selector(downloadFaviconImage:) withObject:video.videoSource];
        }
        
        // set the source name
        if (video.videoSource.sourceUrl != nil && video.videoSource.name != nil) {
            //            sourceButton = NO;
            [sourceButton setTitle:[NSString stringWithFormat:@"Watch on %@", video.videoSource.name] forState:UIControlStateNormal];
        }
    }
}

- (void) updateLikeButton {
    [likeButton setImage:[UIImage imageNamed:(video.liked ? @"heart_red_small.png" : @"heart_grey_small.png")] forState:UIControlStateNormal];
    [likeButton setTitle:(video.liked ? @"Unlike" : @"Like") forState:UIControlStateNormal];
}

- (void) updateSaveButton {
    if (!video.saved) {
        [saveButton setImage:[UIImage imageNamed:@"save_video_small.png"] forState:UIControlStateNormal];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
        [saveButton setEnabled:YES];
    } else if(videoRemovalAllowed) {
        [saveButton setImage:[UIImage imageNamed:@"x_grey_small.png"] forState:UIControlStateNormal];
        [saveButton setTitle:@"Remove" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
        [saveButton setEnabled:YES];
    } else {
        video.savedInCurrentTab = true;
        [saveButton setImage:[UIImage imageNamed:@"check_mark_green_small.png"] forState:UIControlStateNormal];
        [saveButton setTitle:@"Saved" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:(73.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
        [saveButton setEnabled:NO];
    }
}

// --------------------------------------------------------------------------------
//                            Tracking requests
// --------------------------------------------------------------------------------

- (void) trackAction:(NSString*)action forVideo:(int)vid {
    TrackerRequest* trackerRequest = [[[TrackerRequest alloc] init] autorelease];
    [trackerRequest doTrackActionRequest:action forVideoId:vid from:@"SavedTab"];
}

- (void) trackEvent:(NSString*)name withValue:(NSString*)value {
    TrackerRequest* trackerRequest = [[[TrackerRequest alloc] init] autorelease];
    [trackerRequest doTrackEventRequest:name withValue:value from:@"SavedTab"];
}

- (void) trackError:(NSString*)error from:(NSString*)where withMessage:(NSString*)message {
    TrackerRequest* trackerRequest = [[[TrackerRequest alloc] init] autorelease];
    [trackerRequest doTrackErrorRequest:message from:where andError:error];
}

// --------------------------------------------------------------------------------
//                            Video requests
// --------------------------------------------------------------------------------

- (void) onVideoLiked {
    VideoRequest* likeRequest = [[[VideoRequest alloc] init] autorelease];
    likeRequest.errorCallback = [Callback create:self selector:@selector(onLikeVideoRequestFailed:)];
    likeRequest.successCallback = [Callback create:self selector:@selector(onLikeVideoRequestSuccess:)];
    [likeRequest likeVideo:video.videoId];
}

- (void) onVideoUnliked {
    VideoRequest* unlikeRequest = [[[VideoRequest alloc] init] autorelease];
    unlikeRequest.errorCallback = [Callback create:self selector:@selector(onUnlikeVideoRequestFailed:)];
    unlikeRequest.successCallback = [Callback create:self selector:@selector(onUnlikeVideoRequestSuccess:)];
    [unlikeRequest unlikeVideo:video.videoId];
}

- (void) onVideoSaved {
    VideoRequest* saveRequest = [[[VideoRequest alloc] init] autorelease];
    saveRequest.errorCallback = [Callback create:self selector:@selector(onAddVideoRequestFailed:)];
    saveRequest.successCallback = [Callback create:self selector:@selector(onAddVideoRequestSuccess:)];
    [saveRequest addVideo:video.videoId];
}

- (void) onVideoRemoved {
    VideoRequest* removeRequest = [[[VideoRequest alloc] init] autorelease];
    removeRequest.errorCallback = [Callback create:self selector:@selector(onDeleteRequestFailed:)];
    removeRequest.successCallback = [Callback create:self selector:@selector(onDeleteRequestSuccess:)];
    [removeRequest deleteVideo:video.videoId];
}

// --------------------------------------------------------------------------------
//                      Video request callbacks
// --------------------------------------------------------------------------------

- (void) onLikeVideoRequestSuccess: (VideoResponse*)response {
	if (response.success) {
        int videoId = [[response.videoResponse objectForKey:@"id"] intValue];
        if (videoId == video.videoId) {
            [video updateFromDictionary:response.videoResponse];
            [self updateLikeButton];
            [self trackAction:@"like" forVideo:videoId];
        }
	} else {
		LOG_ERROR(@"request success but failed to like video: %@", response.errorMessage);
	}
}

- (void) onLikeVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to like video: %@", errorMessage);
}

- (void) onUnlikeVideoRequestSuccess: (VideoResponse*)response {
	if (response.success) {
        int videoId = [[response.videoResponse objectForKey:@"id"] intValue];
        if (videoId == video.videoId) {
            [video updateFromDictionary:response.videoResponse];
            [self updateLikeButton];
            [self trackAction:@"unlike" forVideo:videoId];
        }
        
    } else {
        LOG_ERROR(@"request success but failed to unlike video: %@", response.errorMessage);
    }
}

- (void) onUnlikeVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to unlike video: %@", errorMessage);
}

- (void) onAddVideoRequestSuccess: (VideoResponse*)response {
    if (response.success) {
        int videoId = [[response.videoResponse objectForKey:@"id"] intValue];
        if (videoId == video.videoId) {
            [video updateFromDictionary:response.videoResponse];
            [self updateSaveButton];
            [self trackAction:@"save" forVideo:videoId];
        }
    } else {
        LOG_ERROR(@"request success but failed to save video: %@", response.errorMessage);
    }
}

- (void) onAddVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to save video: %@", errorMessage);
}

- (void) onDeleteRequestSuccess: (VideoResponse*)response {
	if (response.success) {
		int videoId = [[response.videoResponse objectForKey:@"id"] intValue];
        if (videoId == video.videoId) {
            [video updateFromDictionary:response.videoResponse];
            [self updateSaveButton];
            [self trackAction:@"remove" forVideo:videoId];
        }
	} else {
		LOG_ERROR(@"request success but failed to delete video: %@", response.errorMessage);
	}
}

- (void) onDeleteRequestFailed: (NSString*)errorMessage {
	LOG_ERROR(@"failed to delete video: %@", errorMessage);
}

// --------------------------------------------------------------------------------
//                             Button Callbacks
// --------------------------------------------------------------------------------

- (void) onPlayButtonClicked:(UIButton*)sender {
    if (playVideoCallback != nil) {
        [playVideoCallback execute:video];
        [self trackAction:@"view" forVideo:video.videoId];
    }
}

- (void) onLikeButtonClicked:(UIButton*)sender {
    if (video.liked) {
        [self onVideoUnliked];
    } else {
        [self onVideoLiked];
    }
}

- (void) onSaveButtonClicked:(UIButton*)sender {
    if (!video.saved) {
        [self onVideoSaved];
    } else if (videoRemovalAllowed) {
        [self onVideoRemoved];
    }
}

- (void) onViewSourceButtonClicked:(UIButton*)sender {
    if (onViewSourceClickedCallback != nil) {
        if (video.hostUrl != nil) {
            [onViewSourceClickedCallback execute:video.hostUrl];
        } else {
            [onViewSourceClickedCallback execute:video.videoUrl];
        }
    }
}

// --------------------------------------------------------------------------------
//                             Callbacks
// --------------------------------------------------------------------------------

- (void) onThumbnailImageLoaded:(UIImage*)thumbnailImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (thumbnailImage == nil) {
        thumbnailImage = [UIImage imageNamed:@"default_video_icon"];
    }
    
    if (![[NSThread currentThread] isCancelled]) {
        [videoThumbnail setImage:thumbnailImage forState:UIControlStateNormal];
    }
    [pool release];
}

- (void) onFaviconImageLoaded:(UIImage*)favicon {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (favicon != nil) {
        if (![[NSThread currentThread] isCancelled]) {
            [faviconImage performSelectorOnMainThread:@selector(setImage:) withObject:favicon waitUntilDone:YES];
            faviconImage.hidden = NO;
        }
    } else {
        faviconImage.hidden = YES;
    }
    [pool release];
}

// --------------------------------------------------------------------------------
//                             Video player callbacks
// --------------------------------------------------------------------------------

- (void) onVideoPlayerCloseButtonClicked {
    if (closeVideoPlayerCallback != nil) {
        [closeVideoPlayerCallback execute:nil];
    }
}

- (void) onVideoPlayerNextButtonClicked:(VideoObject*) videoObject {
    if (sendAllVideoFinishedMessageCallback != nil) {
        [sendAllVideoFinishedMessageCallback execute:[NSNumber numberWithBool:YES]];
    }
}

- (void) onVideoPlayerPreviousButtonClicked:(VideoObject*) videoObject {
    if (sendAllVideoFinishedMessageCallback != nil) {
        [sendAllVideoFinishedMessageCallback execute:[NSNumber numberWithBool:NO]];
    }
}

- (void) onVideoPlaybackFinished:(VideoObject*) videoObject {
    [self onVideoPlayerNextButtonClicked:videoObject];
}

- (void) onPlaybackError:(VideoObject*) videoObject {
    
}

- (void) onVideoLiked:(VideoObject*) videoObject {
    [self onVideoLiked];
}

- (void) onVideoUnliked:(VideoObject*) videoObject {
    [self onVideoUnliked];
}

- (void) onVideoSaved:(VideoObject*) videoObject {
    [self onVideoSaved];
}

- (void) onViewSourceClicked:(VideoObject*) videoObject {
    [self onViewSourceButtonClicked:nil];
}

// --------------------------------------------------------------------------------
//                      Table view delegate
// --------------------------------------------------------------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LikedByButtonCell";
	
	// try to reuse an id
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // Create the cell
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
	
	cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.text = [NSString stringWithFormat:@"Liked by %d %@", video.likes, ((video.likes > 1) ? @"people" : @"person")];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
	cell.textLabel.textColor = [UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (openLikedByUsersListCallback != nil) {
        [openLikedByUsersListCallback execute:[NSNumber numberWithInt:video.videoId]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// -------------------------------------------------------------------------
//                              Public functions
// -------------------------------------------------------------------------
- (void) setVideoObject:(VideoObject*)videoObject shouldAllowVideoRemoval:(BOOL)allowVideoRemoval {
    // LOG_DEBUG(@"Drawing the cell");
	if (video) {
        [video.thumbnail resetThumnailImageLoadedCallback];
        [video.videoSource resetFaviconImageLoadedCallback];
        [video release];
    }
    
	video = [videoObject retain];
    faviconImage.hidden = YES;
    videoRemovalAllowed = allowVideoRemoval;
    
	// change text
	titleLabel.text = video.title;
	if (video.description != nil) {
        descriptionLabel.text = video.description;
	}
    
    if (!video.saved) {
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
        [saveButton setEnabled:YES];
    } else if (allowVideoRemoval) {
        [saveButton setTitle:@"Remove" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
        [saveButton setEnabled:YES];
    } else {
        [saveButton setTitle:@"Saved" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:(73.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
        [saveButton setEnabled:NO];
    }
    
    if (video.liked) {
        [likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
    } else {
        [likeButton setTitle:@"Like" forState:UIControlStateNormal];
    }
    
    // update timestamp
    timestampLabel.text = [self getPrettyDate:video.timestamp];
    
    if (video.likes > 0) {
        likedByButton.hidden = NO;
    } else {
        likedByButton.hidden = YES;
    }
    
	// update image
	[self loadImage];
} 

- (void) setVideoPlayerViewControllerCallbacks:(VideoPlayerViewController*)videoPlayerViewController {
    videoPlayerViewController.onCloseButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerCloseButtonClicked)];
    videoPlayerViewController.onNextButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerNextButtonClicked:)];
    videoPlayerViewController.onPreviousButtonClickedCallback = [Callback create:self selector:@selector(onVideoPlayerPreviousButtonClicked:)];
    videoPlayerViewController.onVideoFinishedCallback = [Callback create:self selector:@selector(onVideoPlaybackFinished:)];
    videoPlayerViewController.onPlaybackErrorCallback = [Callback create:self selector:@selector(onPlaybackError:)];
    videoPlayerViewController.onLikeButtonClickedCallback = [Callback create:self selector:@selector(onVideoLiked:)];
    videoPlayerViewController.onUnlikeButtonClickedCallback = [Callback create:self selector:@selector(onVideoUnliked:)];
    videoPlayerViewController.onSaveButtonClickedCallback = [Callback create:self selector:@selector(onVideoSaved:)];
    videoPlayerViewController.onViewSourceClickedCallback = [Callback create:self selector:@selector(onViewSourceClicked:)];
}

@end
