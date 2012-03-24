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
#import "SideSwipeTableViewController.h"
#import "SideSwipeTableViewCell.h"
#import "HackfulLoginController.h"
#import "ComposeController.h"
#import "HKAPI.h"

@class LoadMoreButton;
@class HKPost;

@interface PostController : SideSwipeTableViewController <UITableViewDelegate, 
UITableViewDataSource, PullToRefreshViewDelegate, HKListDelegate, SideSwipeTableViewCellDelegate, 
LoginControllerDelegate, ComposeControllerDelegate, HKAPIDelegate, UIActionSheetDelegate> {
    //UILabel *emptyLabel;
    LoadMoreButton *moreButton;
    PullToRefreshView *pullToRefreshView;
    NSArray *entries;
    NSDate *lastUpdated;
    UIBarButtonItem *composeItem;
    NSArray* buttonData;
    NSMutableArray* buttons;
    HKPost *currentPost;
}

@property (nonatomic, strong) HKPostList *postList;

- (id)initWithEntryList:(HKPostList *)postList_;
@end
