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
    
    NSURL *url = [NSURL URLWithString:kHKBaseAPIURL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" 
                                                            path:resourcePath
                                                      parameters:nil];
    
    __block HKCommentList *blocksafeSelf = self;
    AFJSONRequestOperation *operation;
    operation =  [AFJSONRequestOperation 
                  JSONRequestOperationWithRequest:request
                  success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                      [blocksafeSelf.mutableEntries removeAllObjects];
                      for (id jsonComment in jsonObject) {
                          HKComment *comment = [HKComment commentFromJSON:jsonComment];
                          [blocksafeSelf.mutableEntries addObject:comment];
                      }
                      isLoading = NO;
                      
                      if ([blocksafeSelf.delegate respondsToSelector:@selector(listFinishedLoading:)]) {
                          NSLog(@"respondsToSelector entryListFinishedLoading");
                          [blocksafeSelf.delegate listFinishedLoading:self];
                      }
                  }
                  failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                      NSLog(@"Couldn't load comments");
                      NSLog(@"error %@", error);
                      if ([blocksafeSelf.delegate respondsToSelector:@selector(listFinishedLoading:withError:)]) {
                          NSLog(@"respondsToSelector listFinishedLoading:withError:");
                          /*NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                          [errorDetail setValue:@"Failed to load comments" forKey:NSLocalizedDescriptionKey];
                          NSError *error = [NSError errorWithDomain:@"HKCommentList" code:-1 userInfo:errorDetail];*/
                          [blocksafeSelf.delegate listFinishedLoading:self withError:error];
                      }
                  }];
    [operation start];
    isLoading = YES;
}

- (BOOL)isLoading {
    return isLoading;
}

- (NSMutableArray *)mutableEntries {
    if(_mutableEntries == nil) _mutableEntries = [[NSMutableArray alloc] init];
    return _mutableEntries;
}

@end
