//
//  EntryListNew.h
//  hackful
//
//  Created by Ömer Avci on 02.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKList.h"
#import "HKListDelegate.h"

@interface HKPostList : HKList {
    BOOL isLoading;
    id<HKListDelegate> delegate;
    NSString *resourcePath;
}

@property (nonatomic, assign) id<HKListDelegate> delegate;

- (id)initWithResourcePath:(NSString *)path;
- (void)beginLoading;
- (BOOL)isLoading;

@end