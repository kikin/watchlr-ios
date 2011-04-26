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
	bool		watched;
}

@property()			int videoId;
@property(retain)	NSString* title;
@property(retain)	NSString* description;
@property(retain)	NSString* videoUrl;
@property(retain)	NSString* embedUrl;
@property(retain)	NSString* imageUrl;
@property()			long timestamp;
@property()			bool viewed;

- (id) initFromDictionnary: (NSDictionary*)data;

@end
