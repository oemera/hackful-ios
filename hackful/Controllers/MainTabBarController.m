//
//  MainTabBarController.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainTabBarController.h"
#import "EntryListController.h"
#import "EntryList.h"

@implementation MainTabBarController

- (id)init {
    if ((self = [super init])) {
        EntryList *homeEntryList = [[EntryList alloc] initWithURL:[NSURL URLWithString:@"http://hackful.com/frontpage.rss"]];
        EntryListController *home = [[EntryListController alloc] initWithEntryList:homeEntryList];
        [home setTitle:@"Hackful Europe"];
        [home setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:0]];
        
        EntryList *newEntryList = [[EntryList alloc] initWithURL:[NSURL URLWithString:@"http://hackful.com/frontpage.rss"]];
        EntryListController *latest = [[EntryListController alloc] initWithEntryList:newEntryList];
        [latest setTitle:@"New Submissions"];
        [latest setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"New" image:[UIImage imageNamed:@"new.png"] tag:0]];
        
        UIViewController *ask = [[UIViewController alloc] init];
        [ask setTitle:@"Ask Hackful"];
        [ask setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Ask" image:[UIImage imageNamed:@"person.png"] tag:0]];
        
        UIViewController *more = [[UIViewController alloc] init];
        [more setTitle:@"More"];
        [more setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:0]];
        
        NSMutableArray *items = [NSMutableArray arrayWithObjects:home, latest, ask, more, nil];
        [self setViewControllers:items];
    }
    return self;
}

@end
