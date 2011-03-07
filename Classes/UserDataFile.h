//
//  UserDataFile.h
//  KikinVideo
//
//  Created by ludovic cabre on 2/25/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PListFile.h"

@interface UserDataFile : PListFile {
	NSString* userId;
}

- (void) load;
- (void) save;

@property(nonatomic, copy) NSString* userId;

@end
