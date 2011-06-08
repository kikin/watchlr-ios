//
//  VideoObject.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SourceObject : NSObject {
	NSString*   favicon;
    NSString*   name;
	NSString*   sourceUrl;
}

@property(retain)	NSString* favicon;
@property(retain)	NSString* name;
@property(retain)	NSString* sourceUrl;

- (id) initFromDictionnary: (NSDictionary*)data;

@end
