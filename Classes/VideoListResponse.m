//
//  VideoListResponse.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoListResponse.h"
#import "VideoObject.h"

@implementation VideoListResponse

@synthesize count, start, videos;

- (id) initWithResponse: (id)jsonObject {
	// cast our data to what it *should* be
	NSDictionary* response = jsonObject;
	
	// get count/start
	count = [[response objectForKey:@"count"] intValue];
	start = [[response objectForKey:@"start"] intValue];
	
	// get all the videos
	if (count > 0) {
		NSArray* videosArr = [response objectForKey:@"videos"];
		
		videos = [NSMutableArray arrayWithCapacity:videosArr.count];
		for (NSDictionary* videoDic in videosArr) {
			// create video from dictionnary
			VideoObject* videoObject = [[[VideoObject alloc] initFromDictionnary:videoDic] retain];
			[videos addObject:videoObject];
		}
		[videos retain];
	}
	
	return self;
}

@end
