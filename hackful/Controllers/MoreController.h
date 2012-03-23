//
//  MoreControllerViewController.h
//  hackful
//
//  Created by Ömer Avci on 23.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "LoginController.h"

@interface MoreController : UIViewController <UITableViewDelegate, UITableViewDataSource, LoginControllerDelegate, 
MFMailComposeViewControllerDelegate> {
    UITableView *tableView;
}

@end
