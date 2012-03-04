//
//  EntryListNew.m
//  hackful
//
//  Created by Ömer Avci on 02.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKPostList.h"
#import "HKPost.h"
#import "HKUser.h"

#define HACKFUL_API_BASE_URL @"http://192.168.1.110:3000/api/v1"

@interface HKPostList()

@property (nonatomic, strong, readonly) RKObjectManager *objectManager;
@property (nonatomic, strong, readonly) RKObjectMapping *postsMapping;

- (void)finishedLoading;

@end

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
    NSLog(@"beginLoading");
    [self.objectManager loadObjectsAtResourcePath:resourcePath
                               objectMapping:self.postsMapping 
                                    delegate:self];
    
    [self.mutableEntries removeAllObjects];
    isLoading = YES;
}

- (void)finishedLoading {
    if ([self.delegate respondsToSelector:@selector(listFinishedLoading:)]) {
        NSLog(@"respondsToSelector entryListFinishedLoading");
		[self.delegate listFinishedLoading:self];
    }
}

- (BOOL)isLoading {
    return isLoading;
}

- (NSMutableArray *)mutableEntries {
    if(_mutableEntries == nil) _mutableEntries = [[NSMutableArray alloc] init];
    return _mutableEntries;
}

- (RKObjectManager*)objectManager {
    if(_objectManager == nil) {
        _objectManager = [RKObjectManager objectManagerWithBaseURL:HACKFUL_API_BASE_URL];
    }
    return _objectManager;
}

- (RKObjectMapping*)postsMapping {
    if(_postsMapping == nil) {
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[HKUser class]];
        [userMapping mapKeyPath:@"id" toAttribute:@"objectId"];
        [userMapping mapKeyPath:@"name" toAttribute:@"name"];
        
        _postsMapping = [RKObjectMapping mappingForClass:[HKPost class]];
        [_postsMapping mapKeyPath:@"id" toAttribute:@"objectId"];
        [_postsMapping mapKeyPath:@"created_at" toAttribute:@"posted"];
        [_postsMapping mapKeyPath:@"up_votes" toAttribute:@"votes"];
        [_postsMapping mapKeyPath:@"link" toAttribute:@"link"];
        [_postsMapping mapKeyPath:@"text" toAttribute:@"text"];
        [_postsMapping mapKeyPath:@"title" toAttribute:@"title"];
        [_postsMapping mapKeyPath:@"comment_count" toAttribute:@"commentCount"];
        [_postsMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
    }
    return _postsMapping;
}

#pragma mark - RKObjectMappingDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    RKLogInfo(@"Load collection of Posts: %@", objects);
    [self.mutableEntries setArray:objects];
    NSLog(@"posts loaded: %d", [self.mutableEntries count]);
    
    isLoading = NO;
    [self finishedLoading];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NSLog(@"Error while loading: %@", error);
    
    isLoading = NO;
    [self finishedLoading];
}

@end
