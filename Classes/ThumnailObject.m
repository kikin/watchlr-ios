//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ThumbnailObject.h"

@implementation ThumbnailObject

@synthesize height, width, thumbnailUrl;

- (id) initFromDictionnary: (NSDictionary*)data {
	// get data from this video
	self.height = [[data objectForKey:@"height"] intValue];
	self.width = [[data objectForKey:@"width"] intValue];
	self.thumbnailUrl = [data objectForKey:@"url"] != [NSNull null] ? [data objectForKey:@"url"] : nil;
	
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
	self.thumbnailUrl = nil;
	[super dealloc];
}


@end
