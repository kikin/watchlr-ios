//
//  ErrorMainView.h
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonIos/Callback.h>

@interface UserListView : UIView<UITableViewDelegate, UITableViewDataSource> {
    UITableView*                userListView;
    UIActivityIndicatorView*    loadingView;
    
    NSMutableArray*             usersList;
}

@property(retain) Callback* openUserProfileCallback;

- (void)    updateListWrapper: (NSDictionary*)args;
- (int)     count;
- (void)    resetLoadingStatus;

@end
