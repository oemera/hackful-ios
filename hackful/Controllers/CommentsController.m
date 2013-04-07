//
//  CommentsController.m
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

#import "CommentsController.h"
#import "AFNetworking.h"
#import "UIImage+Color.h"
#import "HKCommentList.h"
#import "HKPost.h"
#import "HKComment.h"
#import "HKEntry.h"
#import "HKSession.h"
#import "CommentTableCell.h"
#import "SideSwipeTableViewCell.h"
#import "HackfulLoginController.h"
#import "NavigationController.h"
#import "CommentComposeController.h"
#import "SVWebViewController.h"

#define BUTTON_LEFT_MARGIN 35.5
#define BUTTON_SPACING 32.0

@interface CommentsController ()
- (void)composePressed;
+ (int)countCommentRecursively:(NSArray*)comments;
@end

@implementation CommentsController

@synthesize commentList = _commentList;
@synthesize post = _post;

- (id)initWithPost:(HKPost *)post_ {
    if ((self = [super init])) {
        _post = post_;
        comments = [CommentsController flattenTree:_post.comments];;
        HKCommentList *commentList = [[HKCommentList alloc] initWithPost:post_];
        commentList.delegate = self;
        [self setCommentList:commentList];
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    
    composeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"compose-icon"]
                                                   style:UIBarButtonItemStylePlain
                                                  target:self action:@selector(composePressed)];
    [composeItem setBackgroundImage:[UIImage imageNamed:@"nav-button-transparent"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [composeItem setBackgroundImage:[UIImage imageNamed:@"nav-button-transparent"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [pullToRefreshView setState:PullToRefreshViewStateLoading];
    tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [[self view] addSubview:tableView];
    
    pullToRefreshView = [[PullToRefreshView alloc] initWithScrollView:tableView];
    [pullToRefreshView setState:PullToRefreshViewStateLoading];
    [tableView addSubview:pullToRefreshView];
    [pullToRefreshView setDelegate:self];
    
    [self setupHeader];
    [self setupSideSwipeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setRightBarButtonItem:composeItem];
    [self.commentList beginLoading];
    
    // Setup the title and image for each button within the side swipe view
    buttonData = [NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Reply", @"title", @"reply.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Upvote", @"title", @"up_arrow.png", @"image", nil], nil];
                  //[NSDictionary dictionaryWithObjectsAndKeys:@"SendTo", @"title", @"person.png", @"image", nil], nil];
    
    buttons = [[NSMutableArray alloc] initWithCapacity:buttonData.count];
    
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
    [self setupSideSwipeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if([self.navigationController.viewControllers objectAtIndex:0] != self)
    {
        UIImage *listIcon = [UIImage imageNamed:@"list-icon"];
        UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, listIcon.size.width + 23, 26)];
        [backButton setBackgroundImage:[[UIImage imageNamed:@"nav-back"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateNormal];
        [backButton setBackgroundImage:[[UIImage imageNamed:@"nav-back-highlighted"] stretchableImageWithLeftCapWidth:13 topCapHeight:0] forState:UIControlStateHighlighted];
        [backButton setImage:listIcon forState:UIControlStateNormal];
        [backButton setShowsTouchWhenHighlighted:YES];
        [backButton addTarget:self action:@selector(popViewControllerWithAnimation) forControlEvents:UIControlEventTouchUpInside];
        [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 8)];
        
        UIBarButtonItem *barBackItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = barBackItem;
    }
}

#pragma mark - Actions

- (void)showLoginController {
    HackfulLoginController *loginController = [[HackfulLoginController alloc] init];
    [loginController setDelegate:self];
    NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:loginController];
    [self presentModalViewController:navigation animated:YES];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([HKSession isAnonymous]) {
        [self showLoginController];
        return NO;
	}
    
    return YES;
}

- (void)composePressed {
    if (![HKSession isAnonymous]) {
        HKSession *session = [HKSession currentSession];
        NSLog(@"session: %@ %@", session.user.name, session.authenticationToken);
        
        NavigationController *navigation = [[NavigationController alloc] init];
        ComposeController *compose = [[CommentComposeController alloc] initWithEntry:self.post];
        compose.delegate = self;
        
        [navigation setViewControllers:[NSArray arrayWithObject:compose]];
        [self presentModalViewController:navigation animated:YES];
    } else {
        [self showLoginController];
    }
}

- (void)popViewControllerWithAnimation {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableHeaderViewDelegate

- (void)tableHeaderView:(TableHeaderView *)header selectedURL:(NSURL *)url {
    NSLog(@"Header touched commentscontroller");
    
    SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:webViewController animated:YES];
}

#pragma mark - ComposeControllerDelegate

- (void)composeControllerDidSubmit:(ComposeController *)controller {
    [pullToRefreshView setState:PullToRefreshViewStateLoading];
    [self.commentList beginLoading];
}

#pragma mark - LoginControllerDelegate

- (void)loginControllerDidCancel:(LoginController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loginControllerDidLogin:(LoginController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - HKListDelegate

- (void)listFinishedLoading:(HKList *)list {
    self.post.comments = [list entries];
    comments = [CommentsController flattenTree:[list entries]];
    lastUpdated = [NSDate date];
    [pullToRefreshView finishedLoading];
    [tableView reloadData];
}

- (void)listFinishedLoading:(HKList *)list withError:(NSError*)error {
    NSLog(@"listFinishedLoading withError");
    [pullToRefreshView finishedLoading];
    [pullToRefreshView setState:PullToRefreshViewStateNormal];
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
    return [CommentTableCell heightForEntry:comment withWidth:[[self view] bounds].size.width showReplies:YES indentationLevel:comment.depth];
}

#pragma mark - Header

- (void)setupHeader {
    // Only show it if the source is at least partially loaded.
    if (self.post.user == nil) return;
    
    tableHeaderContainer = nil;
    tableHeaderAndShadowContainer = nil;
    tableHeaderView = nil;
    
    tableHeaderView = [[TableHeaderView alloc] initWithPost:self.post andWidth:self.view.bounds.size.width];
    tableHeaderView.delegate = self;
    [tableHeaderView setClipsToBounds:YES];
    [tableHeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    
    tableHeaderContainer = [[UIView alloc] initWithFrame:[tableHeaderView bounds]];
    [tableHeaderContainer addSubview:tableHeaderView];
    [tableHeaderContainer setClipsToBounds:YES];
    [tableHeaderContainer setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin];
    [[tableHeaderContainer layer] setContentsGravity:kCAGravityTopLeft];
    
    UIView *shadow = [[UIView alloc] initWithFrame:CGRectMake(-50.0f, [tableHeaderView bounds].size.height, [[self view] bounds].size.width + 100.0f, 1.0f)];
    CALayer *layer = [shadow layer];
    [layer setShadowOffset:CGSizeMake(0, -2.0f)];
    [layer setShadowRadius:5.0f];
    [layer setShadowColor:[[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:1.0f];
    [shadow setBackgroundColor:[UIColor grayColor]];
    [shadow setClipsToBounds:NO];
    [shadow setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    tableHeaderAndShadowContainer = [[UIView alloc] initWithFrame:[tableHeaderView bounds]];
    [tableHeaderAndShadowContainer setBackgroundColor:[UIColor clearColor]];
    [tableHeaderAndShadowContainer addSubview:tableHeaderContainer];
    [tableHeaderAndShadowContainer addSubview:shadow];
    [tableHeaderAndShadowContainer setClipsToBounds:NO];
    
    //UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0,70,320,44)];
    //[test setBackgroundColor:[UIColor redColor]];
    [tableView setTableHeaderView:tableHeaderAndShadowContainer];
    
    suggestedHeaderHeight = [tableHeaderAndShadowContainer bounds].size.height;
    maximumHeaderHeight = [tableView bounds].size.height - 64.0f;
    
    // necessary since the core text view can steal this
    [tableView setScrollsToTop:YES];
}

#pragma mark - HKAPIDelegate

- (void)APICallComplete {
    
}

- (void)APICallFailed:(NSError*)error {
    
}

#pragma mark - UITableViewDelegate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#pragma mark Button touch up inside action

- (void)touchUpInsideAction:(UIButton*)button {
    NSIndexPath* indexPath = [tableView indexPathForCell:sideSwipeCell];
    NSUInteger index = [buttons indexOfObject:button];
    NSDictionary* buttonInfo = [buttonData objectAtIndex:index];
    HKComment *comment = [comments objectAtIndex:indexPath.row];
    NSString *buttonTitle = [buttonInfo objectForKey:@"title"];
    
    if ([buttonTitle isEqualToString:@"Reply"]) {
        if (![HKSession isAnonymous]) {
            HKSession *session = [HKSession currentSession];
            NSLog(@"session: %@ %@", session.user.name, session.authenticationToken);
            
            NavigationController *navigation = [[NavigationController alloc] init];
            ComposeController *compose = [[CommentComposeController alloc] initWithEntry:comment];
            compose.delegate = self;
            
            [navigation setViewControllers:[NSArray arrayWithObject:compose]];
            [self presentModalViewController:navigation animated:YES];
        } else {
            [self showLoginController];
        }
    } else if ([buttonTitle isEqualToString:@"Upvote"]) {
        if (![HKSession isAnonymous]) {
            [HKAPI upvoteEntry:comment delegate:self];
        } else {
            [self showLoginController];
            // TODO: perform upvote after login
        }
    } else if ([buttonTitle isEqualToString:@"SendTo"]) {
        // TODO: Send to implementation as action sheet
    }
    
    [self removeSideSwipeView:YES];
}

#pragma mark - Swipe implementation

- (void) setupSideSwipeView {
    
    // TODO: we need a bigger tap field for buttons. At the moment there is 
    //       fair chance that you miss the button and it is really frustrating
    
    // Add the background pattern
    self.sideSwipeView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"dotted-pattern.png"]];
    
    // Overlay a shadow image that adds a subtle darker drop shadow around the edges
    UIImage* shadow = [[UIImage imageNamed:@"inner-shadow.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView* shadowImageView = [[UIImageView alloc] initWithFrame:sideSwipeView.frame];
    shadowImageView.alpha = 0.6;
    shadowImageView.image = shadow;
    shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.sideSwipeView addSubview:shadowImageView];
    
    // find out how much space the buttons need
    CGFloat neededSpace = 0.0;
    if (sideSwipeView.frame.size.width > 0) {
        for (NSDictionary* buttonInfo in buttonData) {
            UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
            neededSpace = neededSpace + buttonImage.size.width + BUTTON_SPACING;
        }
    }
    // we add BUTTON_SPACING cause we added to the last button but it is free
    CGFloat spaceLeft = sideSwipeView.frame.size.width - neededSpace + BUTTON_SPACING;
    
    // Iterate through the button data and create a button for each entry
    CGFloat leftEdge = spaceLeft/2;
    for (NSDictionary* buttonInfo in buttonData) {
        // Create the button
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // Make sure the button ends up in the right place when the cell is resized
        button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        
        // Get the button image
        UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
        
        // Set the button's frame
        button.frame = CGRectMake(leftEdge, sideSwipeView.center.y - buttonImage.size.height/2.0, buttonImage.size.width, buttonImage.size.height);
        
        // Add the image as the button's background image
        // [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        UIImage* grayImage = [UIImage imageFilledWith:[UIColor colorWithWhite:0.9 alpha:1.0] using:buttonImage];
        [button setImage:grayImage forState:UIControlStateNormal];
        
        // Add a touch up inside action
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Keep track of the buttons so we know the proper text to display in the touch up inside action
        [buttons addObject:button];
        
        // Add the button to the side swipe view
        [self.sideSwipeView addSubview:button];
        
        // Move the left edge in prepartion for the next button
        leftEdge = leftEdge + buttonImage.size.width + BUTTON_SPACING;
    }
}

- (void)swipeWillAddCellForRowAtIndexPath:(NSIndexPath*)indexPath {
    HKComment *comment = [comments objectAtIndex:indexPath.row];
    NSLog(@"logged in? %@", (HKSession.currentSession.user.name));
    NSLog(@"voted? %@", (comment.voted ? @"YES" : @"NO"));
    
    NSDictionary* buttonInfo = [buttonData objectAtIndex:1];
    UIButton* button         = [buttons objectAtIndex:1];
    
    if (comment.voted) [self deactivateButton:button withButtonInfo:buttonInfo];
    else               [self activateButton:button withButtonInfo:buttonInfo];
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
