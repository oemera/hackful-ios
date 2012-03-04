//
//  SideSwipeTableViewController.h
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//


@interface SideSwipeTableViewController : UIViewController
{
  UITableView* tableView;
  UIView* sideSwipeView;
  UITableViewCell* sideSwipeCell;
  UISwipeGestureRecognizerDirection sideSwipeDirection;
  BOOL animatingSideSwipe;
}

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* sideSwipeView;
@property (nonatomic, strong) UITableViewCell* sideSwipeCell;
@property (nonatomic) UISwipeGestureRecognizerDirection sideSwipeDirection;
@property (nonatomic) BOOL animatingSideSwipe;

- (void) removeSideSwipeView:(BOOL)animated;
- (BOOL) gestureRecognizersSupported;

@end
