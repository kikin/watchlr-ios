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

- (id) initWithResponse: (NSDictionary*)jsonObject {
	if ((self = [super initWithResponse:jsonObject])) {
		if (success) {
			// get the result in the thing
			NSDictionary* response = [jsonObject objectForKey:@"result"];
			
			// get count/start
			count = [[response objectForKey:@"count"] intValue];
			start = [[response objectForKey:@"start"] intValue];
			
			// get all the videos
			if (count > 0) {
				NSArray* videosArr = [response objectForKey:@"videos"];
				
				// create our video array
				videos = [[NSMutableArray alloc] init];
				for (NSDictionary* videoDic in videosArr) {
					// create video from dictionnary
					VideoObject* videoObject = [[VideoObject alloc] initFromDictionnary:videoDic];
					[videos addObject:videoObject];
					[videoObject release];
				}
			}
		}
	}
	return self;
}

- (int) count {
	return count;
}

- (int) start {
	return start;
}

- (NSArray*) videos {
	return videos;
}

- (void) dealloc {
	[videos release];
	[super dealloc];
}

@end
