//
//  CommentList.m
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKAPI.h"
#import "AFNetworking.h"
#import "HKCommentList.h"
#import "HKPost.h"
#import "HKComment.h"
#import "HKUser.h"

@implementation HKCommentList

@synthesize delegate = _delegate;

- (id)initWithPost:(HKPost *)post_ {
    if(self = [super init]) {
        post = post_;
        NSLog(@"objectId: %d", post_.objectId);
        // TODO: change objectId to int
        resourcePath = [NSString stringWithFormat:kHKCommentsForPostResourcePath, [post objectId]];
        isLoading = NO;
    }
    
    return self;
}

- (void)beginLoading {
    NSLog(@"beginLoading path: %@", resourcePath);
    [HKAPI loadEntriesWithResourcePath:resourcePath type:kHKEntryTypeComment delegate:self];
    isLoading = YES;
}

- (BOOL)isLoading {
    return isLoading;
}

#pragma mark - HKAPIDelegate

- (void)APICallCompleteWithList:(NSArray*)entries {
    self.entries = entries;
    isLoading = NO;
    if ([self.delegate respondsToSelector:@selector(listFinishedLoading:)]) {
        NSLog(@"respondsToSelector entryListFinishedLoading");
        [self.delegate listFinishedLoading:self];
    }
}

- (void)APICallFailed:(NSError*)error {
    isLoading = NO;
    if ([self.delegate respondsToSelector:@selector(listFinishedLoading:withError:)]) {
        NSLog(@"respondsToSelector listFinishedLoading:withError:");
        /*NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
         [errorDetail setValue:@"Failed to load comments" forKey:NSLocalizedDescriptionKey];
         NSError *error = [NSError errorWithDomain:@"HKCommentList" code:-1 userInfo:errorDetail];*/
        [self.delegate listFinishedLoading:self withError:error];
    }
}

@end
