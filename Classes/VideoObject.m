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
	// get data from this video
	self.videoId = [[data objectForKey:@"id"] intValue];
	self.title = [data objectForKey:@"title"] != [NSNull null] ? [data objectForKey:@"title"] : nil;
	self.description = [data objectForKey:@"description"] != [NSNull null] ? [data objectForKey:@"description"] : nil;
	self.videoUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
	self.thumbnail = [data objectForKey:@"thumbnail"] != [NSNull null] ? [data objectForKey:@"thumbnail"] : nil;
    self.htmlCode = [data objectForKey:@"html"] != [NSNull null] ? [data objectForKey:@"html"] : nil;
    self.videoSource = [data objectForKey:@"source"] != [NSNull null] ? [data objectForKey:@"source"] : nil;
    self.liked = [[data objectForKey:@"liked"] boolValue];
    self.likes = [[data objectForKey:@"likes"] intValue];
    self.saved = [[data objectForKey:@"saved"] boolValue];
    self.seek = [[data objectForKey:@"seek"] doubleValue];
    
    LOG_DEBUG(@"HTML code received=%@", self.htmlCode);
	
	// set default values
	if (title == nil) self.title = @"No title";
	if (description == nil) self.description = @"";
	
	/*NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"v=([^&]+)" options:NSRegularExpressionCaseInsensitive error:nil];
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
	self.embedUrl = [@"http://www.youtube.com/embed/" stringByAppendingString: youtubeId];*/
	
	return self;
}

- (void) dealloc {
	self.title = nil;
	self.description = nil;
	self.videoUrl = nil;
	self.embedUrl = nil;
	self.thumbnail = nil;
    self.htmlCode = nil;
    self.videoSource = nil;
	[super dealloc];
}


@end
