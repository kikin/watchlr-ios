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
		titleLabel.frame = CGRectMake(180, 12, self.frame.size.width-20, 20);
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		titleLabel.font = [UIFont boldSystemFontOfSize:18];
		titleLabel.text = @"title";
		[self addSubview:titleLabel];
		
		// create the description
		descriptionLabel = [[UILabel alloc] init];
		descriptionLabel.backgroundColor = [UIColor clearColor];
		descriptionLabel.frame = CGRectMake(180, 35, self.frame.size.width-190, 55);
		descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		descriptionLabel.font = [UIFont systemFontOfSize:15];
		descriptionLabel.numberOfLines = 5;
		descriptionLabel.text = @"description";
		[self addSubview:descriptionLabel];
		
		// create the image
		videoImageView = [[UIImageView alloc] init];
		videoImageView.frame = CGRectMake(10, 10, 160, 120);
		[self addSubview:videoImageView];
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
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	NSURL *url = [NSURL URLWithString:imageUrl];
	NSData *data = [NSData dataWithContentsOfURL:url];
	UIImage *img = [[UIImage alloc] initWithData:data];
	
	[videoImageView performSelectorOnMainThread:@selector(setImage:) withObject:img waitUntilDone:YES];
	
	[img release];
    [pool release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	CGRect newFrame = descriptionLabel.frame;
	newFrame.size.width = editing ? self.frame.size.width-350 : self.frame.size.width-190;
	
	if (animated) {
		[UIView beginAnimations:@"ResizeDescription" context:nil];
		{
			[UIView setAnimationDuration:0.25];
			descriptionLabel.frame = newFrame;
		}
		[UIView commitAnimations];
	} else {
		descriptionLabel.frame = newFrame;
	}
	
	[super setEditing:editing animated:animated];
}

- (void) fixHeightOfDescription {
	CGSize maximumSize = CGSizeMake(self.editing ? self.frame.size.width-350 : self.frame.size.width-190, 100);
	CGSize dateStringSize = [descriptionLabel.text sizeWithFont:descriptionLabel.font constrainedToSize:maximumSize lineBreakMode:descriptionLabel.lineBreakMode];
	CGRect newFrame = CGRectMake(180, 35, self.frame.size.width-190, dateStringSize.height);
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
		[self fixHeightOfDescription];
		//descriptionLabel.backgroundColor = [UIColor yellowColor];
	}
	
	// update image
	videoImageView.image = nil;
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
