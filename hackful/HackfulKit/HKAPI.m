//
//  HKAPI.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012. All rights reserved.
// 
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import "HKAPI.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "HKPost.h"
#import "HKComment.h"
#import "HKSession.h"

static NSURL* _baseURL = nil;
static AFHTTPClient* _httpClient = nil;

@interface HKAPI ()
+ (NSURL*)baseURL;
+ (AFHTTPClient*)httpClient;

+ (void)JSONRequestWithMethod:(NSString*)method
                 resourcePath:(NSString*)resourcePath
                       params:(NSDictionary*)params
                     delegate:(id<HKAPIDelegate>)delegate
                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success 
                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

+ (void)authorizedJSONRequestWithMethod:(NSString*)method
                           resourcePath:(NSString*)resourcePath
                                 params:(NSDictionary*)params
                               delegate:(id<HKAPIDelegate>)delegate
                                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success 
                                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;
@end

@implementation HKAPI

+ (NSURL*)baseURL {
    if (_baseURL == nil) {
        _baseURL = [NSURL URLWithString:kHKBaseAPIURL];
    }
    return _baseURL;
}

+ (AFHTTPClient*)httpClient {
    if (_httpClient == nil) {
        _httpClient = [[AFHTTPClient alloc] initWithBaseURL:[self baseURL]];
    }
    return _httpClient;
}

+ (void)authenticateUserWithName:(NSString*)username 
                        password:(NSString*)password 
                        delegate:(id<HKAPIDelegate>)delegate {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"user[email]", 
                            password, @"user[password]", nil];
    
    [self JSONRequestWithMethod:@"POST" 
                   resourcePath:kHKSessionLoginResourcePath 
                         params:params 
                       delegate:delegate 
                        success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                            HKSession *session = [HKSession sessionFromJSON:jsonObject];
                            HKSession.currentSession = session;
                            
                            if ([delegate respondsToSelector:@selector(APICallComplete)]) {
                                [delegate APICallComplete];
                            }
                        }
                        failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                            NSLog(@"Couldn't login user");
                            [SVProgressHUD showErrorWithStatus:@"Coulnd't login!" duration:1.2];
                            
                            if ([delegate respondsToSelector:@selector(APICallFailed:)]) {
                                [delegate APICallFailed:error];
                            }
                        }];
}

+ (void)logoutCurrentSessionWithDelegate:(id<HKAPIDelegate>)delegate {
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            HKSession.currentSession.authenticationToken, @"auth_token", nil];
    
    [self JSONRequestWithMethod:@"DELETE" 
                   resourcePath:kHKSessionLogoutResourcePath 
                         params:params 
                       delegate:delegate 
                        success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                            HKSession.currentSession = nil;
                            
                            if ([delegate respondsToSelector:@selector(APICallComplete)]) {
                                [delegate APICallComplete];
                            }
                        }
                        failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                            NSLog(@"Couldn't logout user");
                            
                            // If we can't logout but we want to, we should be at least drop all last 
                            // session data. Otherwise we could _NEVER_ logout with somehow broken data.
                            HKSession.currentSession = nil;
                            
                            if ([delegate respondsToSelector:@selector(APICallFailed:)]) {
                                [delegate APICallFailed:error];
                            }
                        }];
}

+ (void)createPostWithTitle:(NSString*)title 
                        URL:(NSString*)url 
                       text:(NSString*)text 
                   delegate:(id<HKAPIDelegate>)delegate {
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            HKSession.currentSession.authenticationToken, @"auth_token", 
                            url, @"post[link]", 
                            title, @"post[title]", 
                            text, @"post[text]", nil];
    
    [self authorizedJSONRequestWithMethod:@"POST" 
                             resourcePath:kHKPostCreateResourcePath 
                                   params:params 
                                 delegate:delegate 
                                  success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                                      if ([delegate respondsToSelector:@selector(APICallComplete)]) {
                                          [delegate APICallComplete];
                                      }
                                  }
                                  failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                                      NSLog(@"Couldn't create post with params: %@", params);
                                      NSLog(@"error: %@", error);
                                      [SVProgressHUD showErrorWithStatus:@"Coulnd't create post!" duration:1.2];
                                      
                                      if ([delegate respondsToSelector:@selector(APICallFailed:)]) {
                                          [delegate APICallFailed:error];
                                      }
                                  }];
     
}

+ (void)createCommentWithText:(NSString*)text 
                    forParent:(HKEntry*)parent 
                     delegate:(id<HKAPIDelegate>)delegate {
    
    NSNumber *objectId = [NSNumber numberWithInteger:parent.objectId];
    NSString *commentableType = [parent isKindOfClass:[HKPost class]] ? @"Post" : @"Comment";
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            HKSession.currentSession.authenticationToken, @"auth_token",
                            text, @"comment[text]",
                            objectId, @"comment[commentable_id]",
                            commentableType, @"comment[commentable_type]", nil];
    
    [self authorizedJSONRequestWithMethod:@"POST" 
                             resourcePath:kHKCommentCreateResourcePath 
                                   params:params
                                 delegate:delegate 
                                  success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                                      if ([delegate respondsToSelector:@selector(APICallComplete)]) {
                                          [delegate APICallComplete];
                                      }
                                  }
                                  failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                                      NSLog(@"Couldn't create post with params: %@", params);
                                      NSLog(@"error: %@", error);
                                      [SVProgressHUD showErrorWithStatus:@"Coulnd't create comment!" duration:1.2];
                                      
                                      if ([delegate respondsToSelector:@selector(APICallFailed:)]) {
                                          [delegate APICallFailed:error];
                                      }
                                  }];
    
    NSLog(@"text: %@ commentable_id: %@ commentable_type: %@", text, objectId, commentableType);
}

+ (void)upvoteEntry:(HKEntry*)entry delegate:(id<HKAPIDelegate>)delegate {
    NSString *resourcePath = nil;
    if ([entry isKindOfClass:[HKPost class]]) {
        resourcePath = [NSString stringWithFormat:kHKPostUpvoteResourcePath, entry.objectId];
    } else if ([entry isKindOfClass:[HKComment class]]) {
        resourcePath = [NSString stringWithFormat:kHKCommentUpvoteResourcePath, entry.objectId];
    }
    
    if (resourcePath != nil) {
        NSLog(@"session.userId %d entry.userId %d", HKSession.currentSession.user.objectId, entry.user.objectId);
        if (HKSession.currentSession.user.objectId != entry.user.objectId) {
            NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    HKSession.currentSession.authenticationToken, @"auth_token", nil];
            [self authorizedJSONRequestWithMethod:@"PUT"
                                     resourcePath:resourcePath
                                           params:params
                                         delegate:delegate 
                                          success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                                              NSLog(@"APICallUpvoteEntryWasSuccessful");
                                              entry.voted = YES;
                                              if ([delegate respondsToSelector:@selector(APICallUpvoteEntryWasSuccessful)]) {
                                                  [delegate APICallUpvoteEntryWasSuccessful];
                                              }
                                          }
                                          failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                                              NSLog(@"Couldn't upvote entry with params: %@", params);
                                              NSLog(@"error: %@", error);
                                              [SVProgressHUD showErrorWithStatus:@"Coulnd't upvote!" duration:1.2];
                                              
                                              if ([delegate respondsToSelector:@selector(APICallUpvoteEntryFailed:)]) {
                                                  [delegate APICallUpvoteEntryFailed:error];
                                              }
                                          }];
        }
    }
}

+ (void)loadEntriesWithResourcePath:(NSString*)resourcePath 
                               type:(HKEntryType)entryType
                           delegate:(id<HKAPIDelegate>)delegate {
    
    NSDictionary* params = nil;
    if (HKSession.currentSession.authenticationToken != nil) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                  HKSession.currentSession.authenticationToken, @"auth_token", nil];
    }
    
    [self JSONRequestWithMethod:@"GET" 
                   resourcePath:resourcePath 
                         params:params
                       delegate:delegate 
                        success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                            NSMutableArray *entries = [[NSMutableArray alloc] init];
                            HKEntry *tempEntry = nil;
                            for (id jsonChild in jsonObject) {
                                if (entryType == kHKEntryTypePost) {
                                    tempEntry = [HKPost postFromJSON:jsonChild];
                                } else if (entryType == kHKEntryTypeComment) {
                                    tempEntry = [HKComment commentFromJSON:jsonChild];
                                }
                                
                                [entries addObject:tempEntry];
                            }
                            
                            if ([delegate respondsToSelector:@selector(APICallCompleteWithList:)]) {
                                [delegate APICallCompleteWithList:[entries copy]];
                            }
                        }
                        failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                            NSLog(@"Couldn't load entries");
                            NSLog(@"error %@", error);
                            [SVProgressHUD showErrorWithStatus:@"Loading error!" duration:1.2];
                            
                            if ([delegate respondsToSelector:@selector(APICallFailed:)]) {
                                [delegate APICallFailed:error];
                            }                            
                        }];
}

#pragma mark - Helpers

+ (void)JSONRequestWithMethod:(NSString*)method
                 resourcePath:(NSString*)resourcePath
                       params:(NSDictionary*)params
                     delegate:(id<HKAPIDelegate>)delegate
                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success 
                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:method path:resourcePath parameters:params];
    AFJSONRequestOperation *operation;
    operation =  [AFJSONRequestOperation 
                  JSONRequestOperationWithRequest:request
                  success:success
                  failure:failure];
    [operation start];
}

+ (void)authorizedJSONRequestWithMethod:(NSString*)method
                           resourcePath:(NSString*)resourcePath
                                 params:(NSDictionary*)params
                               delegate:(id<HKAPIDelegate>)delegate
                                success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success 
                                failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {
    
    if ([HKSession isAnonymous]) {
        if ([delegate respondsToSelector:@selector(APICallNotLoggedInError)]) {
            [delegate APICallNotLoggedInError];
        }
    } else {
        [self JSONRequestWithMethod:method resourcePath:resourcePath params:params delegate:delegate success:success failure:failure];
    }
}

@end
