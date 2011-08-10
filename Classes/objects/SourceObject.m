//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SourceObject.h"

@implementation SourceObject

@synthesize sourceUrl, favicon, name, faviconImage, isFaviconImageLoaded, onFaviconImageLoaded;

- (void) loadImage {
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSURL* url = [NSURL URLWithString:self.favicon];
    NSData* data = [NSData dataWithContentsOfURL:url];
    if (data != nil) {
        // set thumbnail image
        faviconImage = [[UIImage alloc] initWithData:data];
    }
    
    self.isFaviconImageLoaded = true;
    if (onFaviconImageLoaded != nil) {
        [onFaviconImageLoaded execute:faviconImage];
    }
    
    [pool release];
}

- (id) initFromDictionnary: (NSDictionary*)data {
	// get data from this video
	self.name = [data objectForKey:@"name"] != [NSNull null] ? [data objectForKey:@"name"] : nil;
	self.favicon = [data objectForKey:@"favicon"] != [NSNull null] ? [data objectForKey:@"favicon"] : nil;
	self.sourceUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
    self.isFaviconImageLoaded = false;
    
    if (self.favicon != nil) {
        NSThread* imageLoaderThread = [[[NSThread alloc] initWithTarget:self selector:@selector(loadImage) object:nil] autorelease];
        [imageLoaderThread start];
    }
	
	return self;
}

- (void) dealloc {
    [faviconImage release];
    faviconImage = nil;
	sourceUrl = nil;
    favicon = nil;
    name = nil;
    
	[super dealloc];
}


@end
