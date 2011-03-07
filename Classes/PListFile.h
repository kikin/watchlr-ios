//
//  PListFile.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PListFile : NSObject {
	NSString* fileName;
}

@property(nonatomic, copy) NSString* fileName;

- (id) init: (NSString*)file;
- (NSDictionary*) load;
- (void) save: (NSDictionary*)pList;
- (NSString*) getPath;

@end
