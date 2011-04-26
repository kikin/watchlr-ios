//
//  DeleteVideoResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonRequest.h"
#import "DeleteVideoResponse.h"
#import "VideoObject.h"

@interface DeleteVideoRequest : JsonRequest {
	VideoObject* videoObject;
}

- (void) doDeleteVideoRequest:(VideoObject*)video;

@property(nonatomic,assign) VideoObject* videoObject;

@end
