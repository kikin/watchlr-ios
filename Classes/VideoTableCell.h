//
//  VideoTableCell.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoObject.h"

@interface VideoTableCell : UITableViewCell {
	VideoObject* videoObject;
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UIImageView *videoImageView;
	
	id deleteHandlerObject;
	SEL deleteHandlerSelector;
}

@property(nonatomic,copy) VideoObject* videoObject;
@property(nonatomic,retain) UILabel *titleLabel;
@property(nonatomic,retain) UILabel *descriptionLabel;
@property(nonatomic,retain) UIImageView *videoImageView;

@property(nonatomic,copy) id deleteHandlerObject;
@property(nonatomic) SEL deleteHandlerSelector;

- (IBAction) onClickDelete;
- (void)setDeleteCallback: (id)instance callback:(SEL)callback;
- (void)setVideoObject: (VideoObject*)video;

@end
