//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ThumbnailObject.h"

@implementation ThumbnailObject

@synthesize height, width, thumbnailUrl, thumbnailImage, onThumbnailImageLoaded;

- (void) loadImage {
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSURL* url = [NSURL URLWithString:self.thumbnailUrl];
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (data != nil) {
        // set thumbnail image
        thumbnailImage = [[UIImage alloc] initWithData:data];
    } else {
        thumbnailImage = [UIImage imageNamed:@"default_video_icon.png"];
    }
    
    if (onThumbnailImageLoaded != nil) {
        [onThumbnailImageLoaded execute:thumbnailImage];
    }
    
    [pool release];
}

- (id) initFromDictionary: (NSDictionary*)data {
    // LOG_DEBUG(@"Creating thumbnail object");
	// get data from this video
	self.height = [[data objectForKey:@"height"] intValue];
	self.width = [[data objectForKey:@"width"] intValue];
	self.thumbnailUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
    
    if (self.thumbnailUrl != nil) {
        NSThread* imageLoaderThread = [[[NSThread alloc] initWithTarget:self selector:@selector(loadImage) object:nil] autorelease];
        [imageLoaderThread start];
    } else {
        thumbnailImage = [UIImage imageNamed:@"default_video_icon.png"];
    }
    
	return self;
}

- (void) dealloc {
    // [thumbnailImage release];
    thumbnailImage = nil;
    thumbnailUrl = nil;
    
    [super dealloc];
}


@end
