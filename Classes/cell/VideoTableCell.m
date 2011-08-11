//
//  VideoTableCell.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoTableCell.h"
#import "ThumbnailObject.h"
#import "SourceObject.h"
#import "LikeVideoResponse.h"

@implementation VideoTableCell

@synthesize playVideoCallback, likeVideoCallback, unlikeVideoCallback;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Auto resize the views
        self.contentView.autoresizesSubviews = YES;
        
        // create the image
		videoImageView = [[UIImageView alloc] init];
		playButtonImage = [[UIImageView alloc] init];
		[self addSubview:playButtonImage];
        [self addSubview:videoImageView];
        
        // create the title
		titleLabel = [[UILabel alloc] init];
		titleLabel.backgroundColor = [UIColor clearColor];
		titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		titleLabel.text = @"title";
		[self addSubview:titleLabel];
        
        // create the number of likes label
		likesLabel = [[UILabel alloc] init];
		likesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        likesLabel.text = [[NSNumber numberWithInt:1] stringValue];
        likesLabel.textColor = [UIColor colorWithRed:(204.0/255.0) green:(204.0/255.0) blue:(204.0/255.0) alpha:1.0];
        likesLabel.textAlignment = UITextAlignmentRight;
        likesLabel.numberOfLines = 1;
		[self addSubview:likesLabel];
        
        // Create the favicon image
        faviconImageView = [[UIImageView alloc] init];
        faviconImageView.autoresizingMask = UIViewAutoresizingNone;
        [faviconImageView setBackgroundColor:[UIColor clearColor]];
		[self addSubview:faviconImageView];
        faviconImageView.hidden = YES;
        
        // Create the source label
        sourceLabel = [[UILabel alloc] init];
		sourceLabel.backgroundColor = [UIColor clearColor];
		sourceLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		sourceLabel.font = [UIFont systemFontOfSize:12];
		sourceLabel.text = @"source";
        sourceLabel.numberOfLines = 1;
		[self addSubview:sourceLabel];
        sourceLabel.hidden = YES;
		
		// create the like button
        likeImageView = [[UIImageView alloc] init];
        likeImageView.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:likeImageView];
        
        // set size/positions
		if (DeviceUtils.isIphone) {
			videoImageView.frame = CGRectMake(10, 10, 106, 80);
			playButtonImage.frame = CGRectMake(((videoImageView.frame.size.width - 30) / 2), ((videoImageView.frame.size.height - 32) / 2), 50, 50);
            
            titleLabel.font = [UIFont boldSystemFontOfSize:12];
            titleLabel.lineBreakMode = UILineBreakModeCharacterWrap | UILineBreakModeTailTruncation;
            titleLabel.numberOfLines = 3;
            
            likesLabel.font = [UIFont boldSystemFontOfSize:20];
		} else {
			videoImageView.frame = CGRectMake(10, 10, 160, 120);
            playButtonImage.frame = CGRectMake(((videoImageView.frame.size.width - 30) / 2), ((videoImageView.frame.size.height - 32) / 2), 50, 50);
            
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            titleLabel.numberOfLines = 1;
            
            // create the description
            descriptionLabel = [[UILabel alloc] init];
            descriptionLabel.backgroundColor = [UIColor clearColor];
            descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            descriptionLabel.font = [UIFont systemFontOfSize:15];
            descriptionLabel.text = @"description";
            descriptionLabel.lineBreakMode = UILineBreakModeCharacterWrap | UILineBreakModeTailTruncation;
            descriptionLabel.textAlignment = UITextAlignmentLeft;
            descriptionLabel.baselineAdjustment = UIBaselineAdjustmentNone;
            descriptionLabel.numberOfLines = 3;
            [self addSubview:descriptionLabel];
            
            likesLabel.font = [UIFont boldSystemFontOfSize:30];
		}
	}
    return self;
}

- (void) onThumbnailImageLoaded:(UIImage*)thumbnailImage {
     NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (thumbnailImage == nil) {
        thumbnailImage = [UIImage imageNamed:@"default_video_icon"];
    }
    
    if (![[NSThread currentThread] isCancelled]) {
        [videoImageView performSelectorOnMainThread:@selector(setImage:) withObject:thumbnailImage waitUntilDone:YES];
    }
    [pool release];
}

- (void) onFaviconImageLoaded:(UIImage*)faviconImage {
     NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (faviconImage != nil) {
        if (![[NSThread currentThread] isCancelled]) {
            [faviconImageView performSelectorOnMainThread:@selector(setImage:) withObject:faviconImage waitUntilDone:YES];
            faviconImageView.hidden = NO;
        }
    } else {
        faviconImageView.hidden = YES;
    }
    [pool release];
}

- (void) loadImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if (![[NSThread currentThread] isCancelled]) {
        // update play button image
        [playButtonImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"play_button.png"] waitUntilDone:YES];
        
        // update like button
        [likeImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:(videoObject.liked ? @"heart_red.png" : @"heart_grey.png")] waitUntilDone:YES];
    }
	
    // set the thumbnail image
    if (videoObject.thumbnail != nil) {
        if (videoObject.thumbnail.thumbnailImage != nil) {
            // make sure the thread was not killed
            if (![[NSThread currentThread] isCancelled]) {
                [videoImageView performSelectorOnMainThread:@selector(setImage:) withObject:(videoObject.thumbnail.thumbnailImage) waitUntilDone:YES];
            }
        } else {
            videoObject.thumbnail.onThumbnailImageLoaded = [Callback create:self selector:@selector(onThumbnailImageLoaded:)];
        }
    } else {
        // make sure the thread was not killed
        if (![[NSThread currentThread] isCancelled]) {
            [videoImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"default_video_icon.png"] waitUntilDone:YES];
        }
    }

    // bring play button on top of thumbnail
    [self bringSubviewToFront:playButtonImage];
    
    if (videoObject.videoSource != nil) {
        // set the favicon image
        if (videoObject.videoSource.isFaviconImageLoaded) {
            if (videoObject.videoSource.faviconImage != nil) {
                // make sure the thread was not killed
                if (![[NSThread currentThread] isCancelled]) {
                    [faviconImageView performSelectorOnMainThread:@selector(setImage:) withObject:videoObject.videoSource.faviconImage waitUntilDone:YES];
                    faviconImageView.hidden = NO;
                }
            } else {
                faviconImageView.hidden = YES;
            }
        } else {
            videoObject.videoSource.onFaviconImageLoaded = [Callback create:self selector:@selector(onFaviconImageLoaded:)];
        }
        
        // set the source name
        if (videoObject.videoSource.name != nil) {
            sourceLabel.text = videoObject.videoSource.name;
            sourceLabel.hidden = NO;
        }
    }
    
    [pool release];
}

- (void) fixSize {
	if (DeviceUtils.isIphone) {
        
        int thumbnailWidth = 125;
        int	faviconAndSourceHeight = 20;
        int titleHeight = 50;
        
        // set the size for title label
        titleLabel.frame = CGRectMake(thumbnailWidth, 12, (self.frame.size.width - (thumbnailWidth + 10)), titleHeight);
        
        // set the size for likes label
        likesLabel.frame = CGRectMake((self.frame.size.width - 68), self.frame.size.height - (faviconAndSourceHeight + 10), 35, 20);
        
        // set the size for like/unlike button
        likeImageView.frame = CGRectMake((self.frame.size.width - 30), self.frame.size.height - (faviconAndSourceHeight + 10), 20, 20);
        
        // set the size for favicon image
        faviconImageView.frame = CGRectMake(thumbnailWidth, self.frame.size.height - (faviconAndSourceHeight + 5), 15, 15);
        
        // set the size for source label
        sourceLabel.frame = CGRectMake((thumbnailWidth + 20), self.frame.size.height - (faviconAndSourceHeight + 5), (self.frame.size.width - (thumbnailWidth + 20)), 15);
        
    } else {
        
        int titleAndDescriptionLabelWidth = 310;
        int	faviconAndSourceHeight = 30;
        int titleHeight = 20;
        
        // set the size for title label
        titleLabel.frame = CGRectMake(180, 12, (self.frame.size.width - titleAndDescriptionLabelWidth), titleHeight);
        
        descriptionLabel.frame = CGRectMake(180, 20, (self.frame.size.width - titleAndDescriptionLabelWidth), (self.frame.size.height - (titleHeight + faviconAndSourceHeight + 10)));
        
        // set the size for likes label
        likesLabel.frame = CGRectMake((self.frame.size.width - 110), 10, 55, 30);
        
        // set the size for like/unlike button
        likeImageView.frame = CGRectMake((self.frame.size.width - 50), 10, 30, 30);
        
        // set the size for favicon image
        faviconImageView.frame = CGRectMake(180, self.frame.size.height - (faviconAndSourceHeight + 5), 15, 15);
        
        // set the size for source label
        sourceLabel.frame = CGRectMake(200, self.frame.size.height - (faviconAndSourceHeight + 5), (self.frame.size.width - (titleAndDescriptionLabelWidth + 20)), 15);
        
    }
    
    
}

- (void)setVideoObject: (VideoObject*)video {
	// change video object
    // LOG_DEBUG(@"Drawing the cell");
	if (videoObject) [videoObject release];
	videoObject = [video retain];
    faviconImageView.hidden = YES;
	
	// change text
	titleLabel.text = video.title;
	if (video.description != nil) {
		NSString* description = [video.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
        if (!DeviceUtils.isIphone) 
            descriptionLabel.text = description;
        
		[self performSelectorOnMainThread:@selector(fixSize) withObject:nil waitUntilDone:NO];
		//descriptionLabel.backgroundColor = [UIColor yellowColor];
	}
    
    if (videoObject.likes > 0) {
        likesLabel.hidden = NO;
        likesLabel.text = [[NSNumber numberWithInt:videoObject.likes] stringValue];
    } else {
        likesLabel.hidden = YES;
    }
    
    if (videoObject.liked) {
        likesLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
    } else {
        likesLabel.textColor = [UIColor colorWithRed:(204.0/255.0) green:(204.0/255.0) blue:(204.0/255.0) alpha:1.0];
    }
    
	
	// update image
	videoImageView.image = [UIImage imageNamed:@"NoImage.png"];
	
	/*if (imageThread) {
        if (![imageThread isFinished]) {
            [imageThread cancel];
        }
        
		[imageThread release];
	}
    
    imageThread = [[NSThread alloc] initWithTarget:self selector:@selector(loadImage) object:nil];
	[imageThread start];*/
    [self loadImage];
}

- (void) updateLikeButton: (VideoObject*)video {
    if (videoObject) [videoObject release];
	videoObject = [video retain];
    
    if (videoObject.likes > 0) {
        likesLabel.hidden = NO;
        likesLabel.text = [[NSNumber numberWithInt:videoObject.likes] stringValue];
    } else {
        likesLabel.hidden = YES;
    }
    
    if (videoObject.liked) {
        likesLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        [likeImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"heart_red.png"] waitUntilDone:YES];
    } else {
        likesLabel.textColor = [UIColor colorWithRed:(204.0/255.0) green:(204.0/255.0) blue:(204.0/255.0) alpha:1.0];
        [likeImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"heart_grey.png"] waitUntilDone:YES];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self performSelectorOnMainThread:@selector(fixSize) withObject:nil waitUntilDone:NO];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *myTouch in touches)
    {
        CGPoint touchLocation = [myTouch locationInView:self];
        
        CGRect thumbnailRect = [videoImageView bounds];
        thumbnailRect = [videoImageView convertRect:thumbnailRect toView:self];
        if (CGRectContainsPoint(thumbnailRect, touchLocation)) {
            if (playVideoCallback != nil) {
                [playVideoCallback execute:videoObject];
            }
        }
        
        CGRect likeRect = [likeImageView bounds];
        likeRect = [likeImageView convertRect:likeRect toView:self];
        if (CGRectContainsPoint(likeRect, touchLocation)) {
            if (!videoObject.liked) {
                if (likeVideoCallback != nil) {
                    [likeVideoCallback execute:videoObject];
                }
            } else {
                if (unlikeVideoCallback != nil) {
                    [unlikeVideoCallback execute:videoObject];
                }
            }
        }
    }
}

- (void)dealloc {
    if (imageThread)
        [imageThread release];
    
    [videoImageView release];
    [playButtonImage release];
    [titleLabel release];
	[descriptionLabel release];
    [faviconImageView release];
    [sourceLabel release];
    [likesLabel release];
	[likeImageView release];
    [videoObject release];
    
    [likeVideoCallback release];
    [unlikeVideoCallback release];
    [playVideoCallback release];
    [super dealloc];
}

@end
