//
//  MainTabBarController.m
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

#import "MainTabBarController.h"
#import "PostController.h"
#import "CommentsController.h"
#import "SubmissionComposeController.h"
#import "HackfulLoginController.h"
#import "NavigationController.h"
#import "MoreController.h"
#import "HKAPI.h"
#import "HKPostList.h"
#import "HKSession.h"
#import "HKUser.h"

@implementation MainTabBarController

- (id)init {
    if ((self = [super init])) {
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:4];
        NavigationController *navigationController;
        
        navigationController = [[NavigationController alloc] init];
        HKPostList *homePostList = [[HKPostList alloc] initWithResourcePath:kHKFrontpageResourcePath];
        PostController *home = [[PostController alloc] initWithEntryList:homePostList];
        [home setTitle:@"Hackful Europe"];
        [home setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:0]];
        navigationController.ViewControllers = @[home];
        [items addObject:navigationController];
        
        navigationController = [[NavigationController alloc] init];
        HKPostList *newPostList = [[HKPostList alloc] initWithResourcePath:kHKNewResourcePath];
        PostController *latest = [[PostController alloc] initWithEntryList:newPostList];
        [latest setTitle:@"New Submissions"];
        [latest setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"New" image:[UIImage imageNamed:@"new.png"] tag:0]];
        navigationController.ViewControllers = @[latest];
        [items addObject:navigationController];
        
        navigationController = [[NavigationController alloc] init];
        HKPostList *askPostList = [[HKPostList alloc] initWithResourcePath:kHKAskResourcePath];
        PostController *ask = [[PostController alloc] initWithEntryList:askPostList];
        [ask setTitle:@"Ask Hackful"];
        [ask setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Ask" image:[UIImage imageNamed:@"person.png"] tag:0]];
        navigationController.ViewControllers = @[ask];
        [items addObject:navigationController];
        
        navigationController = [[NavigationController alloc] init];
        MoreController *more = [[MoreController alloc] init];
        [more setTitle:@"More"];
        [more setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0]];
        navigationController.ViewControllers = @[more];
        [items addObject:navigationController];
        
        [self setViewControllers:items];
    }
    return self;
}

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

#pragma mark - LoginControllerDelegate

- (void)loginControllerDidCancel:(LoginController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loginControllerDidLogin:(LoginController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

@end
