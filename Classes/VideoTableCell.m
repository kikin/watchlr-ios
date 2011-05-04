//
//  VideoTableCell.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoTableCell.h"

@implementation VideoTableCell

@synthesize deleteCallback;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		// create the title
		titleLabel = [[UILabel alloc] init];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		titleLabel.font = [UIFont boldSystemFontOfSize:18];
		titleLabel.text = @"title";
		[self addSubview:titleLabel];
		
		// create the description
		descriptionLabel = [[UILabel alloc] init];
		descriptionLabel.backgroundColor = [UIColor clearColor];
		descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		descriptionLabel.font = [UIFont systemFontOfSize:15];
		descriptionLabel.text = @"description";
		[self addSubview:descriptionLabel];
		
		// create the image
		videoImageView = [[UIImageView alloc] init];
		[self addSubview:videoImageView];
		
		// set size/positions
		if (DeviceUtils.isIphone) {
			videoImageView.frame = CGRectMake(10, 10, 106, 80);
			titleLabel.frame = CGRectMake(126, 12, self.frame.size.width-136, 20);
			descriptionLabel.frame = CGRectMake(126, 35, self.frame.size.width-136, 60);
			descriptionLabel.numberOfLines = 3;
		} else {
			videoImageView.frame = CGRectMake(10, 10, 160, 120);
			titleLabel.frame = CGRectMake(180, 12, self.frame.size.width-190, 20);
			descriptionLabel.frame = CGRectMake(180, 35, self.frame.size.width-190, 100);
			descriptionLabel.numberOfLines = 5;
		}
	}
    return self;
}

- (IBAction) onClickDelete {
	if (deleteCallback != nil) {
		// execute the delete callback
		[deleteCallback execute:videoObject];
	}
}

- (void) loadImage: (NSString*)imageUrl {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	NSURL* url = [NSURL URLWithString:imageUrl];
	NSData* data = [NSData dataWithContentsOfURL:url];
	if (data != nil) {
		UIImage* img = [[UIImage alloc] initWithData:data];
		if (img != nil) {
			[videoImageView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
			[img release];
		}
	}
	
	[pool release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	int normalWidth = DeviceUtils.isIphone ? 136 : 190,
		buttonWidth = 160;
	
	// create new frame
	CGRect newFrame = descriptionLabel.frame;
	newFrame.size.width = editing ? self.frame.size.width-normalWidth-buttonWidth : self.frame.size.width-normalWidth;
	
	if (animated) {
		// do the animation
		[UIView beginAnimations:@"ResizeDescription" context:nil];
		{
			[UIView setAnimationDuration:0.25];
			descriptionLabel.frame = newFrame;
		}
		[UIView commitAnimations];
	} else {
		// directly update the size
		descriptionLabel.frame = newFrame;
	}
	
	[super setEditing:editing animated:animated];
}

- (void) fixHeightOfDescription {
	int normalWidth = DeviceUtils.isIphone ? 136 : 190,
		normalHeight = DeviceUtils.isIphone ? 60 : 100,
		buttonWidth = 160;
	
	CGSize maximumSize = CGSizeMake(self.editing ? self.frame.size.width-normalWidth-buttonWidth : self.frame.size.width-normalWidth, normalHeight);
	CGSize dateStringSize = [descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:maximumSize lineBreakMode:descriptionLabel.lineBreakMode];
	CGRect newFrame = CGRectMake(descriptionLabel.frame.origin.x, descriptionLabel.frame.origin.y, self.frame.size.width-normalWidth, dateStringSize.height);
	descriptionLabel.frame = newFrame;
}

- (void)setVideoObject: (VideoObject*)video {
	// change video object
	if (videoObject) [videoObject release];
	videoObject = [video retain];
	
	// change text
	titleLabel.text = video.title;
	if (video.description != nil) {
		NSString* description = [video.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		descriptionLabel.text = description;
		[self performSelectorOnMainThread:@selector(fixHeightOfDescription) withObject:nil waitUntilDone:NO];
		//descriptionLabel.backgroundColor = [UIColor yellowColor];
	}
	
	// update image
	videoImageView.image = [UIImage imageNamed:@"NoImage.png"];
	NSThread* myThread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage:) object:video.imageUrl];
	[myThread start];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[titleLabel release];
	[descriptionLabel release];
	[videoImageView release];
	[videoObject release];
    [super dealloc];
}


@end
