//
//  EntryList.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryList.h"
#import "MWFeedParser.h"

@interface EntryList()

@property (nonatomic, strong) NSMutableArray *mutableEntries;
- (void)finishedLoading;

@end

@implementation EntryList

@synthesize delegate = _delegate;
@synthesize mutableEntries = _mutableEntries;

- (id)initWithURL:(NSURL *)feedURL_ {
    if(self = [super init]) {
        feedURL = feedURL_;
        isLoading = NO;
    }
    
    return self;
}

- (void)beginLoading {
    NSLog(@"beginLoading");
    if(feedParser == nil) {
        feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        feedParser.delegate = self;
        feedParser.feedParseType = ParseTypeFull;
        feedParser.connectionType = ConnectionTypeAsynchronously;
    }
    
    [self.mutableEntries removeAllObjects];
    
    isLoading = YES;
    [feedParser parse];
}

- (void)finishedLoading {
    NSLog(@"finishedLoading");
    if ([self.delegate respondsToSelector:@selector(entryListFinishedLoading:)]) {
        NSLog(@"respondsToSelector entryListFinishedLoading");
		[self.delegate entryListFinishedLoading:self];
    } else {
        NSLog(@"didn't respondToSelector entryListFinishedLoading");
    }
}

- (BOOL)isLoading {
    return isLoading;
}

- (NSArray *)entries {
    return [self.mutableEntries copy];
}

- (NSMutableArray *)mutableEntries {
    if(_mutableEntries == nil) _mutableEntries = [[NSMutableArray alloc] init];
    return _mutableEntries;
}

#pragma mark - MWFeedParserDelegate

- (void)feedParserDidFinish:(MWFeedParser *)parser {
    isLoading = NO;
    [self finishedLoading];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error {
    isLoading = NO;
    [self finishedLoading];
}

- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    NSLog(@"didParseFeedItem: %@", [item title]);
    [self.mutableEntries addObject:item];
}

@end