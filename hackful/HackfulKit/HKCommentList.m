//
//  CommentList.m
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKCommentList.h"
#import "HKPost.h"
#import "HKComment.h"
#import "HKUser.h"

#define HACKFUL_API_BASE_URL @"http://192.168.1.110:3000/api/v1"

@implementation HKCommentList

@synthesize delegate = _delegate;

- (id)initWithPost:(HKPost *)post_ {
    if(self = [super init]) {
        post = post_;
        // TODO: change objectId to int
        commentPath = [NSString stringWithFormat:@"/comments/post/%@", [post objectId]];
        isLoading = NO;
    }
    
    return self;
}

- (void)beginLoading {
    NSLog(@"beginLoading path: %@", commentPath);
    
    [self.mutableEntries removeAllObjects];
    isLoading = YES;
}

- (void)finishedLoading {
    NSLog(@"finishedLoading");
    if ([self.delegate respondsToSelector:@selector(listFinishedLoading:)]) {
        NSLog(@"respondsToSelector entryListFinishedLoading");
		[self.delegate listFinishedLoading:self];
    } else {
        NSLog(@"didn't respondToSelector entryListFinishedLoading");
    }
}

- (BOOL)isLoading {
    return isLoading;
}

- (NSMutableArray *)mutableEntries {
    if(_mutableEntries == nil) _mutableEntries = [[NSMutableArray alloc] init];
    return _mutableEntries;
}

@end
