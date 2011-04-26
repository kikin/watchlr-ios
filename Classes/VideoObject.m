//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoObject.h"
#import "JSON.h"

@implementation VideoObject

@synthesize videoId, title, description, imageUrl, videoUrl, timestamp, viewed, embedUrl;

- (id) initFromDictionnary: (NSDictionary*)data {
	// get data from this video
	self.videoId = [[data objectForKey:@"id"] intValue];
	self.title = [data objectForKey:@"title"] != [NSNull null] ? [data objectForKey:@"title"] : nil;
	self.description = [data objectForKey:@"description"] != [NSNull null] ? [data objectForKey:@"description"] : nil;
	self.videoUrl = [data objectForKey:@"url"];
	self.timestamp = [[data objectForKey:@"timestamp"] longValue];
	self.viewed = [[data objectForKey:@"watched"] boolValue];
	self.imageUrl = [data objectForKey:@"thumbnail_url"];
	
	// set default values
	if (title == nil) self.title = @"No title";
	if (description == nil) self.description = @"";
	
	NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"v=([^&]+)" options:NSRegularExpressionCaseInsensitive error:nil];
	NSArray* matches = [regex matchesInString:videoUrl options:0 range:NSMakeRange(0, [videoUrl length])];
	[regex release];
	
	NSString* youtubeId;
	if (matches != nil && [matches count] > 0) {
		NSTextCheckingResult* firstMatch = [matches objectAtIndex:0];
		NSRange videoIdRange = [firstMatch rangeAtIndex:1];
		youtubeId = [videoUrl substringWithRange:videoIdRange];		
	} else {
		// get the videoId to create the imageUrl and embedUrl
		int lastIndex = [videoUrl rangeOfString:@"/" options:NSBackwardsSearch].location+1;
		youtubeId = [videoUrl substringFromIndex:lastIndex];
	}
		
	self.imageUrl = [NSString stringWithFormat:@"http://i1.ytimg.com/vi/%@/hqdefault.jpg", youtubeId];
	self.embedUrl = [@"http://www.youtube.com/embed/" stringByAppendingString: youtubeId];
	
	return self;
}

- (void) dealloc {
	self.title = nil;
	self.description = nil;
	self.videoUrl = nil;
	self.embedUrl = nil;
	self.imageUrl = nil;
	[super dealloc];
}


@end
