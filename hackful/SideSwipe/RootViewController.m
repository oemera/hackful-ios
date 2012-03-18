//
//  RootViewController.m
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//

#import "RootViewController.h"
#import "UIImage+Color.h"
#import "SideSwipeTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define BUTTON_SPACING 10.0

@interface RootViewController (PrivateStuff)
-(void) setupSideSwipeView;
@end

@implementation RootViewController

- (void)loadView {
    [super loadView];
    
    tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    //[tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [[self view] addSubview:tableView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Setup the title and image for each button within the side swipe view
  buttonData = [NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Reply", @"title", @"reply.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Retweet", @"title", @"retweet-outline-button-item.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"Upvote", @"title", @"up_arrow.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"ReadLater", @"title", @"58-bookmark.png", @"image", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:@"SendTo", @"title", @"action.png", @"image", nil],
                   nil];
  buttons = [[NSMutableArray alloc] initWithCapacity:buttonData.count];
    
  self.sideSwipeView = [[UIView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.rowHeight)];
  [self setupSideSwipeView];
}

- (void) setupSideSwipeView
{
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
    float highestButton = 0.0;
    if (sideSwipeView.frame.size.width > 0) {
        for (NSDictionary* buttonInfo in buttonData) {
            UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
            float fillWidthSpace = 40 - buttonImage.size.width;
            float buttonWidth = buttonImage.size.width + fillWidthSpace;
            neededSpace = neededSpace + buttonWidth + BUTTON_SPACING;
            
            if (highestButton < buttonImage.size.width) {
                highestButton = buttonImage.size.width;
            }
        }
    }
    // we add BUTTON_SPACING cause we added to the last button but it is free
    CGFloat spaceLeft = sideSwipeView.frame.size.width - neededSpace + BUTTON_SPACING;
    //NSLog(@"spaceLeft: %f", spaceLeft);
    
    // Iterate through the button data and create a button for each entry
    CGFloat leftEdge = spaceLeft/2;
    for (NSDictionary* buttonInfo in buttonData) {
        
        // Create the button
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // Make sure the button ends up in the right place when the cell is resized
        //button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        
        // Get the button image
        UIImage* buttonImage = [UIImage imageNamed:[buttonInfo objectForKey:@"image"]];
        
        // Set the button's frame
        //NSLog(@"width: %f height: %f", buttonImage.size.width, buttonImage.size.height);
        float fillWidthSpace = 40 - buttonImage.size.width;
        float buttonWidth = buttonImage.size.width + fillWidthSpace;
        button.frame = CGRectMake(leftEdge, sideSwipeView.center.y - buttonImage.size.height/2.0, buttonWidth, buttonImage.size.height + 15);
        
        // Add the image as the button's background image
        // [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
        UIImage* grayImage = [UIImage imageFilledWith:[UIColor colorWithWhite:0.9 alpha:1.0] using:buttonImage];
        //UIImage* grayImage = [RootViewController imageFilledWith:[UIColor colorWithWhite:0.9 alpha:1.0] using:buttonImage];
        [button setImage:grayImage forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        // Add a touch up inside action
        [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
        
        // Keep track of the buttons so we know the proper text to display in the touch up inside action
        [buttons addObject:button];
        
        // Add the button to the side swipe view
        [self.sideSwipeView addSubview:button];
        
        // Move the left edge in prepartion for the next button
        leftEdge = leftEdge + buttonWidth + BUTTON_SPACING;
    }
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    SideSwipeTableViewCell *cell = (SideSwipeTableViewCell*)[theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SideSwipeTableViewCell alloc] initWithReuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.supressDeleteButton = ![self gestureRecognizersSupported];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 65;
}

#pragma mark Button touch up inside action
- (void) touchUpInsideAction:(UIButton*)button
{
  NSIndexPath* indexPath = [tableView indexPathForCell:sideSwipeCell];
  
  NSUInteger index = [buttons indexOfObject:button];
  NSDictionary* buttonInfo = [buttonData objectAtIndex:index];
  [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"%@ on cell %d", [buttonInfo objectForKey:@"title"], indexPath.row]
                               message:nil
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil] show];
  
  [self removeSideSwipeView:YES];
}

@end