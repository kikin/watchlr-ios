//
//  VideoTableCell.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>

#import "LikeVideoRequest.h"
#import "UnlikeVideoRequest.h"
#import "VideoObject.h"

@interface VideoTableCell : UITableViewCell {
	VideoObject* videoObject;
	
    UIImageView* videoImageView;
    UIImageView* playButtonImage;
    UILabel* titleLabel;
	UILabel* descriptionLabel;
    UIImageView* faviconImageView;
    UILabel* sourceLabel;
	UILabel* likesLabel;
    UIImageView* likeImageView;
    
	Callback* playVideoCallback;
    
    LikeVideoRequest* likeVideoRequest;
    UnlikeVideoRequest* unlikeVideoRequest;
    
	NSThread* imageThread;
}

@property(retain) Callback* playVideoCallback;

- (void)setVideoObject: (VideoObject*)video;
- (void) loadImage;

- (void) onLikeVideoRequestSuccess: (LikeVideoResponse*)response;
- (void) onLikeVideoRequestFailed: (NSString*)errorMessage;
- (void) onUnlikeVideoRequestSuccess: (UnlikeVideoResponse*)response;
- (void) onUnlikeVideoRequestFailed: (NSString*)errorMessage;


@end
