//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoObject : NSObject {
	int			videoId;
	NSString*	title;
	NSString*	description;
	NSString*	embedUrl;
	NSString*	videoUrl;
	NSString*	imageUrl;
	long		timestamp;
	bool		viewed;
}

@property(nonatomic) int videoId;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* description;
@property(nonatomic,copy) NSString* videoUrl;
@property(nonatomic,copy) NSString* embedUrl;
@property(nonatomic,copy) NSString* imageUrl;
@property(nonatomic) long timestamp;
@property(nonatomic) bool viewed;

- (id) initFromDictionnary: (NSDictionary*)data;

@end
