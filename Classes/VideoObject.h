//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface VideoObject : NSObject {
	int             videoId;
    int             likes;
	NSString*       title;
	NSString*       description;
	NSString*       embedUrl;
	NSString*       videoUrl;
	NSDictionary*	thumbnail;
    NSDictionary*	videoSource;
    NSString*       htmlCode;
    bool            liked;
    bool            saved;
    double          seek;
}

@property()			int videoId;
@property()			int likes;
@property(retain)	NSString* title;
@property(retain)	NSString* description;
@property(retain)	NSString* videoUrl;
@property(retain)	NSString* embedUrl;
@property(retain)	NSDictionary* thumbnail;
@property(retain)	NSDictionary* videoSource;
@property(retain)	NSString* htmlCode;
@property()			bool liked;
@property()			bool saved;
@property()         double seek;

- (id) initFromDictionnary: (NSDictionary*)data;

@end
