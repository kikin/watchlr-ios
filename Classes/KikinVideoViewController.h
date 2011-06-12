//
//  MostViewedViewController.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerViewController.h"
#import "DeleteVideoRequest.h"

@interface KikinVideoToolBar : UIToolbar {
    UIImageView* kikinLogo;
}
@end

@interface KikinVideoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	DeleteVideoRequest* deleteVideoRequest;
	UITableView* videosTable;
	UIBarButtonItem* disconnectButton;
	UIBarButtonItem* refreshButton;
	KikinVideoToolBar* topToolbar;
	NSMutableArray* videos;
}

- (void) onClickDisctonnect;
- (void) onClickRefresh;
- (void) playVideo:(VideoObject*)videoObject;

@end
