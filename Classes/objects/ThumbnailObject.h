//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonIos/Callback.h"

@interface ThumbnailObject : NSObject {
	int         height;
    int         width;
    
	NSString*   thumbnailUrl;
    UIImage*    thumbnailImage;
    
    Callback*   onThumbnailImageLoaded;
}

@property()			int height;
@property()			int width;
@property(retain)	NSString* thumbnailUrl;
@property(retain)	UIImage* thumbnailImage;
@property(retain)   Callback* onThumbnailImageLoaded;

- (id) initFromDictionary: (NSDictionary*)data;


@end
