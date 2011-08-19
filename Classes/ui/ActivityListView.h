//
//  ConnectMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideosListView.h"

@interface ActivityListView: VideosListView {
    NSMutableArray* activitiesList;
    Callback* onUserNameClickedCallback;
}

@property(retain) Callback* onUserNameClickedCallback;

@end
