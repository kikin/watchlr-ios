//
//  LoadingMainView.m
//  KikinVideo
//
//  Created by ludovic cabre on 5/6/11.
//  Copyright 2011 kikin. All rights reserved.
//

#import "UIActivityHeadingLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "ActivityObject.h"

@implementation UIActicityHeadingLabel

@synthesize onUsernameClicked;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        label1 = [[UILabel alloc] init];
        label1.font = [UIFont systemFontOfSize:18];
        label1.numberOfLines = 1;
        label1.backgroundColor = [UIColor clearColor];
        label1.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label1]; 
        
        label2 = [[UILabel alloc] init];
        label2.font = [UIFont systemFontOfSize:18];
        label2.numberOfLines = 1;
        label2.backgroundColor = [UIColor clearColor];
        label2.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label2]; 
        
        label3 = [[UILabel alloc] init];
        label3.font = [UIFont systemFontOfSize:18];
        label3.numberOfLines = 1;
        label3.backgroundColor = [UIColor clearColor];
        label3.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label3]; 
        
        label4 = [[UILabel alloc] init];
        label4.font = [UIFont systemFontOfSize:18];
        label4.numberOfLines = 1;
        label4.backgroundColor = [UIColor clearColor];
        label4.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label4]; 
        
        label5 = [[UILabel alloc] init];
        label5.font = [UIFont systemFontOfSize:18];
        label5.numberOfLines = 1;
        label5.backgroundColor = [UIColor clearColor];
        label5.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:label5];
    }
    return self;
}

- (void) dealloc {
    [label1 release];
    [label2 release];
    [label3 release];
    [label4 release];
    [label5 release];
    
    [onUsernameClicked release];
    [links release];
    
    [super dealloc];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    label1.frame = CGRectMake(0, 0, [label1.text sizeWithFont:label1.font].width, self.frame.size.height);
    int labelStartPos = label1.frame.size.width;
    
    label2.frame = CGRectMake(labelStartPos, 0, [label2.text sizeWithFont:label2.font].width, self.frame.size.height);
    labelStartPos += label2.frame.size.width;
    
    label3.frame = CGRectMake(labelStartPos, 0, [label3.text sizeWithFont:label3.font].width, self.frame.size.height);
    labelStartPos += label3.frame.size.width;
    
    label4.frame = CGRectMake(labelStartPos, 0, [label4.text sizeWithFont:label4.font].width, self.frame.size.height);
    labelStartPos += label4.frame.size.width;
    
    label5.frame = CGRectMake(labelStartPos, 0, [label5.text sizeWithFont:label5.font].width, self.frame.size.height);
    labelStartPos += label5.frame.size.width;
}

// --------------------------------------------------------------------------------
//                      Public functions
// --------------------------------------------------------------------------------

- (void) renderActivityHeading:(NSArray *)activityHeadingLabels {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    if (links != nil) [links release];
    
    links = [activityHeadingLabels retain];
    ActivityStringPair* pair = [links objectAtIndex:0];
    label1.text = pair.key;
    label1.frame = CGRectMake(0, 0, [label1.text sizeWithFont:label1.font].width, self.frame.size.height);
    if ([pair.value length] > 0) {
        label1.textColor = [UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0];
    } else {
        label1.textColor = [UIColor blackColor];
    }
    
    int labelStartPos = label1.frame.size.width;
    
    if ([links count] > 1) {
        ActivityStringPair* pair = [links objectAtIndex:1];
        label2.text = pair.key;
        label2.frame = CGRectMake(labelStartPos, 0, [label2.text sizeWithFont:label2.font].width, self.frame.size.height);
        
        if ([pair.value length] > 0) {
            label2.textColor = [UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0];
        } else {
            label2.textColor = [UIColor blackColor];
        }
        
        label2.hidden = NO;
        labelStartPos += label2.frame.size.width;
    } else {
        label2.hidden = YES;
    }
    
    if ([links count] > 2) {
        ActivityStringPair* pair = [links objectAtIndex:2];
        label3.text = pair.key;
        label3.frame = CGRectMake(labelStartPos, 0, [label3.text sizeWithFont:label3.font].width, self.frame.size.height);
        
        if ([pair.value length] > 0) {
            label3.textColor = [UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0];
        } else {
            label3.textColor = [UIColor blackColor];
        }
        
        label3.hidden = NO;
        labelStartPos += label3.frame.size.width;
    } else {
        label3.hidden = YES;
    }
    
    if ([links count] > 3) {
        ActivityStringPair* pair = [links objectAtIndex:3];
        label4.text = pair.key;
        label4.frame = CGRectMake(labelStartPos, 0, [label4.text sizeWithFont:label4.font].width, self.frame.size.height);
        
        if ([pair.value length] > 0) {
            label4.textColor = [UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0];
        } else {
            label4.textColor = [UIColor blackColor];
        }
        
        label4.hidden = NO;
        labelStartPos += label4.frame.size.width;
    } else {
        label4.hidden = YES;
    }
    
    if ([links count] > 4) {
        ActivityStringPair* pair = [links objectAtIndex:4];
        label5.text = pair.key;
        label5.frame = CGRectMake(labelStartPos, 0, [label5.text sizeWithFont:label5.font].width, self.frame.size.height);
        
        if ([pair.value length] > 0) {
            label5.textColor = [UIColor colorWithRed:(42.0/255.0) green:(172.0/255.0) blue:(225.0/255.0) alpha:1.0];
        } else {
            label5.textColor = [UIColor blackColor];
        }
        
        label5.hidden = NO;
        labelStartPos += label5.frame.size.width;
    } else {
        label5.hidden = YES;
    }
    
    [pool release];
}

// --------------------------------------------------------------------------------
//                      Touch delegates
// --------------------------------------------------------------------------------

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    for (UITouch *myTouch in touches)
    {
        CGPoint touchLocation = [myTouch locationInView:self];
        
        ActivityStringPair* pair = [links objectAtIndex:0];
        if ([pair.value length] > 0) {
            CGRect label1Rect = [label1 bounds];
            label1Rect = [label1 convertRect:label1Rect toView:self];
            if (CGRectContainsPoint(label1Rect, touchLocation)) {
                if (onUsernameClicked != nil) {
                    [onUsernameClicked execute:pair.value];
                }
            }
        }
        
        if ([links count] > 1) {
            pair = [links objectAtIndex:1];
            if ([pair.value length] > 0) {
                CGRect label2Rect = [label2 bounds];
                label2Rect = [label2 convertRect:label2Rect toView:self];
                if (CGRectContainsPoint(label2Rect, touchLocation)) {
                    if (onUsernameClicked != nil) {
                        [onUsernameClicked execute:pair.value];
                    }
                }
            }
        }
        
        if ([links count] > 2) {
            pair = [links objectAtIndex:2];
            if ([pair.value length] > 0) {
                CGRect label3Rect = [label3 bounds];
                label3Rect = [label3 convertRect:label3Rect toView:self];
                if (CGRectContainsPoint(label3Rect, touchLocation)) {
                    if (onUsernameClicked != nil) {
                        [onUsernameClicked execute:pair.value];
                    }
                }
            }
        }
        
        if ([links count] > 3) {
            pair = [links objectAtIndex:3];
            if ([pair.value length] > 0) {
                CGRect label4Rect = [label4 bounds];
                label4Rect = [label3 convertRect:label4Rect toView:self];
                if (CGRectContainsPoint(label4Rect, touchLocation)) {
                    if (onUsernameClicked != nil) {
                        [onUsernameClicked execute:pair.value];
                    }
                }
            }
        }
        
        if ([links count] > 4) {
            pair = [links objectAtIndex:4];
            if ([pair.value length] > 0) {
                CGRect label5Rect = [label5 bounds];
                label5Rect = [label5 convertRect:label5Rect toView:self];
                if (CGRectContainsPoint(label5Rect, touchLocation)) {
                    if (onUsernameClicked != nil) {
                        [onUsernameClicked execute:pair.value];
                    }
                }
            }
        }
        
    }
}

@end
