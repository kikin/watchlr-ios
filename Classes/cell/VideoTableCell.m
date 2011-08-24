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

@implementation VideoTableCell

@synthesize playVideoCallback, likeVideoCallback, unlikeVideoCallback, addVideoCallback, viewSourceCallback;

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
        
        // create the first dot separator
        dotLabel1 = [[UILabel alloc] init];
		dotLabel1.backgroundColor = [UIColor clearColor];
		dotLabel1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		dotLabel1.font = [UIFont boldSystemFontOfSize:25];
		dotLabel1.text = @".";
        dotLabel1.textColor = [UIColor blackColor];
        dotLabel1.numberOfLines = 1;
		[self addSubview:dotLabel1];
        
        // Create the timestamp label
        timestampLabel = [[UILabel alloc] init];
		timestampLabel.backgroundColor = [UIColor clearColor];
		timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		timestampLabel.font = [UIFont systemFontOfSize:13];
		timestampLabel.textColor = [UIColor colorWithRed:(181.0 / 255.0) green:(181.0 / 255.0) blue:(181.0 / 255.0) alpha:1.0];
        timestampLabel.numberOfLines = 1;
		[self addSubview:timestampLabel];
        
        // create the second dot separator
        dotLabel2 = [[UILabel alloc] init];
		dotLabel2.backgroundColor = [UIColor clearColor];
		dotLabel2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		dotLabel2.font = [UIFont boldSystemFontOfSize:25];
		dotLabel2.text = @".";
        dotLabel2.textColor = [UIColor blackColor];
        dotLabel2.numberOfLines = 1;
		[self addSubview:dotLabel2];
        
        // Create the source label
        sourceLabel = [[UILabel alloc] init];
		sourceLabel.backgroundColor = [UIColor clearColor];
		sourceLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		sourceLabel.font = [UIFont systemFontOfSize:13];
		sourceLabel.text = @"source";
        sourceLabel.textColor = [UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0];
        sourceLabel.numberOfLines = 1;
		[self addSubview:sourceLabel];
        sourceLabel.hidden = YES;
		
		// create the like button
        likeImageView = [[UIImageView alloc] init];
        likeImageView.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:likeImageView];
        
        // create the save button
        saveImageView = [[UIImageView alloc] init];
        saveImageView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:saveImageView];
        
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

- (void)dealloc {
    if (imageThread)
        [imageThread release];
    
    [saveImageView release];
    [videoImageView release];
    [playButtonImage release];
    [titleLabel release];
	[descriptionLabel release];
    [faviconImageView release];
    [dotLabel1 release];
    [timestampLabel release];
    [dotLabel2 release];
    [sourceLabel release];
    [likesLabel release];
	[likeImageView release];
    [videoObject release];
    
    [addVideoCallback release];
    [likeVideoCallback release];
    [unlikeVideoCallback release];
    [playVideoCallback release];
    [viewSourceCallback release];
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                             Callbacks
// --------------------------------------------------------------------------------

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

// --------------------------------------------------------------------------------
//                             Private Functions
// --------------------------------------------------------------------------------

- (void) loadImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if (![[NSThread currentThread] isCancelled]) {
        // update play button image
        [playButtonImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"play_button.png"] waitUntilDone:YES];
        
        // update like button
        [likeImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:(videoObject.liked ? @"heart_red.png" : @"heart_grey.png")] waitUntilDone:YES];
        
        // update save button
        if (!videoObject.saved) {
            [saveImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"save_video.png"] waitUntilDone:YES];
            saveImageView.hidden = NO;
        } else if (videoObject.savedInCurrentTab) {
            [saveImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"check_mark_green.png"] waitUntilDone:YES];
            saveImageView.hidden = NO;
        } else {
            saveImageView.hidden = NO;
        }
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
        if (videoObject.videoSource.sourceUrl != nil) {
            // sourceLabel.text = videoObject.videoSource.sourceUrl;
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
        
        if (!videoObject.saved || videoObject.savedInCurrentTab) {
            // set the size for save/unsaved button
            saveImageView.frame = CGRectMake((self.frame.size.width - 50), 10, 30, 30);
            saveImageView.hidden = NO;
            
            // set the size for like/unlike button
            likeImageView.frame = CGRectMake((self.frame.size.width - 90), 10, 30, 30);
            
            // set the size for likes label
            likesLabel.frame = CGRectMake((self.frame.size.width - 150), 10, 55, 30);
        } else {
            // hide the add button
            saveImageView.hidden = YES;
            
            // set the size for likes label
            likesLabel.frame = CGRectMake((self.frame.size.width - 110), 10, 55, 30);
            
            // set the size for like/unlike button
            likeImageView.frame = CGRectMake((self.frame.size.width - 50), 10, 30, 30);
        }
        
        // set the size for favicon image
        faviconImageView.frame = CGRectMake(180, self.frame.size.height - (faviconAndSourceHeight + 5), 16, 16);
        
        // set the size for first dot separator
        dotLabel1.frame = CGRectMake(205, self.frame.size.height - (faviconAndSourceHeight + 10), [dotLabel1.text sizeWithFont:dotLabel1.font].width, 15);
        
        // set the size for source label
        timestampLabel.frame = CGRectMake((210 + dotLabel1.frame.size.width), 
                                          self.frame.size.height - (faviconAndSourceHeight + 5), 
                                          [timestampLabel.text sizeWithFont:timestampLabel.font].width, 
                                          15);
        
        // set the size for second dot separator
        dotLabel2.frame = CGRectMake((215 + dotLabel1.frame.size.width + timestampLabel.frame.size.width), 
                                     self.frame.size.height - (faviconAndSourceHeight + 10), 
                                     [dotLabel2.text sizeWithFont:dotLabel2.font].width, 
                                     15);
        
        // set the size for source label
        sourceLabel.frame = CGRectMake((dotLabel1.frame.size.width + timestampLabel.frame.size.width + dotLabel2.frame.size.width + 220), // x
                                       self.frame.size.height - (faviconAndSourceHeight + 5), // y
                                       [sourceLabel.text sizeWithFont:sourceLabel.font].width, // width
                                       15); // height
        
    }
}

- (NSString*) getPrettyDate:(double)timeSaved {
    if (timeSaved == 0.0) 
        return @"";
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    int diff = now - timeSaved;
    
    if (diff < 0) { // this should not be possible
        return @"";
    } else if (diff < 10) { // 10 seconds
        return @"just now";
    } else if (diff < 60) { // 1 minute
        return [NSString stringWithFormat:@"%d seconds ago", diff];
    } else if (diff < (2 * 60)) {  // 2 minutes     
        return @"a minute ago";
    } else if (diff < (60 * 60)) {  // 1 hour
        return [NSString stringWithFormat:@"%d minutes ago", (diff / 60)];  // divide by number of minutes
    } else if (diff < (2 * 60 * 60)) {  // 2 hours
        return @"an hour ago";
    } else if (diff < (24 * 60 * 60)) { // 1 day
         return [NSString stringWithFormat:@"%d hours ago", (diff / (60 * 60))]; // divide by number of hours
    } else if (diff < (2 * 24 * 60 * 60)) { // 2 days
        return @"Yesterday";
    } else if (diff < (7 * 24 * 60 * 60)) { // 1 week
        return [NSString stringWithFormat:@"%d days ago", (diff / (24 * 60 * 60))]; // divide by number of days
    } else if (diff < (2 * 7 * 24 * 60 * 60)) { // 2 weeks
        return @"last week";
    } else if (diff < (30 * 24 * 60 * 60)) {    // approx. 1 month
        return [NSString stringWithFormat:@"%d weeks ago", (diff / (7 * 24 * 60 * 60))]; // divide by number of weeks
    } else if (diff < (2 * 30 * 24 * 60 * 60)) {    // approx. 2 months
        return @"a month ago";
    } else if (diff < (365 * 24 * 60 * 60)) {   // approx. 1 year
        return [NSString stringWithFormat:@"%d months ago", (diff / (30 * 24 * 60 * 60))]; // divide by number of months
    } else if (diff < (2 * 365 * 24 * 60 * 60)) { // approx. 2 years
        return @"an year ago";
    } else {
        return [NSString stringWithFormat:@"%d years ago", (diff / (365 * 24 * 60 * 60))]; // divide by number of years
    }
}

// --------------------------------------------------------------------------------
//                             UIView Functions
// --------------------------------------------------------------------------------

- (void) layoutSubviews {
    [super layoutSubviews];
    [self performSelectorOnMainThread:@selector(fixSize) withObject:nil waitUntilDone:NO];
}

// --------------------------------------------------------------------------------
//                             Touch event Functions
// --------------------------------------------------------------------------------

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
        
        CGRect addVideoRect = [saveImageView bounds];
        addVideoRect = [saveImageView convertRect:addVideoRect toView:self];
        if (CGRectContainsPoint(addVideoRect, touchLocation)) {
            if (addVideoCallback != nil) {
                [addVideoCallback execute:videoObject];
            }
        }
        
        CGRect sourceRect = [sourceLabel bounds];
        sourceRect = [sourceLabel convertRect:sourceRect toView:self];
        if (CGRectContainsPoint(sourceRect, touchLocation)) {
            if (viewSourceCallback != nil) {
                if (videoObject.hostUrl != nil) {
                    [viewSourceCallback execute:videoObject.hostUrl];
                } else {
                    [viewSourceCallback execute:videoObject.videoUrl];
                }
            }
        }
    }
}

// --------------------------------------------------------------------------------
//                             Public Functions
// --------------------------------------------------------------------------------

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
    
    // update timestamp
    timestampLabel.text = [self getPrettyDate:videoObject.timestamp];
	
	// update image
	videoImageView.image = [UIImage imageNamed:@"NoImage.png"];
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

- (void) updateSaveButton: (VideoObject*)video {
    if (videoObject) [videoObject release];
    videoObject = [video retain];
    
    [saveImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"check_mark_green.png"] waitUntilDone:YES];
    videoObject.savedInCurrentTab = true;
}

@end
