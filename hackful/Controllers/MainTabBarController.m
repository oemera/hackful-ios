//
//  MainTabBarController.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainTabBarController.h"
#import "EntryListController.h"
#import "EntryListNew.h"

#define HOME_RSS_URL @"http://hackful.com/frontpage.rss"
#define NEW_RSS_URL @"http://hackful.com/new.rss"
#define ASK_RSS_URL @"http://hackful.com/ask.rss"

#define HEROKU_SAMPLE_URL @"http://radiant-snow-5561.heroku.com/hackful_new.xml"

@implementation MainTabBarController

- (id)init {
    if ((self = [super init])) {
        EntryListNew *homeEntryList = [[EntryListNew alloc] initWithURL:[NSURL URLWithString:HEROKU_SAMPLE_URL]];
        EntryListController *home = [[EntryListController alloc] initWithEntryList:homeEntryList];
        [home setTitle:@"Hackful Europe"];
        [home setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"home.png"] tag:0]];
        
        EntryListNew *newEntryList = [[EntryListNew alloc] initWithURL:[NSURL URLWithString:@"http://hackful.com/new.rss"]];
        EntryListController *latest = [[EntryListController alloc] initWithEntryList:newEntryList];
        [latest setTitle:@"New Submissions"];
        [latest setTabBarItem:[[UITabBarItem alloc] initWithTitle:@"New" image:[UIImage imageNamed:@"new.png"] tag:0]];
        
        EntryListNew *askEntryList = [[EntryListNew alloc] initWithURL:[NSURL URLWithString:@"http://hackful.com/ask.rss"]];
        EntryListController *ask = [[EntryListController alloc] initWithEntryList:askEntryList];
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

- (void)loadView {
    [super loadView];
    
    composeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composePressed)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationItem] setRightBarButtonItem:composeItem];
}


- (void)composePressed {
    /*if (![[HNSession currentSession] isAnonymous]) {
        [self requestSubmissionType];
    } else {
        loginCompletionBlock = [^{
            [self requestSubmissionType];
        } copy];
        
        [self showLoginController];
    }*/
    NSLog(@"composePressed");
}

@end
