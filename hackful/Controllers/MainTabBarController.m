//
//  MainTabBarController.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
        HKPostList *homePostList = [[HKPostList alloc] initWithResourcePath:kHKFrontpageResourcePath];
        PostController *home = [[PostController alloc] initWithEntryList:homePostList];
        [home setTitle:@"Hackful Europe"];
        [home setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:0]];
        
        HKPostList *newPostList = [[HKPostList alloc] initWithResourcePath:kHKNewResourcePath];
        PostController *latest = [[PostController alloc] initWithEntryList:newPostList];
        [latest setTitle:@"New Submissions"];
        [latest setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"New" image:[UIImage imageNamed:@"new.png"] tag:0]];
        
        HKPostList *askPostList = [[HKPostList alloc] initWithResourcePath:kHKAskResourcePath];
        PostController *ask = [[PostController alloc] initWithEntryList:askPostList];
        [ask setTitle:@"Ask Hackful"];
        [ask setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Ask" image:[UIImage imageNamed:@"person.png"] tag:0]];
        
        MoreController *more = [[MoreController alloc] init];
        [more setTitle:@"More"];
        [more setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0]];
        
        NSMutableArray *items = [NSMutableArray arrayWithObjects:home, latest, ask, more, nil];
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

- (void)composePressed {
    NSLog(@"composePressed");
    if (![HKSession isAnonymous]) {
        NavigationController *navigation = [[NavigationController alloc] init];
        SubmissionComposeController *compose = [[SubmissionComposeController alloc] init];
        
        [navigation setViewControllers:[NSArray arrayWithObject:compose]];
        [self presentModalViewController:navigation animated:YES];
    } else {
        [self showLoginController];
    }
}

- (void)loadView {
    [super loadView];
    
    composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composePressed)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationItem] setRightBarButtonItem:composeItem];
}

#pragma mark - LoginControllerDelegate

- (void)loginControllerDidCancel:(LoginController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)loginControllerDidLogin:(LoginController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

@end
