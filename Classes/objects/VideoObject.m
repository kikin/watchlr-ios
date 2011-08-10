//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoObject.h"

@implementation VideoObject

@synthesize videoId, title, description, thumbnail, videoUrl, embedUrl, htmlCode, likes, videoSource, liked, saved, seek;

- (id) initFromDictionnary: (NSDictionary*)data {
    // LOG_DEBUG(@"Creating new video object");
	// get data from this video
	self.videoId = [[data objectForKey:@"id"] intValue];
	self.title = [data objectForKey:@"title"] != [NSNull null] ? [data objectForKey:@"title"] : nil;
	self.description = [data objectForKey:@"description"] != [NSNull null] ? [data objectForKey:@"description"] : nil;
	self.videoUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
	self.htmlCode = [data objectForKey:@"html"] != [NSNull null] ? [data objectForKey:@"html"] : nil;
    self.liked = [[data objectForKey:@"liked"] boolValue];
    self.likes = [[data objectForKey:@"likes"] intValue];
    self.saved = [[data objectForKey:@"saved"] boolValue];
    self.seek = [[data objectForKey:@"seek"] doubleValue];
    
    NSDictionary* thumbnailDict = [data objectForKey:@"thumbnail"] != [NSNull null] ? [data objectForKey:@"thumbnail"] : nil;
    if (thumbnailDict != nil) {
        thumbnail = [[ThumbnailObject alloc] initFromDictionnary:thumbnailDict];
    }
    
    NSDictionary* sourceDict = [data objectForKey:@"source"] != [NSNull null] ? [data objectForKey:@"source"] : nil;
    if (sourceDict != nil) {
        videoSource = [[SourceObject alloc] initFromDictionnary:sourceDict];
    }
    
    // set default values
	if (title == nil) self.title = @"No title";
	if (description == nil) self.description = @"";
	
	return self;
}

- (void) dealloc {
    [thumbnail release];
    [videoSource release];
    
	self.title = nil;
	self.description = nil;
	self.videoUrl = nil;
	self.embedUrl = nil;
//	self.thumbnail = nil;
    self.htmlCode = nil;
//    self.videoSource = nil;
	[super dealloc];
}


@end
