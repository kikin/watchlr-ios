//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThumbnailObject.h"
#import "SourceObject.h"

@interface VideoObject : NSObject {
	int                 videoId;
    int                 likes;
	NSString*           title;
	NSString*           description;
	NSString*           embedUrl;
	NSString*           videoUrl;
	ThumbnailObject*	thumbnail;
    SourceObject*	videoSource;
    NSString*           htmlCode;
    bool                liked;
    bool                saved;
    double              seek;
}

@property()			int videoId;
@property()			int likes;
@property(retain)	NSString* title;
@property(retain)	NSString* description;
@property(retain)	NSString* videoUrl;
@property(retain)	NSString* embedUrl;
@property(retain)	ThumbnailObject* thumbnail;
@property(retain)	SourceObject* videoSource;
@property(retain)	NSString* htmlCode;
@property()			bool liked;
@property()			bool saved;
@property()         double seek;

- (id) initFromDictionnary: (NSDictionary*)data;

@end
