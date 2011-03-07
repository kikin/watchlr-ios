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

@interface MostViewedViewController : UIViewController {
	VideoListResponse* videoListResponse;
	IBOutlet UITableView* listTableView;
	IBOutlet PlayerViewController* playerViewController;
}

- (void)doVideoListRequest;
- (IBAction) onClickDisctonnect;
- (IBAction) onClickRefresh;

@end
