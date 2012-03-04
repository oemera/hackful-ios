//
//  EntryListNew.h
//  hackful
//
//  Created by Ömer Avci on 02.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@protocol EntryListDelegate;

@interface EntryListNew : NSObject <RKRequestDelegate, RKObjectLoaderDelegate> {
    BOOL isLoading;
    id<EntryListDelegate> delegate;
    NSURL *apiUrl;
}

@property (nonatomic, assign) id<EntryListDelegate> delegate;
@property (readonly) NSArray *entries;

- (id)initWithURL:(NSURL *)apiUrl_;
- (void)beginLoading;
- (BOOL)isLoading;

@end

@protocol EntryListDelegate <NSObject>

@optional
- (void)entryListFinishedLoading:(EntryListNew *)entryList;

@end
