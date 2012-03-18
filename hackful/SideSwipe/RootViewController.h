//
//  RootViewController.h
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//

#import "SideSwipeTableViewController.h"

@interface RootViewController : SideSwipeTableViewController <UITableViewDataSource, UITableViewDelegate>
{
  NSArray* buttonData;
  NSMutableArray* buttons;
}

@end
