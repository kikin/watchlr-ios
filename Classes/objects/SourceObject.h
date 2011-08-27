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
    
    NSMutableData*      faviconImageData;
    NSURLConnection*    faviconImageUrlConnection;
    NSLock*             faviconImageLoadedCallbackLock;
    
    bool        isFaviconImageLoaded;
    Callback*   onFaviconImageLoaded;
}

@property(retain)	NSString* favicon;
@property(retain)	NSString* name;
@property(retain)	NSString* sourceUrl;
@property(retain)	UIImage* faviconImage;
@property()         bool isFaviconImageLoaded;

- (id) initFromDictionary: (NSDictionary*)data;
- (void) setFaviconImageLoadedCallback:(Callback*)callback;
- (void) resetFaviconImageLoadedCallback;

@end
