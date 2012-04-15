//
//  HKAPI.h
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

#ifdef DEBUG
//#define kHKBaseAPIURL                   @"http://192.168.1.110:3000"
#define kHKBaseAPIURL                   @"http://0.0.0.0:3000"
#else
#define kHKBaseAPIURL                   @"http://hackful.com"
#endif

#define kHKSignupPath                   @"/api/v1/signup"

#define kHKSessionLoginResourcePath     @"/api/v1/sessions/login"
#define kHKSessionLogoutResourcePath    @"/api/v1/sessions/logout"

#define kHKFrontpageResourcePath        @"/api/v1/posts/frontpage"
#define kHKNewResourcePath              @"/api/v1/posts/new"
#define kHKAskResourcePath              @"/api/v1/posts/ask"

#define kHKUserResourcePath             @"/api/v1/user/%d"

#define kHKPostCreateResourcePath       @"/api/v1/post"
#define kHKPostWithIDResourcePath       @"/api/v1/post/%d"
#define kHKPostUpvoteResourcePath       @"/api/v1/post/%d/upvote"

#define kHKCommentCreateResourcePath    @"/api/v1/comment"
#define kHKCommentUpvoteResourcePath    @"/api/v1/comment/%d/upvote"
#define kHKCommentsForPostResourcePath  @"/api/v1/comments/post/%d"

typedef enum {
    kHKEntryTypePost,
    kHKEntryTypeComment
} HKEntryType;

#import <Foundation/Foundation.h>
#import "HKEntry.h"

@protocol HKAPIDelegate;

@interface HKAPI : NSObject

+ (void)authenticateUserWithName:(NSString*)username 
                        password:(NSString*)password 
                        delegate:(id<HKAPIDelegate>)delegate;

+ (void)logoutCurrentSessionWithDelegate:(id<HKAPIDelegate>)delegate;

+ (void)upvoteEntry:(HKEntry*)entry 
           delegate:(id<HKAPIDelegate>)delegate;

+ (void)createCommentWithText:(NSString*)text 
                    forParent:(HKEntry*)parent 
                  delegate:(id<HKAPIDelegate>)delegate;

+ (void)createPostWithTitle:(NSString*)title 
                        URL:(NSString*)url 
                       text:(NSString*)text 
                   delegate:(id<HKAPIDelegate>)delegate;

+ (void)loadEntriesWithResourcePath:(NSString*)resourcePath 
                               type:(HKEntryType)entryType
                           delegate:(id<HKAPIDelegate>)delegate;

@end

@protocol HKAPIDelegate <NSObject>

@optional
- (void)APICallUpvoteEntryWasSuccessful;
- (void)APICallComplete;
- (void)APICallCompleteWithList:(NSArray*)entries;
- (void)APICallUpvoteEntryFailed:(NSError*)error;
- (void)APICallFailed:(NSError*)error;
- (void)APICallNotLoggedInError;
@end
