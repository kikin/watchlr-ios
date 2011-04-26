//
//  VideoListResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultResponse.h"

@interface VideoListResponse : DefaultResponse {
	int			count;
	int			start;
	NSMutableArray* videos;
}

- (NSArray*) videos;
- (id) initWithResponse: (id)jsonObject;

@end
