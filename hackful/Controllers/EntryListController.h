//
//  EntryListController.h
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"
#import "HKPostList.h"
#import "HKListDelegate.h"

@class LoadingIndicatorView;
@class PlacardButton;
@class LoadMoreButton;

@interface EntryListController : UIViewController <UITableViewDelegate, 
UITableViewDataSource, PullToRefreshViewDelegate, HKListDelegate> {
    PlacardButton *retryButton;
    LoadingIndicatorView *indicator;
    UITableView *tableView;
    UILabel *emptyLabel;
    LoadMoreButton *moreButton;
    PullToRefreshView *pullToRefreshView;
    NSArray *entries;
}

@property (nonatomic, strong) HKPostList *postList;

- (id)initWithEntryList:(HKPostList *)postList_;

@end
