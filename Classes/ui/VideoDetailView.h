//
//  ConnectMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>
#import "UserListView.h"
#import "VideoPlayerView.h"
#import "UICustomButton.h"
#import "VideoPlayerViewController.h"

@interface VideoDetailView : UIView<UITableViewDelegate, UITableViewDataSource> {
    UIButton*           videoThumbnail;
    UIButton*           playButton;
	UILabel*            titleLabel;
	UITextView*         descriptionLabel;
    UIImageView*        faviconImage;
    UILabel*            dot1Label;
    UILabel*            timestampLabel;
    UILabel*            dot2Label;
    UIButton*           sourceButton;
    UICustomButton*     likeButton;
    UICustomButton*     saveButton;
    UITableView*        likedByButton;
    VideoPlayerView*    videoPlayerView;
    
    VideoObject*        video;
    CGFloat             dotLabelWidth;
    BOOL                videoRemovalAllowed;
}

@property(retain) Callback* openLikedByUsersListCallback;
@property(retain) Callback* onViewSourceClickedCallback;
@property(retain) Callback* playVideoCallback;
@property(retain) Callback* closeVideoPlayerCallback;
@property(retain) Callback* sendAllVideoFinishedMessageCallback;

- (void) setVideoObject:(VideoObject*)videoObject shouldAllowVideoRemoval:(BOOL)allowVideoRemoval;
- (void) didReceiveMemoryWarning:(bool)forced;
- (void) setVideoPlayerViewControllerCallbacks:(VideoPlayerViewController*)videoPlayerViewController;

@end
