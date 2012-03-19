//
//  CommentsController.m
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKAPI.h"
#import "CommentsController.h"
#import "AFNetworking.h"
#import "UIImage+Color.h"
#import "HKCommentList.h"
#import "HKPost.h"
#import "HKComment.h"
#import "HKSession.h"
#import "CommentTableCell.h"
#import "TableHeaderView.h"
#import "SideSwipeTableViewCell.h"
#import "HackfulLoginController.h"
#import "NavigationController.h"
#import "CommentComposeController.h"

#define BUTTON_LEFT_MARGIN 35.5
#define BUTTON_SPACING 32.0

@interface CommentsController ()
- (void)composePressed;
+ (int)countCommentRecursively:(NSArray*)comments;
+ (void)upvoteEntry:(HKEntry*)entry;
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
    
    composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composePressed)];
    
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
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Upvote", @"title", @"up_arrow.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"SendTo", @"title", @"person.png", @"image", nil], nil];
    
    buttons = [[NSMutableArray alloc] initWithCapacity:buttonData.count];
    
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
    [self setupSideSwipeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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
    
    detailsHeaderContainer = nil;
    tableHeaderContainer = nil;
    detailsHeaderView = nil;
    
    detailsHeaderView = [[TableHeaderView alloc] initWithPost:self.post andWidth:self.view.bounds.size.width];
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
    
    //UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0,70,320,44)];
    //[test setBackgroundColor:[UIColor redColor]];
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

#pragma mark Button touch up inside action

- (void) touchUpInsideAction:(UIButton*)button {
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
            [CommentsController upvoteEntry:comment withDelegate:self];
        } else {
            [self showLoginController];
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

+ (void)upvoteEntry:(HKEntry*)entry withDelegate:(id)delegate {
    NSString *resourcePath = nil;
    if ([entry isKindOfClass:[HKPost class]]) {
        resourcePath = [NSString stringWithFormat:kHKPostUpvoteResourcePath, entry.objectId];
    } else if ([entry isKindOfClass:[HKComment class]]) {
        resourcePath = [NSString stringWithFormat:kHKCommentUpvoteResourcePath, entry.objectId];
    }
    
    if (resourcePath != nil) {
        if (HKSession.currentSession.user.objectId != entry.user.objectId) {
            NSURL *url = [NSURL URLWithString:kHKBaseAPIURL];
            AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
            NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                    HKSession.currentSession.authenticationToken, @"auth_token", nil];
            NSMutableURLRequest *request = [httpClient requestWithMethod:@"PUT" 
                                                                    path:resourcePath
                                                              parameters:params];
            
            AFJSONRequestOperation *operation;
            operation =  [AFJSONRequestOperation 
                          JSONRequestOperationWithRequest:request
                          success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                              //[delegate sendComplete];
                              NSLog(@"sendComplete");
                          }
                          failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                              // TODO: show HUD with error message
                              NSLog(@"Couldn't create post with params: %@", params);
                              NSLog(@"error: %@", error);
                              
                              //[delegate sendFailed];
                          }];
            [operation start];
        } else {
            NSLog(@"you can't upvote your own entry");
        }
    }
}

@end
