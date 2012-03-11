//
//  MainTabBarController.h
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginController.h"

@interface MainTabBarController : UITabBarController <LoginControllerDelegate> {
    UIBarButtonItem *composeItem;
}

@end
