//
//  NavigationController.m
//  newsyc
//
//  Created by Grant Paul on 3/29/11.
//  Copyright 2011 Xuzz Productions, LLC. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"disable-orange"]) {
        //[[self navigationBar] setTintColor:[UIColor colorWithRed:1.0f green:0.4f blue:0.0f alpha:1.0f]];
        UIColor *color = [UIColor colorWithRed:52.0/255.0 green:80.0/255.0 blue:101.0/255.0 alpha:1.0f];
        [[self navigationBar] setTintColor:color];
    } else {
        [[self navigationBar] setTintColor:nil];
    }
}

// Why this isn't delegated by UIKit to the top view controller, I have no clue.
// This, however, should unobstrusively add that delegation.
- (UIModalPresentationStyle)modalPresentationStyle {
    if ([self topViewController]) {
        return [[self topViewController] modalPresentationStyle];
    } else {
        return [super modalPresentationStyle];
    }
}

@end
