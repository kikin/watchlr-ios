//
//  VideoTableCell.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>

#import "VideoObject.h"

@interface VideoTableCell : UITableViewCell {
	VideoObject* videoObject;
	
    UIImageView* videoImageView;
    UIImageView* playButtonImage;
    UILabel* titleLabel;
	UILabel* descriptionLabel;
    UIImageView* faviconImageView;
    UILabel* dotLabel1;
    UILabel* timestampLabel;
    UILabel* dotLabel2;
    UILabel* sourceLabel;
	UILabel* likesLabel;
    UIImageView* likeImageView;
    UIImageView* saveImageView;
    
	Callback* playVideoCallback;
    Callback* likeVideoCallback;
    Callback* unlikeVideoCallback;
    Callback* addVideoCallback;
    Callback* viewSourceCallback;
    
    NSThread* imageThread;
}

@property(retain) Callback* playVideoCallback;
@property(retain) Callback* likeVideoCallback;
@property(retain) Callback* unlikeVideoCallback;
@property(retain) Callback* addVideoCallback;
@property(retain) Callback* viewSourceCallback;

- (void) setVideoObject: (VideoObject*)video;
- (void) updateLikeButton: (VideoObject*)video;
- (void) updateSaveButton: (VideoObject*)video;
- (void) loadImage;

- (NSString*) getPrettyDate:(double)timeSaved;

@end
