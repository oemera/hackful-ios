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
#import "SideSwipeTableViewController.h"
#import "LoginController.h"
#import "ComposeController.h"
#import "HKAPI.h"

@class HKPost;
@class TableHeaderView;

@interface CommentsController : SideSwipeTableViewController <UITableViewDelegate, 
UITableViewDataSource, PullToRefreshViewDelegate, HKListDelegate, LoginControllerDelegate, 
ComposeControllerDelegate, HKAPIDelegate> {
    
    UILabel *emptyLabel;
    PullToRefreshView *pullToRefreshView;
    NSArray *comments;
    NSDate *lastUpdated;
    UIBarButtonItem *composeItem;
    
    UIView *detailsHeaderContainer;
    TableHeaderView *detailsHeaderView;
    UIView *tableHeaderContainer;
    CGFloat suggestedHeaderHeight;
    CGFloat maximumHeaderHeight;
    
    NSArray* buttonData;
    NSMutableArray* buttons;
}

@property (nonatomic, strong) HKCommentList *commentList;
@property (nonatomic, strong, readonly) HKPost *post;

- (id)initWithPost:(HKPost *)post_;

@end