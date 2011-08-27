//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ThumbnailObject.h"

@implementation ThumbnailObject

@synthesize height, width, thumbnailUrl, thumbnailImage;

- (id) initFromDictionary: (NSDictionary*)data {
    // LOG_DEBUG(@"Creating thumbnail object");
	// get data from this video
	self.height = [[data objectForKey:@"height"] intValue];
	self.width = [[data objectForKey:@"width"] intValue];
	self.thumbnailUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
    
    if (self.thumbnailUrl == nil) {
        self.thumbnailImage = [UIImage imageNamed:@"default_video_icon.png"];
    }
    
	return self;
}

- (void) dealloc {
    [thumbnailImage release];
    [thumbnailUrl release];
    
    thumbnailImage = nil;
    thumbnailUrl = nil;
    
    [thumbnailUrlConnection cancel];
    [thumbnailUrlConnection release];
    [thumbnailData release];
    
    [onThumbnailImageLoaded release];
    onThumbnailImageLoaded = nil;
    
    [thumbnailImageLoadedCallbackLock release];
    thumbnailImageLoadedCallbackLock = nil;
    
    [super dealloc];
}

- (void) setThumnailImageLoadedCallback:(Callback*)callback {
    if (thumbnailImageLoadedCallbackLock == nil) {
        thumbnailImageLoadedCallbackLock = [[NSLock alloc] init];
    }
    
    [thumbnailImageLoadedCallbackLock lock];
    onThumbnailImageLoaded = [callback retain];
    [thumbnailImageLoadedCallbackLock unlock];
}

- (void) resetThumnailImageLoadedCallback {
    if (thumbnailImageLoadedCallbackLock != nil) {
        [thumbnailImageLoadedCallbackLock lock];
        [onThumbnailImageLoaded release];
        onThumbnailImageLoaded = nil;
        [thumbnailImageLoadedCallbackLock unlock];
    } else {
        onThumbnailImageLoaded = nil;
    }
}

- (void) loadImage {
    
//    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if (thumbnailUrlConnection != nil) { 
        [thumbnailUrlConnection release];
    }
    
    if (thumbnailData != nil) { 
        [thumbnailData release];
        thumbnailData = nil;
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:thumbnailUrl]
                                          cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    thumbnailUrlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
    
//    [pool release];
}


- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (thumbnailData == nil) {
        thumbnailData = [[NSMutableData alloc] initWithCapacity:(15 * 1024)]; // 15KB
    }
    [thumbnailData appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    
    [thumbnailUrlConnection release];
    thumbnailUrlConnection = nil;
    
    if (thumbnailData != nil) {
        if (thumbnailImage != nil) {
            [thumbnailImage release];
            thumbnailImage = nil;
        }
        
        // set thumbnail image
        thumbnailImage = [[UIImage alloc] initWithData:thumbnailData];
    } else {
        thumbnailImage = [UIImage imageNamed:@"default_video_icon.png"];
    }
    
    if (thumbnailImageLoadedCallbackLock != nil) {
        [thumbnailImageLoadedCallbackLock lock];
    }
    
    if (onThumbnailImageLoaded != nil) {
        [onThumbnailImageLoaded execute:thumbnailImage];
        [onThumbnailImageLoaded release];
        onThumbnailImageLoaded = nil;
    }
    
    if (thumbnailImageLoadedCallbackLock != nil) {
        [thumbnailImageLoadedCallbackLock unlock];
    }
    
    [thumbnailData release];
    thumbnailData = nil;
}


@end
