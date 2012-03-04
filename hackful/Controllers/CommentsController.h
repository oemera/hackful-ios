//
//  CommentsController.h
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"
#import "HKCommentList.h"
#import "HKListDelegate.h"

@class HKPost;
@class LoadMoreButton;

@interface CommentsController : UIViewController <UITableViewDelegate, 
UITableViewDataSource, PullToRefreshViewDelegate, HKListDelegate> {
    UITableView *tableView;
    UILabel *emptyLabel;
    LoadMoreButton *moreButton;
    PullToRefreshView *pullToRefreshView;
    NSArray *comments;
    NSDate *lastUpdated;
    UIBarButtonItem *composeItem;
}

@property (nonatomic, strong) HKCommentList *commentList;

- (id)initWithPost:(HKPost *)post_;

@end