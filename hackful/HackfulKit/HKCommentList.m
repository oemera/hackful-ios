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

@interface HKCommentList()

@property (nonatomic, strong, readonly) RKObjectManager *objectManager;
@property (nonatomic, strong, readonly) RKObjectMapping *commentsMapping;

-(void)finishedLoading;

@end

@implementation HKCommentList

@synthesize delegate = _delegate;
@synthesize objectManager = _objectManager;
@synthesize commentsMapping = _commentsMapping;

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
    
    [self.objectManager loadObjectsAtResourcePath:commentPath
                                    objectMapping:self.commentsMapping 
                                         delegate:self];
    
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

- (RKObjectManager*)objectManager {
    if(_objectManager == nil) {
        _objectManager = [RKObjectManager objectManagerWithBaseURL:HACKFUL_API_BASE_URL]; 
    }
    return _objectManager;
}

- (RKObjectMapping*)commentsMapping {
    if(_commentsMapping == nil) {
        RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[HKUser class]];
        [userMapping mapKeyPath:@"id" toAttribute:@"objectId"];
        [userMapping mapKeyPath:@"name" toAttribute:@"name"];
        
        _commentsMapping = [RKObjectMapping mappingForClass:[HKComment class]];
        [_commentsMapping mapKeyPath:@"id" toAttribute:@"objectId"];
        [_commentsMapping mapKeyPath:@"created_at" toAttribute:@"posted"];
        [_commentsMapping mapKeyPath:@"up_votes" toAttribute:@"votes"];
        [_commentsMapping mapKeyPath:@"text" toAttribute:@"text"];
        [_commentsMapping mapKeyPath:@"commentable_id" toAttribute:@"commentableId"];
        [_commentsMapping mapKeyPath:@"commentable_type" toAttribute:@"commentableType"];
        [_commentsMapping mapKeyPath:@"user" toRelationship:@"user" withMapping:userMapping];
    }
    return _commentsMapping;
}

#pragma mark - RKObjectMappingDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    RKLogInfo(@"Load collection of comments: %@", objects);
    [self.mutableEntries setArray:objects];
    NSLog(@"comments loaded: %d", [self.mutableEntries count]);
    
    isLoading = NO;
    [self finishedLoading];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
    NSLog(@"Error while loading: %@", error);
    
    isLoading = NO;
    [self finishedLoading];
}

@end
