//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoObject.h"

@implementation VideoObject

@synthesize videoId, title, description, thumbnail, videoUrl, hostUrl, embedUrl, htmlCode, likes, videoSource, liked, saved, seek, savedInCurrentTab, timestamp;

- (id) initFromDictionary: (NSDictionary*)data {
    // LOG_DEBUG(@"Creating new video object");
	// get data from this video
	self.videoId = [[data objectForKey:@"id"] intValue];
	self.title = [data objectForKey:@"title"] != [NSNull null] ? [data objectForKey:@"title"] : nil;
	self.description = [data objectForKey:@"description"] != [NSNull null] ? [data objectForKey:@"description"] : nil;
	self.videoUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
    self.hostUrl = [data objectForKey:@"host"] != [NSNull null] ? [data objectForKey:@"host"] : nil;
	self.htmlCode = [data objectForKey:@"html"] != [NSNull null] ? [data objectForKey:@"html"] : nil;
    self.liked = [data objectForKey:@"liked"] != [NSNull null] ? [[data objectForKey:@"liked"] boolValue] : false;
    self.likes = [data objectForKey:@"likes"] != [NSNull null] ? [[data objectForKey:@"likes"] intValue] : 0;
    self.saved = [data objectForKey:@"saved"] != [NSNull null] ? [[data objectForKey:@"saved"] boolValue] : false;
    self.seek = [data objectForKey:@"seek"] != [NSNull null] ? [[data objectForKey:@"seek"] doubleValue] : 0.0;
    self.timestamp = [data objectForKey:@"timestamp"] != [NSNull null] ? [[data objectForKey:@"timestamp"] doubleValue] : 0.0;
    
    NSDictionary* thumbnailDict = [data objectForKey:@"thumbnail"] != [NSNull null] ? [data objectForKey:@"thumbnail"] : nil;
    if (thumbnailDict != nil) {
        thumbnail = [[ThumbnailObject alloc] initFromDictionary:thumbnailDict];
    }
    
    NSDictionary* sourceDict = [data objectForKey:@"source"] != [NSNull null] ? [data objectForKey:@"source"] : nil;
    if (sourceDict != nil) {
        videoSource = [[SourceObject alloc] initFromDictionary:sourceDict];
    }
    
    // set default values
	if (title == nil) self.title = @"";
	if (description == nil) self.description = @"";
	
	return self;
}

- (void) updateFromDictionary: (NSDictionary*)data {
    self.liked = [data objectForKey:@"liked"] != [NSNull null] ? [[data objectForKey:@"liked"] boolValue] : self.liked;
    self.likes = [data objectForKey:@"likes"] != [NSNull null] ? [[data objectForKey:@"likes"] intValue] : self.likes;
    self.saved = [data objectForKey:@"saved"] != [NSNull null] ? [[data objectForKey:@"saved"] boolValue] : self.saved;
    self.seek = [data objectForKey:@"seek"] != [NSNull null] ? [[data objectForKey:@"seek"] doubleValue] : self.seek;
}

- (void) dealloc {
    [thumbnail release];
    [videoSource release];
    
	self.title = nil;
	self.description = nil;
	self.videoUrl = nil;
	self.embedUrl = nil;
    self.hostUrl = nil;
//	self.thumbnail = nil;
    self.htmlCode = nil;
//    self.videoSource = nil;
	[super dealloc];
}


@end
