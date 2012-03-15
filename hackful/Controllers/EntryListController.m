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
#import "SideSwipeTableViewCell.h"

#define BUTTON_LEFT_MARGIN 35.5
#define BUTTON_SPACING 32.0

@interface EntryListController()
- (void) setupSideSwipeView;
- (UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage;
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
    
    tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [[self view] addSubview:tableView];
        
    /*emptyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [emptyLabel setFont:[UIFont systemFontOfSize:17.0f]];
    [emptyLabel setTextColor:[UIColor grayColor]];
    [emptyLabel setBackgroundColor:[UIColor clearColor]];
    [emptyLabel setText:@"No Items"];
    [emptyLabel setTextAlignment:UITextAlignmentCenter];*/
        
    pullToRefreshView = [[PullToRefreshView alloc] initWithScrollView:tableView];
    [pullToRefreshView setState:PullToRefreshViewStateLoading];
    [pullToRefreshView setDelegate:self];
    
    [tableView addSubview:pullToRefreshView];
    
    [self setupSideSwipeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.postList beginLoading];
    
    // Setup the title and image for each button within the side swipe view
    buttonData = [NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Reply", @"title", @"reply.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Retweet", @"title", @"retweet-outline-button-item.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Upvote", @"title", @"up_arrow.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"ReadLater", @"title", @"58-bookmark.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"SendTo", @"title", @"action.png", @"image", nil], nil];
    
    buttons = [[NSMutableArray alloc] initWithCapacity:buttonData.count];
    
    self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
    [self setupSideSwipeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - EntryListDelegate
- (void)listFinishedLoading:(HKPostList *)entryList {
    NSLog(@"listFinishedLoading");
    entries = [[entryList entries] copy];
    lastUpdated = [NSDate date];
    [pullToRefreshView finishedLoading];
    [tableView reloadData];
}

#pragma mark - PullToRefreshView
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view {
    NSLog(@"pullToRefreshViewShouldRefresh");
    NSLog(@"is already loading? %@", [self.postList isLoading]);
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
    /*SubmissionTableCell *cell = (SubmissionTableCell *) [tableView dequeueReusableCellWithIdentifier:@"submission"];
    if (cell == nil) cell = [[[SubmissionTableCell alloc] initWithReuseIdentifier:@"submission"] autorelease];
    [cell setSubmission:post];*/
    
    static NSString *CellIdentifier = @"SwipeCell";
    SideSwipeTableViewCell *cell = (SideSwipeTableViewCell*)[tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SideSwipeTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    
    cell.post = post;
    cell.supressDeleteButton = ![self gestureRecognizersSupported];
    
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
    
    //if ([post.link length] == 0) {
    CommentsController *commentsController = [[CommentsController alloc] initWithPost:post];
    [self.navigationController pushViewController:commentsController animated:YES];
    /*} else {
        UIWebView *webView = [[UIWebView alloc] init];
        UIViewController *webViewController = [[UIViewController alloc] init];
        [webViewController setView:webView];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:post.link]];
        [webView loadRequest:request];
        [self.navigationController pushViewController:webViewController animated:YES];
    }*/
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

#pragma mark Button touch up inside action
- (void) touchUpInsideAction:(UIButton*)button {
    // TODO: do the same with HUD
    
    /*NSIndexPath* indexPath = [tableView indexPathForCell:sideSwipeCell];
    
    NSUInteger index = [buttons indexOfObject:button];
    NSDictionary* buttonInfo = [buttonData objectAtIndex:index];
    [[[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"%@ on cell %d", [buttonInfo objectForKey:@"title"], indexPath.row]
                                 message:nil
                                delegate:nil
                       cancelButtonTitle:nil
                       otherButtonTitles:@"OK", nil] autorelease] show];*/
    
    [self removeSideSwipeView:YES];
}

#pragma mark Generate images with given fill color
// Convert the image's fill color to the passed in color
-(UIImage*) imageFilledWith:(UIColor*)color using:(UIImage*)startImage {
    // Create the proper sized rect
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));

    // Create a new bitmap context
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);

    // Use the passed in image as a clipping mask
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    // Set the fill color
    CGContextSetFillColorWithColor(context, color.CGColor);
    // Fill with color
    CGContextFillRect(context, imageRect);

    // Generate a new image
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];

    // Cleanup
    CGContextRelease(context);
    CGImageRelease(newCGImage);

    return newImage;
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
        UIImage* grayImage = [self imageFilledWith:[UIColor colorWithWhite:0.9 alpha:1.0] using:buttonImage];
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

@end
