//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SourceObject.h"

@implementation SourceObject

@synthesize sourceUrl, favicon, name, faviconImage;

- (id) initFromDictionnary: (NSDictionary*)data {
	// get data from this video
	self.name = [data objectForKey:@"name"] != [NSNull null] ? [data objectForKey:@"name"] : nil;
	self.favicon = [data objectForKey:@"favicon"] != [NSNull null] ? [data objectForKey:@"favicon"] : nil;
	self.sourceUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
    
    if (self.favicon != nil) {
        NSURL* url = [NSURL URLWithString:self.favicon];
        NSData* data = [NSData dataWithContentsOfURL:url];
        if (data != nil) {
            // set thumbnail image
            faviconImage = [[UIImage alloc] initWithData:data];
        }
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
