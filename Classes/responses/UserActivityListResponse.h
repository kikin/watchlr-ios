//
//  VideoListResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultResponse.h"

@interface UserActivityListResponse : DefaultResponse {
	int	count;
	int	page;
    int total;
	NSMutableArray* activities;
}

- (NSArray*) activities;
- (int) count;
- (int) page;
- (int) total;
- (id) initWithResponse: (id)jsonObject;

@end
