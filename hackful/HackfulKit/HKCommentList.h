//
//  CommentList.h
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "HKList.h"
#import "HKListDelegate.h"

@class HKPost;

@interface HKCommentList : HKList <RKRequestDelegate, RKObjectLoaderDelegate> {
    BOOL isLoading;
    id<HKListDelegate> delegate;
    NSURL *apiUrl;
    HKPost *post;
    NSString *commentPath;
}

@property (nonatomic, assign) id<HKListDelegate> delegate;

- (id)initWithPost:(HKPost *)post_;
- (void)beginLoading;
- (BOOL)isLoading;

@end

@protocol CommentListDelegate <NSObject>

@optional
- (void)listFinishedLoading:(HKCommentList *)commentList;

@end
