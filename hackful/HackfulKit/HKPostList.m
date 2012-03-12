//
//  EntryListNew.m
//  hackful
//
//  Created by Ömer Avci on 02.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKPostList.h"
#import "AFNetworking.h"
#import "HKPost.h"
#import "HKUser.h"

#define HACKFUL_API_BASE_URL @"http://192.168.1.110:3000"

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
    
    NSURL *url = [NSURL URLWithString:HACKFUL_API_BASE_URL];
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
                          NSInteger commentCount = [[jsonPost objectForKey:@"comment_count"] intValue];
                          NSString *createdAt = [jsonPost objectForKey:@"created_at"];
                          NSInteger objectId = [[jsonPost objectForKey:@"id"] intValue];
                          NSString *link = [jsonPost objectForKey:@"link"];
                          NSString *text = [jsonPost objectForKey:@"text"];
                          NSString *title = [jsonPost objectForKey:@"title"];
                          NSInteger upvotes = [[jsonPost objectForKey:@"up_votes"] intValue];
                          NSInteger userId = [[[jsonPost objectForKey:@"user"] objectForKey:@"id"] intValue];
                          NSString *username = [[jsonPost objectForKey:@"user"] objectForKey:@"name"];
                          
                          NSDate *posted = [NSDate date];
                          HKUser *user = [[HKUser alloc] initWithId:userId username:username andEmail:nil];
                          
                          HKPost *post = [[HKPost alloc] initWithObjectId:objectId 
                                                                     link:link 
                                                                    title:title 
                                                             commentCount:commentCount 
                                                                   posted:posted 
                                                                    votes:upvotes 
                                                                     text:text 
                                                                  andUser:user];
                          
                          [blocksafeSelf.mutableEntries addObject:post];
                          isLoading = NO;
                      }
                      
                      if ([blocksafeSelf.delegate respondsToSelector:@selector(listFinishedLoading:)]) {
                          NSLog(@"respondsToSelector entryListFinishedLoading");
                          [blocksafeSelf.delegate listFinishedLoading:self];
                          isLoading = NO;
                      }
                  }
                  failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                      NSLog(@"Couldn't load posts");
                      // TODO: show HUD with error message
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
