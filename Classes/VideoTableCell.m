//
//  VideoTableCell.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoTableCell.h"


@implementation VideoTableCell

@synthesize videoObject, titleLabel, descriptionLabel, videoImageView, deleteHandlerObject, deleteHandlerSelector;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		self.deleteHandlerObject = nil;
		self.deleteHandlerSelector = nil;
	}
    return self;
}

- (IBAction) onClickDelete {
	if (deleteHandlerObject != nil) {
		[deleteHandlerObject performSelector:deleteHandlerSelector withObject:videoObject];
	}
}

- (void) loadImage: (NSString*)imageUrl {
	NSURL *url = [NSURL URLWithString:imageUrl];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [[UIImage alloc] initWithData:data];
	videoImageView.image = img;	
}

- (void)setDeleteCallback: (id)instance callback:(SEL)callback {
	deleteHandlerSelector = callback;
	deleteHandlerObject = instance;
}

- (void)setVideoObject: (VideoObject*)video {
	videoObject = video;
	titleLabel.text = video.title;
	descriptionLabel.text = video.description;
	
	NSThread* myThread = [[NSThread alloc] initWithTarget:self
		selector:@selector(loadImage:)
		object:video.imageUrl];
	[myThread start];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)dealloc {
    [super dealloc];
}


@end
