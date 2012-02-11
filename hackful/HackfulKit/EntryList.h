//
//  EntryList.h
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWFeedParser.h"

@protocol EntryListDelegate;

@interface EntryList : NSObject <MWFeedParserDelegate> {
    BOOL isLoading;
    id<EntryListDelegate> delegate;
    NSURL *feedURL;
    MWFeedParser *feedParser;
}

@property (nonatomic, assign) id<EntryListDelegate> delegate;
@property (readonly) NSArray *entries;

- (id)initWithURL:(NSURL *)feedURL_;
- (void)beginLoading;
- (BOOL)isLoading;

@end

@protocol EntryListDelegate <NSObject>

@optional
- (void)entryListFinishedLoading:(EntryList *)entryList;

@end