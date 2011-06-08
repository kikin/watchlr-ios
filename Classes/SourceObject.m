//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "SourceObject.h"

@implementation SourceObject

@synthesize sourceUrl, favicon, name;

- (id) initFromDictionnary: (NSDictionary*)data {
	// get data from this video
	self.name = [data objectForKey:@"name"] != [NSNull null] ? [data objectForKey:@"name"] : nil;
	self.favicon = [data objectForKey:@"favicon"] != [NSNull null] ? [data objectForKey:@"favicon"] : nil;
	self.sourceUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
	
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
	self.sourceUrl = nil;
    self.favicon = nil;
    self.name = nil;
	[super dealloc];
}


@end
