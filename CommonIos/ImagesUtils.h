//
//  ImagesUtils.h
//  KikinIos
//
//  Created by ludovic cabre on 4/8/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ImagesUtils : NSObject {

}

+ (UIImage*) captureWebView: (UIWebView*)webView;
+ (void) captureWebViewToFile: (NSString*)name webView:(UIWebView*)webView size:(CGSize)size;
+ (UIImage *)scaleImage:(UIImage *)image scaledToSize:(CGSize)newSize;
+ (void) saveImageToPngFile: (UIImage *)image name:(NSString*)name;

@end
