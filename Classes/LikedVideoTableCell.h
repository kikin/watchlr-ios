//
//  VideoTableCell.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "VideoTableCell.h"
#import "AddVideoRequest.h"

@interface LikedVideoTableCell : VideoTableCell {
    UIImageView* addVideoImageView;
    AddVideoRequest* addVideoRequest;
}

- (void) onAddVideoRequestSuccess: (AddVideoResponse*)response;
- (void) onAddVideoRequestFailed: (NSString*)errorMessage;

@end
