//
//  HKAPI.h
//  hackful
//
//  Created by Ömer Avci on 18.03.12.
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
