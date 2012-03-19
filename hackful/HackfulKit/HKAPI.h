//
//  HKAPI2.h
//  hackful
//
//  Created by Ömer Avci on 19.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifdef DEBUG
#define kHKBaseAPIURL                   @"http://192.168.1.110:3000"
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
- (void)APICallComplete;
- (void)APICallCompleteWithList:(NSArray*)entries;
- (void)APICallFailed:(NSError*)error;
- (void)APICallNotLoggedInError;
@end
