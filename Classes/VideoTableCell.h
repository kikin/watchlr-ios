//
//  VideoTableCell.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoObject.h"
#import <CommonIos/Callback.h>

@interface VideoTableCell : UITableViewCell {
	VideoObject* videoObject;
	UILabel* titleLabel;
	UILabel* descriptionLabel;
	UIImageView* videoImageView;
	Callback* deleteCallback;
}

@property(retain) Callback* deleteCallback;

- (IBAction) onClickDelete;
- (void)setVideoObject: (VideoObject*)video;

@end
