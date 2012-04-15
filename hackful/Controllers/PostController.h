//
//  PostController.h
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
