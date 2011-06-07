//
//  FileUtils.h
//  KikinIos
//
//  Created by ludovic cabre on 4/8/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileUtils : NSObject {

}

+ (NSString*) getDocumentDirectory;
+ (NSString*) getDocumentFilePath: (NSString*)name;
+ (BOOL) isOlderThan: (NSString*)name nbDays:(int)nbDays;
+ (NSArray*) getAllFilenameInDocuments;
+ (BOOL) fileExists: (NSString*)name;
+ (void) deleteFile: (NSString*)name;

@end
