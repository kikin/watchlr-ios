//
//  UrlUtils.h
//  KikinIos
//
//  Created by ludovic cabre on 4/29/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlUtils : NSObject {
	
}

+ (NSString*) encodeParameters: (NSDictionary*)params;
+ (NSString*) urlWithoutHash: (NSString*)url;
+ (BOOL) isSameUrlWithoutHash: (NSString*)url1 url:(NSString*)url2;
+ (BOOL) isOnlyDifferenceHash: (NSString*)url1 url:(NSString*)url2;

@end
