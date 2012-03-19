//
//  MainTabBarController.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKAPI.h"
#import "MainTabBarController.h"
#import "PostController.h"
#import "CommentsController.h"
#import "ComposeController.h"
#import "SubmissionComposeController.h"
#import "HKPostList.h"
#import "RootViewController.h"
#import "HackfulLoginController.h"
#import "NavigationController.h"
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
        
        RootViewController *more = [[RootViewController alloc] init];
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
    //HKSession* session = [HKSession currentSession];
    if (![HKSession isAnonymous]) {
        // TODO: show comment viewcontroller 
        NSLog(@"show comment viewcontroller");
        HKSession *session = [HKSession currentSession];
        NSLog(@"session: %@ %@", session.user.name, session.authenticationToken);
        
        
        id topViewController = [self.navigationController topViewController];
        NSLog(@"topViewController class %@", [topViewController class]);
        if ([topViewController isKindOfClass:[PostController class]]) {
            NSLog(@"Should show post submit viewcontroller");
        } else if ([topViewController isKindOfClass:[CommentsController class]]) {
            NSLog(@"Should show comment submit viewcontroller");
        } else {
            NSLog(@"Backup: Should show post submit viewcontroller");
        }
        
        NavigationController *navigation = [[NavigationController alloc] init];
        ComposeController *compose = [[SubmissionComposeController alloc] init];
        
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
