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
    UILabel* sourceLabel;
	UILabel* likesLabel;
    UIImageView* likeImageView;
    
	Callback* playVideoCallback;
    Callback* likeVideoCallback;
    Callback* unlikeVideoCallback;
    
    NSThread* imageThread;
}

@property(retain) Callback* playVideoCallback;
@property(retain) Callback* likeVideoCallback;
@property(retain) Callback* unlikeVideoCallback;

- (void) setVideoObject: (VideoObject*)video;
- (void) updateLikeButton: (VideoObject*)video;
- (void) loadImage;

@end
