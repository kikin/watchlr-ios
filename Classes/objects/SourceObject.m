//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SourceObject.h"

@implementation SourceObject

@synthesize sourceUrl, favicon, name, faviconImage, isFaviconImageLoaded;

- (id) initFromDictionary: (NSDictionary*)data {
	// get data from this video
	self.name = [data objectForKey:@"name"] != [NSNull null] ? [data objectForKey:@"name"] : nil;
	self.favicon = [data objectForKey:@"favicon"] != [NSNull null] ? [data objectForKey:@"favicon"] : nil;
	self.sourceUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
    
    if (self.favicon == nil) {
        self.isFaviconImageLoaded = true;
    } else {
        self.isFaviconImageLoaded = false;
    }
	
	return self;
}

- (void) dealloc {
    [faviconImage release];
    [sourceUrl release];
    [favicon release];
    [name release];
    
    faviconImage = nil;
	sourceUrl = nil;
    favicon = nil;
    name = nil;
    
    [faviconImageUrlConnection cancel];
    [faviconImageUrlConnection release];
    [faviconImageData release];
    
    [onFaviconImageLoaded release];
    onFaviconImageLoaded = nil;
    
    [faviconImageLoadedCallbackLock release];
    faviconImageLoadedCallbackLock = nil;
    
	[super dealloc];
}

- (void) setFaviconImageLoadedCallback:(Callback*)callback {
    if (faviconImageLoadedCallbackLock == nil) {
        faviconImageLoadedCallbackLock = [[NSLock alloc] init];
    }
    
    [faviconImageLoadedCallbackLock lock];
    onFaviconImageLoaded = [callback retain];
    [faviconImageLoadedCallbackLock unlock];
}

- (void) resetFaviconImageLoadedCallback {
    if (faviconImageLoadedCallbackLock != nil) {
        [faviconImageLoadedCallbackLock lock];
        [onFaviconImageLoaded release];
        onFaviconImageLoaded = nil;
        [faviconImageLoadedCallbackLock unlock];
    } else {
        onFaviconImageLoaded = nil;
    }
}

- (void) loadImage {
    
    //    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if (faviconImageUrlConnection != nil) { 
        [faviconImageUrlConnection release];
    }
    
    if (faviconImageData != nil) { 
        [faviconImageData release];
        faviconImageData = nil;
    }
    
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:favicon]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    
    faviconImageUrlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //TODO error handling, what if connection is nil?
    
    //    [pool release];
}


- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData {
    if (faviconImageData == nil) {
        faviconImageData = [[NSMutableData alloc] initWithCapacity:(15 * 1024)]; // 15KB
    }
    [faviconImageData appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    
    [faviconImageUrlConnection release];
    faviconImageUrlConnection = nil;
    
    if (faviconImageData != nil) {
        // set thumbnail image
        if (faviconImage != nil) {
            [faviconImage release];
            faviconImage = nil;
        }
        faviconImage = [[UIImage alloc] initWithData:faviconImageData];
    }
    
    if (faviconImageLoadedCallbackLock != nil) {
        [faviconImageLoadedCallbackLock lock];
    }
    
    isFaviconImageLoaded = true;
    if (onFaviconImageLoaded != nil) {
        [onFaviconImageLoaded execute:faviconImage];
        [onFaviconImageLoaded release];
        onFaviconImageLoaded = nil;
    }
    
    if (faviconImageLoadedCallbackLock != nil) {
        [faviconImageLoadedCallbackLock unlock];
    }
    
    [faviconImageData release];
    faviconImageData = nil;
}

@end
