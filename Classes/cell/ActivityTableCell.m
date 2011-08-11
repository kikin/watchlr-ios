//
//  VideoTableCell.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ActivityTableCell.h"
#import "UserActivityObject.h"
#import "CommonIos/Callback.h"


/*@implementation UIHtmlLabel

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        label1 = [[UILabel alloc] init];
        label1.font = [UIFont systemFontOfSize:18];
        label1.numberOfLines = 1;
        label1.backgroundColor = [UIColor clearColor];
        label1.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label1]; 
        
        label2 = [[UILabel alloc] init];
        label2.font = [UIFont systemFontOfSize:18];
        label2.numberOfLines = 1;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor blueColor];
        label2.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label2]; 
        
        label3 = [[UILabel alloc] init];
        label3.font = [UIFont systemFontOfSize:18];
        label3.numberOfLines = 1;
        label3.backgroundColor = [UIColor clearColor];
        label3.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label3]; 
    }
    return self;
}

- (void) dealloc {
    [label1 release];
    [label2 release];
    [label3 release];
    
    [super dealloc];
}

- (void) drawHtmlString:(NSString*)string {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (string != nil) {
        NSRange range = [string rangeOfString:@"<a href="];
        int x = 0;
        if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0))) {
            label1.text = [string substringToIndex:range.location];
            label1.frame = CGRectMake(x, 0, ([label1.text length] * 11), self.frame.size.height);
            x += [label1.text length] * 11;
            
            NSRange endRange = [string rangeOfString:@">"];
            link = [string substringWithRange:NSMakeRange((range.location + range.length), (endRange.location - (range.location + range.length)))];
            
            range = [string rangeOfString:@"</a>"];
            label2.text = [string substringWithRange:NSMakeRange((endRange.location + endRange.length), (range.location - (endRange.location + endRange.length)))];
            label2.frame = CGRectMake(x, 0, ([label2.text length] * 11), self.frame.size.height);
            x += [label2.text length] * 11;
            
            label3.text = [string substringFromIndex:(range.location + range.length)];
            label3.frame = CGRectMake(x, 0, (self.frame.size.width - x), self.frame.size.height);
        } else {
            label1.text = string;
            label1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            
            label2.text = @"";
            label2.frame = CGRectMake(self.frame.size.width, 0, 0, self.frame.size.height);
            
            label3.text = @"";
            label3.frame = CGRectMake(self.frame.size.width, 0, 0, self.frame.size.height);
        }
    }
    [pool release];
}

@end*/

@implementation ActivityTableCell

@synthesize addVideoCallback;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// create the add button
        addVideoImageView = [[UIImageView alloc] init];
        addVideoImageView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:addVideoImageView];
        
        // create user image
        userImageView = [[UIImageView alloc] init];
        userImageView.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:userImageView];
        
        // create heading activity
        activityHeading = [[UIWebView alloc] init];
        activityHeading.autoresizingMask = UIViewAutoresizingNone;
        activityHeading.delegate = self;
        [self addSubview:activityHeading];
        UIScrollView* sv = nil;
        for(UIView* v in activityHeading.subviews){
            if([v isKindOfClass:[UIScrollView class] ]){
                sv = (UIScrollView*) v;
                sv.scrollEnabled = NO;
                sv.bounces = NO;
            }
        }
        
        // set size/positions
		if (DeviceUtils.isIphone) {
			videoImageView.frame = CGRectMake(10, 10, 106, 80);
			playButtonImage.frame = CGRectMake(((videoImageView.frame.size.width - 30) / 2), ((videoImageView.frame.size.height - 32) / 2), 50, 50);
            
            titleLabel.font = [UIFont boldSystemFontOfSize:12];
            titleLabel.lineBreakMode = UILineBreakModeCharacterWrap | UILineBreakModeTailTruncation;
            titleLabel.numberOfLines = 3;
            
            likesLabel.font = [UIFont boldSystemFontOfSize:20];
		} else {
            userImageView.frame = CGRectMake(5, 5, 50, 50);
			videoImageView.frame = CGRectMake(75, 50, 160, 120);
            playButtonImage.frame = CGRectMake((((videoImageView.frame.size.width - 50) / 2) + videoImageView.frame.origin.x), 
                                               (((videoImageView.frame.size.height - 50) / 2) + videoImageView.frame.origin.y), 50, 50);
            
            titleLabel.font = [UIFont boldSystemFontOfSize:18];
            titleLabel.numberOfLines = 1;
		}
	}
    return self;
}

- (void) onUserImageLoaded:(UIImage*)userImage {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (userImage != nil) {
        if (![[NSThread currentThread] isCancelled]) {
            [userImageView performSelectorOnMainThread:@selector(setImage:) withObject:userImage waitUntilDone:YES];
            userImageView.hidden = NO;
        }
    } else {
        userImageView.hidden = YES;
    }
    [pool release];
}


- (void) loadActivityCellImages {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    if (![[NSThread currentThread] isCancelled]) {
        // update like button
        if (!videoObject.saved) {
            [addVideoImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"save_video.png"] waitUntilDone:YES];
            addVideoImageView.hidden = NO;
        } else if (videoObject.savedInCurrentTab) {
            [addVideoImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"check_mark_green.png"] waitUntilDone:YES];
            addVideoImageView.hidden = NO;
        } else {
            addVideoImageView.hidden = NO;
        }
    }
    
    UserProfileObject* userProfile = ((UserActivityObject*)[activityObject.userActivities objectAtIndex:0]).userProfile;
    if (userProfile.pictureImage == nil) {
        if (!userProfile.pictureImageLoaded) {
            [userProfile performSelectorInBackground:@selector(loadUserImage:) withObject:[Callback create:self selector:@selector(onUserImageLoaded:)]];
        } else {
            userImageView.hidden = YES;
        }
    } else {
        if (![[NSThread currentThread] isCancelled]) {
            [userImageView performSelectorOnMainThread:@selector(setImage:) withObject:userProfile.pictureImage waitUntilDone:YES];
            addVideoImageView.hidden = NO;
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
        int userImageAndOptionsWidth = 210;
        int activityHeadinHeight = 30;
        int thumbnailWidth = 245;
        int	faviconAndSourceHeight = 30;
        int titleHeight = 20;
        
        // set the size for activity heading
        activityHeading.frame = CGRectMake(75, 7, (self.frame.size.width - userImageAndOptionsWidth), activityHeadinHeight);
        
        // set the size for title label
        titleLabel.frame = CGRectMake(thumbnailWidth, videoImageView.frame.origin.y + 2, (self.frame.size.width - (thumbnailWidth + 20)), titleHeight);
        
        descriptionLabel.frame = CGRectMake(thumbnailWidth, videoImageView.frame.origin.y + 10, (self.frame.size.width - (thumbnailWidth + 20)), (self.frame.size.height - (titleHeight + faviconAndSourceHeight + activityHeadinHeight + 15)));
        
        if (!videoObject.saved || videoObject.savedInCurrentTab) {
            // set the size for save/unsaved button
            addVideoImageView.frame = CGRectMake((self.frame.size.width - 50), 10, 30, 30);
            addVideoImageView.hidden = NO;
            
            // set the size for like/unlike button
            likeImageView.frame = CGRectMake((self.frame.size.width - 90), 10, 30, 30);
            
            // set the size for likes label
            likesLabel.frame = CGRectMake((self.frame.size.width - 150), 10, 55, 30);
        } else {
            // hide the add button
            addVideoImageView.hidden = YES;
            
            
            // set the size for likes label
            likesLabel.frame = CGRectMake((self.frame.size.width - 110), 10, 55, 30);
            
            // set the size for like/unlike button
            likeImageView.frame = CGRectMake((self.frame.size.width - 50), 10, 30, 30);
        }
        
        // set the size for favicon image
        faviconImageView.frame = CGRectMake(thumbnailWidth, self.frame.size.height - (faviconAndSourceHeight + 5), 15, 15);
        
        // set the size for source label
        sourceLabel.frame = CGRectMake((thumbnailWidth + 25), self.frame.size.height - (faviconAndSourceHeight + 5), (self.frame.size.width - (thumbnailWidth + 20)), 15);
        
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *myTouch in touches)
    {
        CGPoint touchLocation = [myTouch locationInView:self];
        
        CGRect addVideoRect = [addVideoImageView bounds];
        addVideoRect = [addVideoImageView convertRect:addVideoRect toView:self];
        if (CGRectContainsPoint(addVideoRect, touchLocation)) {
            if (addVideoCallback != nil) {
                [addVideoCallback execute:videoObject];
            }
        }
    }
}
                                           
- (void) setActivityObject: (ActivityObject*)activity {
    
    // change acticity object
    if (activityObject) [activityObject release];
    activityObject = [activity retain];
    
    [self setVideoObject:activityObject.video];
    
//    LOG_DEBUG(@"System font family name:%@\nSystem font name:%@", titleLabel.font.familyName, titleLabel.font.fontName);
    // set the activity heading
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];

    NSString* htmlString = [NSString stringWithFormat:@"<html><head><style type=\"text/css\"> a {color:#2AACE1;text-decoration:none;cursor:pointer;} body {font-family:'Helvetica';font-size:18px}</style></head><body>%@</body></html>", activity.activity_heading];
    [activityHeading loadHTMLString:htmlString baseURL:baseURL];

    // update image
    [self loadActivityCellImages];
}

- (void) updateSaveButton: (ActivityObject*)activity {
    if (activityObject) [activityObject release];
    activityObject = [activity retain];
    
    if (videoObject) [videoObject release];
    videoObject = [activity.video retain];
    
    [addVideoImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"check_mark_green.png"] waitUntilDone:YES];
    videoObject.savedInCurrentTab = true;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* scheme = [[request URL] scheme];
    if ([scheme caseInsensitiveCompare:@"file"] == NSOrderedSame) {
        if (NSEqualRanges([[[request URL] path] rangeOfString:@"watchlr.app"], NSMakeRange(NSNotFound, 0))) {
            LOG_DEBUG(@"open watchlr profile.");
        } else {
            return YES;
        }
    } else {
        LOG_DEBUG(@"open facebook profile.");
    }
    return NO;
}

- (void)dealloc {
    activityHeading.delegate = nil;
    
    [addVideoImageView release];
    [userImageView release];
    [activityHeading release];
    [activityObject release];
    [addVideoCallback release];
    
	[super dealloc];
}

@end
