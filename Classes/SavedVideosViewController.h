//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "KikinVideoViewController.h"
#import "VideoListResponse.h"
#import "VideoListRequest.h"

@interface SavedVideosViewController : KikinVideoViewController {
	VideoListRequest* videoListRequest;
	VideoListResponse* videoListResponse;
}

- (void) doVideoListRequest;

@end