//
//  CommentList.h
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class HKPost;
@protocol CommentListDelegate;

@interface CommentList : NSObject <RKRequestDelegate, RKObjectLoaderDelegate> {
    BOOL isLoading;
    id<CommentListDelegate> delegate;
    NSURL *apiUrl;
    HKPost *post;
    NSString *commentPath;
}

@property (nonatomic, assign) id<CommentListDelegate> delegate;
@property (readonly) NSArray *entries;

- (id)initWithPost:(HKPost *)post_;
- (void)beginLoading;
- (BOOL)isLoading;

@end

@protocol CommentListDelegate <NSObject>

@optional
- (void)listFinishedLoading:(CommentList *)commentList;

@end
