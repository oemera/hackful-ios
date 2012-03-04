//
//  CommentsController.m
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentsController.h"
#import "CommentList.h"
#import "CommentTableCell.h"

@implementation CommentsController

@synthesize commentList = _commentList;

- (id)initWithPost:(HKPost *)post_ {
    if ((self = [super init])) {
        CommentList *commentList = [[CommentList alloc] initWithPost:post_];
        commentList.delegate = self;
        [self setCommentList:commentList];
    }
    
    return self;
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
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

- (void)composePressed {
    NSLog(@"composePressed");
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

#pragma mark - EntryListDelegate
- (void)listFinishedLoading:(CommentList *)commentList_ {
    comments = [[commentList_ entries] copy];
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

#pragma mark - UITableViewDelegate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


@end
