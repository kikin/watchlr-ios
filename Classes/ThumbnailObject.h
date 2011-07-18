//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ThumbnailObject : NSObject {
	int             height;
    int             width;
	NSString*       thumbnailUrl;
    UIImage*        thumbnailImage;
}

@property()			int height;
@property()			int width;
@property(retain)	NSString* thumbnailUrl;
@property(retain)	UIImage* thumbnailImage;

- (id) initFromDictionnary: (NSDictionary*)data;

@end
