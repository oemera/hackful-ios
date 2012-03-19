//
//  EntryListNew.m
//  hackful
//
//  Created by Ömer Avci on 02.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKAPI.h"
#import "NSDate+RailsDate.h"
#import "HKPostList.h"
#import "AFNetworking.h"
#import "HKPost.h"
#import "HKUser.h"

@implementation HKPostList

@synthesize delegate = _delegate;

- (id)initWithResourcePath:(NSString *)path {
    if(self = [super init]) {
        resourcePath = path;
        isLoading = NO;
    }
    return self;
}

- (void)beginLoading {
    NSLog(@"beginLoading path: %@", resourcePath);
    [HKAPI loadEntriesWithResourcePath:resourcePath type:kHKEntryTypePost delegate:self];
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
