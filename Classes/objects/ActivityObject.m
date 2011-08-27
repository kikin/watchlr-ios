//
//  VideoObject.m
//  KikinVideo
//
//  Created by ludovic cabre on 2/24/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "ActivityObject.h"

// -----------------------------------------------------------
//                    Pair
// -----------------------------------------------------------
@implementation ActivityStringPair

@synthesize key, value;

- (void) dealloc {
    [key release];
    [value release];
    [super dealloc];
}

@end

// -----------------------------------------------------------
//                    User Activity
// -----------------------------------------------------------
@implementation ActivityObject

// 

@synthesize timestamp, activity_heading, activityHeadingLabelsList, userActivities, video;

- (void) getActivityHeadingLabels:(NSMutableArray*) activityHeadingLabels {
    NSError* error = NULL;
    NSRegularExpression *htmlLinksRegex = [NSRegularExpression regularExpressionWithPattern:@"<a href=(.+?)<\\/a>"
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error];
    
    // If there is no error in regex, try to find all the matches in regex 
    int previousLinkEndPos = 0;
    if (error == NULL) {
        NSArray* matchedStrings = [htmlLinksRegex matchesInString:activity_heading options:0 range:NSMakeRange(0, [activity_heading length])];
        if ([matchedStrings count] > 0) {
            for (NSTextCheckingResult* result in matchedStrings) {
                NSString* textWithoutLink = [activity_heading substringWithRange:NSMakeRange(previousLinkEndPos, (result.range.location - previousLinkEndPos))];
//                LOG_DEBUG(@"Text without link:%@", textWithoutLink);
                if ([textWithoutLink length] > 0) {
                    ActivityStringPair* pair = [[[ActivityStringPair alloc] init] autorelease];
                    pair.key = textWithoutLink;
                    pair.value = @"";
                    [activityHeadingLabels addObject:pair];
                }
                
                
                NSString* matchedString = [activity_heading substringWithRange:result.range];
//                LOG_DEBUG(@"Matched string:%@", matchedString);
                
                NSRange urlStartPosRange = [matchedString rangeOfString:@"href="];
                NSRange urlEndPosRange = [matchedString rangeOfString:@" target=_blank>"];
                if (urlEndPosRange.location == NSNotFound)
                    urlEndPosRange = [matchedString rangeOfString:@">"];
                NSRange urlRange = NSMakeRange((urlStartPosRange.location + urlStartPosRange.length), (urlEndPosRange.location - (urlStartPosRange.location + urlStartPosRange.length)));
                
                NSRange textEndPosRange = [matchedString rangeOfString:@"</a>"];
                NSRange textRange = NSMakeRange((urlEndPosRange.location + urlEndPosRange.length), (textEndPosRange.location - (urlEndPosRange.location + urlEndPosRange.length)));
                
                ActivityStringPair* pair = [[[ActivityStringPair alloc] init] autorelease];
                pair.key = [matchedString substringWithRange:textRange];
                pair.value = [matchedString substringWithRange:urlRange];
                [activityHeadingLabels addObject:pair];
                
//                LOG_DEBUG(@"Key:%@, Value:%@", pair.key, pair.value);
                
                previousLinkEndPos = result.range.location + result.range.length;
            }
        }
    }    
    
    NSString* textWithoutLink = [activity_heading substringFromIndex:previousLinkEndPos];
    if ([textWithoutLink length] > 0) {
        ActivityStringPair* pair = [[[ActivityStringPair alloc] init] autorelease];
        pair.key = textWithoutLink;
        pair.value = @"";
        [activityHeadingLabels addObject:pair];
    }
//    LOG_DEBUG(@"Text at the end:%@", textWithoutLink);
    
}

- (id) initFromDictionary: (NSDictionary*)data { 
    self.timestamp = [data objectForKey:@"timestamp"] != [NSNull null] ? [[data objectForKey:@"timestamp"] doubleValue] : 0.0;
    self.activity_heading = [data objectForKey:@"activity_heading"] != [NSNull null] ? [data objectForKey:@"activity_heading"] : nil;
    self.video = [data objectForKey:@"video"] != [NSNull null] ? [[[VideoObject alloc] initFromDictionary:[data objectForKey:@"video"]] autorelease] : nil;
    
    if (self.activity_heading != nil) {
        activityHeadingLabelsList = [[NSMutableArray alloc] initWithCapacity:5];
        [self getActivityHeadingLabels:activityHeadingLabelsList];
    }
    
    NSArray* userActivitiesList = [data objectForKey:@"user_activities"];
    if (userActivitiesList != nil) {
        userActivities = [[NSMutableArray alloc] init];
        for (NSDictionary* userActivity in userActivitiesList) {
            UserActivityObject* userActivityObject = [[[UserActivityObject alloc] initFromDictionary:userActivity] autorelease];
            [userActivities addObject:userActivityObject];
        }
    } else {
        userActivities = nil;
    }
    
    return self;
}

- (void) updateFromDictionary: (NSDictionary*)data { 
    timestamp = [data objectForKey:@"timestamp"] != [NSNull null] ? [[data objectForKey:@"timestamp"] doubleValue] : 0.0;
    activity_heading = [data objectForKey:@"activity_heading"] != [NSNull null] ? [data objectForKey:@"activity_heading"] : nil;
    if ([data objectForKey:@"video"] != [NSNull null]) {
        [video updateFromDictionary:[data objectForKey:@"video"]];
    }
    
    if (activityHeadingLabelsList != nil) {
        [activityHeadingLabelsList release];
        activityHeadingLabelsList = nil;
    }
    
    if (activity_heading != nil) {
        activityHeadingLabelsList = [[NSMutableArray alloc] initWithCapacity:5];
        [self getActivityHeadingLabels:activityHeadingLabelsList];
    }
    
    // release the previous list of user activities object and create the new one.
    [userActivities release];
    userActivities = nil;
    NSArray* userActivitiesList = [data objectForKey:@"user_activities"];
    if (userActivitiesList != nil) {
        userActivities = [[NSMutableArray alloc] init];
        for (NSDictionary* userActivity in userActivitiesList) {
            UserActivityObject* userActivityObject = [[[UserActivityObject alloc] initFromDictionary:userActivity] autorelease];
            [userActivities addObject:userActivityObject];
        }
    }
}

- (NSDictionary*) toDictionary {
    NSMutableDictionary* userActivity = [[[NSMutableDictionary alloc] init] autorelease];
    
    [userActivity setObject:[[NSNumber numberWithDouble:timestamp] stringValue] forKey:@"timestamp"];
    [userActivity setObject:activity_heading forKey:@"activity_heading"];
    [userActivity setObject:userActivities forKey:@"user_activities"];
    [userActivity setObject:video forKey:@"video"];
    
    return userActivity;
}

- (void) dealloc {
//    if (activity_heading != nil) {
//        [activity_heading release];
//    }
    [activityHeadingLabelsList release];
    [userActivities release];
    [video release];
    
    activity_heading = nil;
    userActivities = nil;
    video = nil;
    activityHeadingLabelsList = nil;
    
    [super dealloc];
}

@end