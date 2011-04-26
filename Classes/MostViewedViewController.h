//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoTableCell.h"
#import "VideoListResponse.h"
#import "PlayerViewController.h"
#import "VideoListRequest.h"
#import "DeleteVideoRequest.h"

@interface MostViewedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	VideoListRequest* videoListRequest;
	VideoListResponse* videoListResponse;
	DeleteVideoRequest* deleteVideoRequest;
	UITableView* videosTable;
	UIBarButtonItem* disconnectButton;
	UIBarButtonItem* refreshButton;
	UIToolbar* topToolbar;
	NSMutableArray* videos;
}

- (void)doVideoListRequest;
- (void) onClickDisctonnect;
- (void) onClickRefresh;

@end
