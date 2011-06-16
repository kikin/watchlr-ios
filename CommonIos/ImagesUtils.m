//
//  ImagesUtils.m
//  KikinIos
//
//  Created by ludovic cabre on 4/8/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ImagesUtils.h"
#import "FileUtils.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImagesUtils

+ (void) captureWebViewToFile: (NSString*)name webView:(UIWebView*)webView size:(CGSize)size {
	// capture image
	UIImage* image = [self captureWebView:webView];
	
	// scale it
	UIImage* scaledImage = [self scaleImage:image scaledToSize:size];
	
	// save to a file
	[self saveImageToPngFile: scaledImage name:name];
}

+ (UIImage*) captureWebView: (UIWebView*)webView {
	// capture webview
	UIGraphicsBeginImageContext(webView.bounds.size);
	[webView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

+ (UIImage*) scaleImage: (UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void) saveImageToPngFile: (UIImage *)image name:(NSString*)name {
	NSString* imagePath = [FileUtils getDocumentFilePath:name];
	
	LOG_INFO(@"Saving an image to %@", imagePath);
	
	NSData * data = UIImagePNGRepresentation(image);
	BOOL success = [data writeToFile:imagePath atomically:NO];
	if (!success) @throw [NSException exceptionWithName:@"file" reason:@"could not write the image file" userInfo:nil];
}

@end
