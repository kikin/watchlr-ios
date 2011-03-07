//
//  VideoListResponse.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoListResponse : NSObject {
	int			count;
	int			start;
	NSMutableArray* videos;
}

- (id) initWithResponse: (id)jsonObject;

@property(nonatomic) int count;
@property(nonatomic) int start;
@property(nonatomic,copy) NSMutableArray* videos;

@end
