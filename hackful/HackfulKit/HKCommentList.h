//
//  CommentList.h
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKList.h"
#import "HKListDelegate.h"
#import "HKAPI.h"

@class HKPost;

@interface HKCommentList : HKList <HKAPIDelegate> {
    BOOL isLoading;
    id<HKListDelegate> delegate;
    HKPost *post;
    NSString *resourcePath;
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
