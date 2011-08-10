//
//  VideoTableCell.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "LikedVideoTableCell.h"
#import "LikeVideoResponse.h"

@implementation LikedVideoTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// create the add button
        addVideoImageView = [[UIImageView alloc] init];
        addVideoImageView.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:addVideoImageView];
	}
    return self;
}

- (void) loadImage {
    [super loadImage];
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
    if (![[NSThread currentThread] isCancelled]) {
        // update like button
        if (!videoObject.saved) {
            [addVideoImageView performSelectorOnMainThread:@selector(setImage:) withObject:[UIImage imageNamed:@"save_video.png"] waitUntilDone:YES];
            addVideoImageView.hidden = NO;
        } else {
            addVideoImageView.hidden = YES;
        }
        
    }
    
    [pool release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	/*int normalWidth = DeviceUtils.isIphone ? 136 : 190,
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
	}*/
	
	[super setEditing:editing animated:animated];
}

- (void) fixSize {
    int titleAndDescriptionLabelWidth = DeviceUtils.isIphone ? 136 : 310;
	int	faviconAndSourceHeight = DeviceUtils.isIphone ? 60 : 30;
    int titleHeight = 20;
    
    // set the size for title label
    titleLabel.frame = CGRectMake(180, 12, (self.frame.size.width - titleAndDescriptionLabelWidth), titleHeight);
	
    descriptionLabel.frame = CGRectMake(180, 20, (self.frame.size.width - titleAndDescriptionLabelWidth), (self.frame.size.height - (titleHeight + faviconAndSourceHeight + 10)));
    
    // set the size for likes label
    likesLabel.frame = CGRectMake((self.frame.size.width - 160), 10, 55, 30);
    
    // set the size for like/unlike button
    likeImageView.frame = CGRectMake((self.frame.size.width - 100), 10, 30, 30);
    
    // set the size for save button
    addVideoImageView.frame = CGRectMake(self.frame.size.width-50, 10, 30, 30);
    
    // set the size for favicon image
    faviconImageView.frame = CGRectMake(180, self.frame.size.height - (faviconAndSourceHeight + 5), 15, 15);
    
    // set the size for source label
    sourceLabel.frame = CGRectMake(200, self.frame.size.height - (faviconAndSourceHeight + 5), (self.frame.size.width - (titleAndDescriptionLabelWidth + 20)), 15);
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    for (UITouch *myTouch in touches)
    {
        CGPoint touchLocation = [myTouch locationInView:self];
        
        CGRect addVideoRect = [addVideoImageView bounds];
        addVideoRect = [addVideoImageView convertRect:addVideoRect toView:self];
        if (CGRectContainsPoint(addVideoRect, touchLocation)) {
            if (addVideoRequest == nil) {
                // create a delete request if not already done
                addVideoRequest = [[AddVideoRequest alloc] init];
                addVideoRequest.errorCallback = [Callback create:self selector:@selector(onAddVideoRequestFailed:)];
                addVideoRequest.successCallback = [Callback create:self selector:@selector(onAddVideoRequestSuccess:)];
            }
            
            
            // cancel any current request
            if ([addVideoRequest isRequesting]) {
                [addVideoRequest cancelRequest];
            }
            
            // do the request
            [addVideoRequest doAddVideoRequest:videoObject];
        }
    }
}

- (void)dealloc {
	[addVideoImageView release];
    [addVideoRequest release];
	[super dealloc];
}

// ---------------------------------------------------------
//                  Request Callbacks                       
// ---------------------------------------------------------
- (void) onAddVideoRequestSuccess: (AddVideoResponse*)response {
	if (response.success) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		if (![[NSThread currentThread] isCancelled]) {
            
            videoObject.saved = true;
            addVideoImageView.hidden = YES;
        }
		[pool release];
	} else {
		LOG_ERROR(@"request success but failed to save video: %@", response.errorMessage);
	}
}

- (void) onAddVideoRequestFailed: (NSString*)errorMessage {		
	LOG_ERROR(@"failed to save video: %@", errorMessage);
}

@end
