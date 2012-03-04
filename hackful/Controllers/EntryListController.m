//
//  EntryListController.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryListController.h"
#import "LoadingIndicatorView.h"
#import "PlacardButton.h"
#import "HKPostList.h"
#import "HKEntry.h"
#import "HKPost.h"
#import "HKComment.h"
#import "SubmissionTableCell.h"
#import "CommentsController.h"

@interface EntryListController() {
    NSDate *lastUpdated;
}
@end

@implementation EntryListController

@synthesize postList = _postList;

- (id)initWithEntryList:(HKPostList *)postList_ {
    if ((self = [super init])) {
        postList_.delegate = self;
        [self setPostList:postList_];
    }
    
    return self;
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    [super loadView];
    
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
    [self.postList beginLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - EntryListDelegate
- (void)listFinishedLoading:(HKPostList *)entryList {
    entries = [[entryList entries] copy];
    lastUpdated = [NSDate date];
    [pullToRefreshView finishedLoading];
    [tableView reloadData];
}

#pragma mark - PullToRefreshView
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    NSLog(@"pullToRefreshViewShouldRefresh");
    if (![self.postList isLoading]) [self.postList beginLoading];
}

- (NSDate *)pullToRefreshViewLastUpdated:(PullToRefreshView *)view {
    return lastUpdated;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (entries == nil) return 0;
    return [entries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKPost *post = [entries objectAtIndex:indexPath.row];
    SubmissionTableCell *cell = (SubmissionTableCell *) [tableView dequeueReusableCellWithIdentifier:@"submission"];
    if (cell == nil) cell = [[[SubmissionTableCell alloc] initWithReuseIdentifier:@"submission"] autorelease];
    [cell setSubmission:post];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HKPost *post = [entries objectAtIndex:[indexPath row]];
    return [SubmissionTableCell heightForEntry:post withWidth:[[self view] bounds].size.width];
    //else return [CommentTableCell heightForEntry:entry withWidth:[[self view] bounds].size.width showReplies:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView_ didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HKPost *post = [entries objectAtIndex:indexPath.row];
    
    if ([[post.link host] length] == 0) {
        CommentsController *commentsController = [[CommentsController alloc] initWithPost:post];
        [self.navigationController pushViewController:commentsController animated:YES];
    } else {
        UIWebView *webView = [[UIWebView alloc] init];
        UIViewController *webViewController = [[UIViewController alloc] init];
        [webViewController setView:webView];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:post.link];
        [webView loadRequest:request];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

@end
