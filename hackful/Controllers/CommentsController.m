//
//  CommentsController.m
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentsController.h"
#import "HKCommentList.h"
#import "HKPost.h"
#import "HKComment.h"
#import "CommentTableCell.h"
#import "LoginController.h"
#import "TableHeaderView.h"

@interface CommentsController ()
+ (int)countCommentRecursively:(NSArray*)comments;
@end

@implementation CommentsController

@synthesize commentList = _commentList;
@synthesize post = _post;

- (id)initWithPost:(HKPost *)post_ {
    if ((self = [super init])) {
        _post = post_;
        HKCommentList *commentList = [[HKCommentList alloc] initWithPost:post_];
        commentList.delegate = self;
        [self setCommentList:commentList];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composePressed)];
    
    [pullToRefreshView setState:PullToRefreshViewStateLoading];
    tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [[self view] addSubview:tableView];
    
    emptyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [emptyLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [emptyLabel setTextColor:[UIColor grayColor]];
    [emptyLabel setBackgroundColor:[UIColor clearColor]];
    [emptyLabel setText:@"No Items"];
    [emptyLabel setTextAlignment:UITextAlignmentCenter];
    
    pullToRefreshView = [[PullToRefreshView alloc] initWithScrollView:tableView];
    [tableView addSubview:pullToRefreshView];
    [pullToRefreshView setDelegate:self];
    
    //[[self view] bringSubviewToFront:statusView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setRightBarButtonItem:composeItem];
    [self.commentList beginLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Actions

- (void)composePressed {
    NSLog(@"composePressed");
}

#pragma mark - HKListDelegate

- (void)listFinishedLoading:(HKList *)list {
    comments = [CommentsController flattenTree:[list entries]];
    lastUpdated = [NSDate date];
    [pullToRefreshView finishedLoading];
    [tableView reloadData];
}

#pragma mark - PullToRefreshView

- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    NSLog(@"pullToRefreshViewShouldRefresh");
    if (![self.commentList isLoading]) [self.commentList beginLoading];
}

- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return lastUpdated;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (comments == nil) return 0;
    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKComment *comment = [comments objectAtIndex:indexPath.row];
    CommentTableCell *cell = (CommentTableCell *) [tableView dequeueReusableCellWithIdentifier:@"comment"];
    if (cell == nil) cell = [[CommentTableCell alloc] initWithReuseIdentifier:@"comment"];
    [cell setComment:comment];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKComment *comment = [comments objectAtIndex:[indexPath row]];
    return [CommentTableCell heightForEntry:comment 
                                  withWidth:[[self view] bounds].size.width 
                                showReplies:NO];
}

#pragma mark - Header

- (void)setupHeader {
    // Only show it if the source is at least partially loaded.
    if (self.post.user == nil) return;
    
    detailsHeaderContainer = nil;
    tableHeaderContainer = nil;
    detailsHeaderView = nil;
    
    detailsHeaderView = [[TableHeaderView alloc] initWithPost:self.post];
    [detailsHeaderView setClipsToBounds:YES];
    [detailsHeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    
    detailsHeaderContainer = [[UIView alloc] initWithFrame:[detailsHeaderView bounds]];
    [detailsHeaderContainer addSubview:detailsHeaderView];
    [detailsHeaderContainer setClipsToBounds:YES];
    [detailsHeaderContainer setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [[detailsHeaderContainer layer] setContentsGravity:kCAGravityTopLeft];
    
    UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(-50.0f, [detailsHeaderView bounds].size.height, [[self view] bounds].size.width + 100.0f, 1.0f)];
    CALayer *layer = [shadow layer];
    [layer setShadowOffset:CGSizeMake(0, -2.0f)];
    [layer setShadowRadius:5.0f];
    [layer setShadowColor:[[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:1.0f];
    [shadow setBackgroundColor:[UIColor grayColor]];
    [shadow setClipsToBounds:NO];
    [shadow setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    tableHeaderContainer = [[UIView alloc] initWithFrame:[detailsHeaderView bounds]];
    [tableHeaderContainer setBackgroundColor:[UIColor clearColor]];
    [tableHeaderContainer addSubview:detailsHeaderContainer];
    [tableHeaderContainer addSubview:shadow];
    [tableHeaderContainer setClipsToBounds:NO];
    [tableView setTableHeaderView:tableHeaderContainer];
    
    suggestedHeaderHeight = [detailsHeaderView bounds].size.height;
    maximumHeaderHeight = [tableView bounds].size.height - 64.0f;
    
    // necessary since the core text view can steal this
    [tableView setScrollsToTop:YES];
}


#pragma mark - UITableViewDelegate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#pragma mark - Comment Utils

+ (NSArray *)flattenTree:(NSArray*)comments {
    NSMutableArray *flatArray = [[NSMutableArray alloc] init];
    for (HKComment *child in comments) {
        [flatArray addObject:child];
        [flatArray addObjectsFromArray:[self flattenTree:child.comments]];
    }
    return [flatArray copy];
}

+ (int)countCommentRecursively:(NSArray*)comments {
    //NSLog(@"comment array length: %d ", [comments count]);
    int recursiveCount = 0;
    for (HKComment *child in comments) {
        NSLog(@"text: %@ depth:%d", child.text, child.depth);
        recursiveCount++;
        recursiveCount += [self countCommentRecursively:child.comments];
    }
    return recursiveCount;
}

@end
