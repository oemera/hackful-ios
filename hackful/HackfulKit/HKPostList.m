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
    NSLog(@"beginLoading");
    
    NSURL *url = [NSURL URLWithString:kHKBaseAPIURL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    //NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:page, @"page", nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" 
                                                            path:resourcePath
                                                      parameters:nil];
    
    __block HKPostList *blocksafeSelf = self;
    AFJSONRequestOperation *operation;
    operation =  [AFJSONRequestOperation 
                  JSONRequestOperationWithRequest:request
                  success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                      [blocksafeSelf.mutableEntries removeAllObjects];
                      for (id jsonPost in jsonObject) {
                          HKPost *post = [HKPost postFromJSON:jsonPost];
                          [blocksafeSelf.mutableEntries addObject:post];
                      }
                      isLoading = NO;
                      
                      if ([blocksafeSelf.delegate respondsToSelector:@selector(listFinishedLoading:)]) {
                          NSLog(@"respondsToSelector entryListFinishedLoading");
                          [blocksafeSelf.delegate listFinishedLoading:self];
                      }
                  }
                  failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                      NSLog(@"Couldn't load posts");
                      isLoading = NO;
                      
                      if ([blocksafeSelf.delegate respondsToSelector:@selector(listFinishedLoading:withError:)]) {
                          NSLog(@"respondsToSelector listFinishedLoading:withError:");
                          
                          NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                          [errorDetail setValue:@"Failed to load posts" forKey:NSLocalizedDescriptionKey];
                          NSError *error = [NSError errorWithDomain:@"HKCommentList" code:-1 userInfo:errorDetail];
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
