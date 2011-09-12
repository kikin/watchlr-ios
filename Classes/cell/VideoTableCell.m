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

@synthesize playVideoCallback, likeVideoCallback, unlikeVideoCallback, addVideoCallback, removeVideoCallback, viewSourceCallback, viewDetailCallback;

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
		dotLabel1.text = @".";
        dotLabel1.textColor = [UIColor blackColor];
        dotLabel1.numberOfLines = 1;
		[self addSubview:dotLabel1];
        
        // Create the timestamp label
        timestampLabel = [[UILabel alloc] init];
		timestampLabel.backgroundColor = [UIColor clearColor];
		timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		timestampLabel.textColor = [UIColor colorWithRed:(181.0 / 255.0) green:(181.0 / 255.0) blue:(181.0 / 255.0) alpha:1.0];
        timestampLabel.numberOfLines = 1;
		[self addSubview:timestampLabel];
        
        // set size/positions
		if (DeviceUtils.isIphone) {
			videoImageView.frame = CGRectMake(5, 5, 106, 80);
			playButtonImage.frame = CGRectMake(((videoImageView.frame.size.width - 20) / 2), ((videoImageView.frame.size.height - 22) / 2), 32, 32);
            
            titleLabel.font = [UIFont boldSystemFontOfSize:12];
            titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
            titleLabel.numberOfLines = 3;
            
            // set the size of dot labels
            dotLabel1.font = [UIFont boldSystemFontOfSize:25];
            
            // set the font for source label and timestamp label
            timestampLabel.font = [UIFont systemFontOfSize:12];
            
            optionsButtonView = [[UIBubbleView alloc] init];
            optionsButtonView.backgroundColor = [UIColor clearColor];
            [self addSubview:optionsButtonView];
            
            likeButton = [[UICustomButton alloc] init];
//            likeButton.backgroundColor = [UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:1.0];
            likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
            likeButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
            likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            [likeButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0] forState:UIControlStateNormal];
            [likeButton addTarget:self action:@selector(onLikeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [optionsButtonView addSubview:likeButton];
            
            saveButton = [[UICustomButton alloc] init];
//            saveButton.backgroundColor = [UIColor colorWithRed:(235.0/255.0) green:(235.0/255.0) blue:(235.0/255.0) alpha:1.0];
            saveButton.titleLabel.font = [UIFont systemFontOfSize:12];
            saveButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
            saveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1.0] forState:UIControlStateNormal];
            [saveButton addTarget:self action:@selector(onSaveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [optionsButtonView addSubview:saveButton];
            
            detailDisclosureButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
            [detailDisclosureButton setImage:[UIImage imageNamed:@"detail_disclosure.png"] forState:UIControlStateNormal];
            [detailDisclosureButton addTarget:self action:@selector(onDetailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:detailDisclosureButton];
            
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
            
            // create the number of likes label
            likesLabel = [[UILabel alloc] init];
            likesLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            likesLabel.text = [[NSNumber numberWithInt:1] stringValue];
            likesLabel.textColor = [UIColor colorWithRed:(204.0/255.0) green:(204.0/255.0) blue:(204.0/255.0) alpha:1.0];
            likesLabel.textAlignment = UITextAlignmentRight;
            likesLabel.font = [UIFont boldSystemFontOfSize:30];
            likesLabel.numberOfLines = 1;
            [self addSubview:likesLabel];
            
            // create the like button
            likeImageView = [[UIImageView alloc] init];
            likeImageView.autoresizingMask = UIViewAutoresizingNone;
            [self addSubview:likeImageView];
            
            // create the save button
            saveImageView = [[UIImageView alloc] init];
            saveImageView.autoresizingMask = UIViewAutoresizingNone;
            [self addSubview:saveImageView];
            
            // create the second dot separator
            dotLabel2 = [[UILabel alloc] init];
            dotLabel2.backgroundColor = [UIColor clearColor];
            dotLabel2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            dotLabel2.text = @".";
            dotLabel2.textColor = [UIColor blackColor];
            dotLabel2.numberOfLines = 1;
            [self addSubview:dotLabel2];
            
            // Create the source label
            sourceLabel = [[UILabel alloc] init];
            sourceLabel.backgroundColor = [UIColor clearColor];
            sourceLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            sourceLabel.text = @"source";
            sourceLabel.textColor = [UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0];
            sourceLabel.numberOfLines = 1;
            [self addSubview:sourceLabel];
            sourceLabel.hidden = YES;
            
            // set the font size of dot labels
            dotLabel1.font = [UIFont boldSystemFontOfSize:25];
            dotLabel2.font = [UIFont boldSystemFontOfSize:25];
            
            // set the font for source label and timestamp label
            timestampLabel.font = [UIFont systemFontOfSize:13];
            sourceLabel.font = [UIFont systemFontOfSize:13];
		}
        
        videoRemovalAllowed = false;
	}
    return self;
}

- (void)dealloc {
    
    // remove all the callbacks we have set
    [videoObject.thumbnail resetThumnailImageLoadedCallback];
    [videoObject.videoSource resetFaviconImageLoadedCallback];
    
    if (imageThread) {
        [imageThread release];
        imageThread = nil;
    }
    
    if (saveImageView)
        [saveImageView removeFromSuperview];
    
    if (descriptionLabel)
        [descriptionLabel removeFromSuperview];
    
    if (likesLabel)
        [likesLabel removeFromSuperview];
    
    if (likeImageView)
        [likeImageView removeFromSuperview];
    
    if (optionsButtonView) {
        [optionsButtonView removeFromSuperview];
    }
    
    if (saveButton) {
        [saveButton removeFromSuperview];
    }
    
    if (likeButton) {
        [likeButton removeFromSuperview];
    }
    
    if (detailDisclosureButton) {
        [detailDisclosureButton  removeFromSuperview];
    }
    
    if (dotLabel2) {
        [dotLabel2 removeFromSuperview];
    }
    
    if (sourceLabel) {
        [sourceLabel removeFromSuperview];
    }
    
    [videoImageView removeFromSuperview];
    [playButtonImage removeFromSuperview];
    [titleLabel removeFromSuperview];
	
    [faviconImageView removeFromSuperview];
    [dotLabel1 removeFromSuperview];
    [timestampLabel removeFromSuperview];
    
    [videoObject release];
    
    [addVideoCallback release];
    [likeVideoCallback release];
    [unlikeVideoCallback release];
    [playVideoCallback release];
    [viewSourceCallback release];
    [viewDetailCallback release];
    
    if (removeVideoCallback != nil)
        [removeVideoCallback release];
    
    saveImageView = nil;
    videoImageView = nil;
    playButtonImage = nil;
    titleLabel = nil;
    descriptionLabel = nil;
    faviconImageView = nil;
    dotLabel1 = nil;
    timestampLabel = nil;
    dotLabel2 = nil;
    sourceLabel = nil;
    likesLabel = nil;
    likeImageView = nil;
    optionsButtonView = nil;
    likeButton = nil;
    saveButton = nil;
    detailDisclosureButton = nil;
    
    videoObject = nil;
    addVideoCallback = nil;
    likeVideoCallback = nil;
    unlikeVideoCallback = nil;
    playVideoCallback = nil;
    viewSourceCallback = nil;
    viewDetailCallback = nil;
    removeVideoCallback = nil;
    
    [super dealloc];
}

// --------------------------------------------------------------------------------
//                             Callbacks
// --------------------------------------------------------------------------------

- (void) onDetailButtonClicked:(UIButton*)sender {
    if (viewDetailCallback != nil) {
        [viewDetailCallback execute:videoObject];
    } 
}

- (void) onThumbnailImageLoaded:(UIImage*)thumbnailImage {
     NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (thumbnailImage == nil) {
        thumbnailImage = [UIImage imageNamed:@"default_video_icon"];
    }
    
    if (![[NSThread currentThread] isCancelled]) {
        [videoImageView performSelectorOnMainThread:@selector(setImage:) withObject:thumbnailImage waitUntilDone:YES];
        videoImageView.hidden = NO;
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

- (void) onLikeButtonClicked:(UIButton*) sender {
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

- (void) onSaveButtonClicked:(UIButton*) sender {
    if (videoObject.saved) {
        if (videoRemovalAllowed && removeVideoCallback != nil) {
            [removeVideoCallback execute:videoObject];
        }
    } else {
        if (addVideoCallback != nil) {
            [addVideoCallback execute:videoObject];
        }
    }
}

// --------------------------------------------------------------------------------
//                             Private Functions
// --------------------------------------------------------------------------------

- (void) downloadThumbnailImage:(ThumbnailObject*) thumbnail  {
    [thumbnail setThumnailImageLoadedCallback:[Callback create:self selector:@selector(onThumbnailImageLoaded:)]];
    [thumbnail performSelector:@selector(loadImage)];

}

- (void) downloadFaviconImage:(SourceObject*) source  {
    [source setFaviconImageLoadedCallback:[Callback create:self selector:@selector(onFaviconImageLoaded:)]];
    [source performSelector:@selector(loadImage)];
}

- (void) loadImage {
    if (![[NSThread currentThread] isCancelled]) {
        // update play button image
        [playButtonImage performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"play_button.png"] waitUntilDone:YES];
        
        if (!DeviceUtils.isIphone) {
            // update like button
            [likeImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:(videoObject.liked ? @"heart_red.png" : @"heart_grey.png")] waitUntilDone:YES];
            
            // update save button
            if (!videoObject.saved) {
                [saveImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"save_video.png"] waitUntilDone:YES];
                saveImageView.hidden = NO;
            } else if (videoRemovalAllowed) {
                [saveImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"x_grey.png"] waitUntilDone:YES];
                saveImageView.hidden = NO;
            } else if (videoObject.savedInCurrentTab) {
                [saveImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"check_mark_green.png"] waitUntilDone:YES];
                saveImageView.hidden = NO;
            } else {
                saveImageView.hidden = NO;
            }
        } else {
            [likeButton setImage:[UIImage imageNamed:(videoObject.liked ? @"heart_red_small.png" : @"heart_grey_small.png")] forState:UIControlStateNormal];
            if (!videoObject.saved) {
                [saveButton setImage:[UIImage imageNamed:@"save_video_small.png"] forState:UIControlStateNormal];
            } else if (videoRemovalAllowed) {
                [saveButton setImage:[UIImage imageNamed:@"x_grey_small.png"] forState:UIControlStateNormal];
            } else {
                [saveButton setImage:[UIImage imageNamed:@"check_mark_green_small.png"] forState:UIControlStateNormal];
            }
        }
    }
	
    // set the thumbnail image
    if (videoObject.thumbnail != nil) {
        if (videoObject.thumbnail.thumbnailImage != nil) {
            // make sure the thread was not killed
            if (![[NSThread currentThread] isCancelled]) {
                [videoImageView performSelectorOnMainThread:@selector(setImage:) withObject:(videoObject.thumbnail.thumbnailImage) waitUntilDone:YES];
                videoImageView.hidden = NO;
            }
        } else {
            [self performSelector:@selector(downloadThumbnailImage:) withObject:videoObject.thumbnail];
        }
    } else {
        // make sure the thread was not killed
        if (![[NSThread currentThread] isCancelled]) {
            [videoImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"default_video_icon.png"] waitUntilDone:YES];
            videoImageView = NO;
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
            [self performSelector:@selector(downloadFaviconImage:) withObject:videoObject.videoSource];
        }
        
        // set the source name
        if (videoObject.videoSource.sourceUrl != nil && DeviceUtils.isIphone) {
            sourceLabel.text = videoObject.videoSource.sourceUrl;
            sourceLabel.hidden = NO;
        }
    }
}

- (void) fixSize {
	if (DeviceUtils.isIphone) {
        // set the size for title label
        CGFloat titleLabelHeight = MIN((self.frame.size.height - 30), 
                                       [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width - 157, self.frame.size.height - 30) lineBreakMode:UILineBreakModeCharacterWrap].height);
        titleLabel.frame = CGRectMake(120, 5, (self.frame.size.width - 157), titleLabelHeight);
        
        faviconImageView.frame = CGRectMake(120, self.frame.size.height - 57, 16, 16);
        
        dotLabel1.frame = CGRectMake(faviconImageView.frame.origin.x + faviconImageView.frame.size.width + 5, 
                                     self.frame.size.height - 59, 
                                     [dotLabel1.text sizeWithFont:dotLabel1.font].width, 
                                     15);
        
        // set the timestamp label position
        timestampLabel.frame = CGRectMake(dotLabel1.frame.origin.x + dotLabel1.frame.size.width + 5, 
                                          self.frame.size.height - 54, 
                                          [timestampLabel.text sizeWithFont:timestampLabel.font].width, 
                                          15);
        
        optionsButtonView.frame = CGRectMake(25, videoImageView.frame.origin.y + videoImageView.frame.size.height + 2, self.frame.size.width - 50, 30);
        CGFloat optionsButtonViewMidPoint = optionsButtonView.frame.size.width / 2;
        likeButton.frame = CGRectMake(6, 10, optionsButtonViewMidPoint - 9, optionsButtonView.frame.size.height - 13);
        saveButton.frame = CGRectMake(optionsButtonViewMidPoint + 3, 10, optionsButtonViewMidPoint - 9, optionsButtonView.frame.size.height - 13);
        
        detailDisclosureButton.frame = CGRectMake(self.frame.size.width - 35, (videoImageView.frame.size.height / 2) - 10, 29, 29);
        
    } else {
        
        int titleAndDescriptionLabelWidth = 310;
        int	faviconAndSourceHeight = 30;
        int titleHeight = 20;
        
        // set the size for title label
        titleLabel.frame = CGRectMake(180, 12, (self.frame.size.width - titleAndDescriptionLabelWidth), titleHeight);
        
        descriptionLabel.frame = CGRectMake(180, 20, (self.frame.size.width - titleAndDescriptionLabelWidth), (self.frame.size.height - (titleHeight + faviconAndSourceHeight + 10)));
        
        if (!videoObject.saved || videoObject.savedInCurrentTab || videoRemovalAllowed) {
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
    [self performSelector:@selector(fixSize) withObject:nil];
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
        
        if (!DeviceUtils.isIphone) {
           CGRect likeRect = [likeImageView bounds];
            likeRect = [likeImageView convertRect:likeRect toView:self];
            if (CGRectContainsPoint(likeRect, touchLocation)) {
                [self onLikeButtonClicked:nil];
            }
            
            CGRect addVideoRect = [saveImageView bounds];
            addVideoRect = [saveImageView convertRect:addVideoRect toView:self];
            if (CGRectContainsPoint(addVideoRect, touchLocation)) {
                [self onSaveButtonClicked:nil];
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
}

// --------------------------------------------------------------------------------
//                             Public Functions
// --------------------------------------------------------------------------------

- (void)setVideoObject: (VideoObject*)video shouldAllowVideoRemoval:(BOOL)allowVideoRemoval {
    // change video object
    // LOG_DEBUG(@"Drawing the cell");
	if (videoObject) {
        [videoObject.thumbnail resetThumnailImageLoadedCallback];
        [videoObject.videoSource resetFaviconImageLoadedCallback];
        [videoObject release];
    }
    
	videoObject = [video retain];
    faviconImageView.hidden = YES;
    videoImageView.hidden = YES;
    videoRemovalAllowed = allowVideoRemoval;
    
	// change text
	titleLabel.text = video.title;
    if (!DeviceUtils.isIphone) {
        if (video.description != nil) {
            NSString* description = [video.description stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if (!DeviceUtils.isIphone) 
                descriptionLabel.text = description;
            
            [self performSelector:@selector(fixSize) withObject:nil];
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
    } else {
        if (videoObject.liked) {
            [likeButton setTitle:@"Unlike" forState:UIControlStateNormal];
        } else {
            [likeButton setTitle:@"Like" forState:UIControlStateNormal];
        }
        
        if (!videoObject.saved) {
            [saveButton setTitle:@"Save" forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
            [saveButton setEnabled:YES];
        } else if(videoRemovalAllowed) {
            [saveButton setTitle:@"Remove" forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
            [saveButton setEnabled:YES];
        } else {
            [saveButton setTitle:@"Saved" forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:(73.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
            [saveButton setEnabled:NO];
        }
    }
    
    // update timestamp
    timestampLabel.text = [self getPrettyDate:videoObject.timestamp];
	
	// update image
//	videoImageView.image = [UIImage imageNamed:@"NoImage.png"];
    [self loadImage];
}

- (void) updateLikeButton: (VideoObject*)video {
    if (videoObject) [videoObject release];
	videoObject = [video retain];
    
    if (!DeviceUtils.isIphone) { // if iPad
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
    } else { // if iPhone
        [likeButton setImage:[UIImage imageNamed:(videoObject.liked ? @"heart_red_small.png" : @"heart_grey_small.png")] forState:UIControlStateNormal];
        [likeButton setTitle:(videoObject.liked ? @"Unlike" : @"Like") forState:UIControlStateNormal];
    }
}

- (void) updateSaveButton: (VideoObject*)video {
    if (videoObject) [videoObject release];
    videoObject = [video retain];
    
    if (!DeviceUtils.isIphone) { // if iPad
        [saveImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"check_mark_green.png"] waitUntilDone:YES];
    } else { // if iPhone
        if (!videoObject.saved) {
            [saveButton setImage:[UIImage imageNamed:@"save_video_small.png"] forState:UIControlStateNormal];
            [saveButton setTitle:@"Save" forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
            [saveButton setEnabled:YES];
        } else if(videoRemovalAllowed) {
            [saveButton setImage:[UIImage imageNamed:@"x_grey_small.png"] forState:UIControlStateNormal];
            [saveButton setTitle:@"Remove" forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:(12.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
            [saveButton setEnabled:YES];
        } else {
            [saveButton setImage:[UIImage imageNamed:@"check_mark_green_small.png"] forState:UIControlStateNormal];
            [saveButton setTitle:@"Saved" forState:UIControlStateNormal];
            [saveButton setTitleColor:[UIColor colorWithRed:(73.0/255.0) green:(83.0/255.0) blue:(111.0/255.0) alpha:1] forState:UIControlStateNormal];
            [saveButton setEnabled:NO];
        }
    }
    
    videoObject.savedInCurrentTab = true;
}

@end
