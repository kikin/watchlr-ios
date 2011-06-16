//
//  FileUtils.m
//  KikinIos
//
//  Created by ludovic cabre on 4/8/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "FileUtils.h"

@implementation FileUtils

+ (NSString*) getDocumentDirectory {
	return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+ (NSString*) getDocumentFilePath: (NSString*)name {
	return [[[self getDocumentDirectory] stringByAppendingString:@"/"] stringByAppendingString:name];
}

+ (BOOL) isOlderThan: (NSString*)name nbDays:(int)nbDays {
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	NSString* filePath = [self getDocumentFilePath:name];
	NSDictionary* attributes = [fileMgr attributesOfItemAtPath:filePath error: nil];
	if (attributes != nil) {
		NSDate* modifiedDate = [attributes objectForKey:NSFileModificationDate];
		if (modifiedDate != nil) {
			NSTimeInterval time = [[NSDate date] timeIntervalSinceDate: modifiedDate];
			return time > 60*60*24*nbDays;
		}
	}
	return NO;
}

+ (NSArray*) getAllFilenameInDocuments {
	NSMutableArray* ret = [[NSMutableArray alloc] init];
	
	NSString* docsDir = [self getDocumentDirectory];
	NSFileManager* localFileManager = [[NSFileManager alloc] init];
	NSDirectoryEnumerator* dirEnum = [localFileManager enumeratorAtPath:docsDir];
	
	NSString* filename;
	while (nil != (filename = [dirEnum nextObject])) {
		[ret addObject:filename];
	}
	
	[localFileManager release];
	return [ret autorelease];
}

+ (BOOL) fileExists: (NSString*)name {
	NSFileManager* fileMgr = [NSFileManager defaultManager];
	NSString* filePath = [self getDocumentFilePath:name];
	return [fileMgr fileExistsAtPath:filePath];
}

+ (void) deleteFile: (NSString*)name {
	NSError *error;
	NSString* filePath = [self getDocumentFilePath:name];
	NSFileManager *fileMgr = [NSFileManager defaultManager];	
	
	if ([fileMgr removeItemAtPath:filePath error:&error] != YES) {
		LOG_ERROR(@"an error occured while trying to delete a file %@: %@", filePath, error);
	}
}

@end
