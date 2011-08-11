//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonIos/Callback.h"

@interface SourceObject : NSObject {
	NSString*   favicon;
    NSString*   name;
	NSString*   sourceUrl;
    UIImage*    faviconImage;
    
    bool        isFaviconImageLoaded;
    Callback*   onFaviconImageLoaded;
}

@property(retain)	NSString* favicon;
@property(retain)	NSString* name;
@property(retain)	NSString* sourceUrl;
@property(retain)	UIImage* faviconImage;
@property()         bool isFaviconImageLoaded;
@property(retain)   Callback* onFaviconImageLoaded;

- (id) initFromDictionary: (NSDictionary*)data;

@end
