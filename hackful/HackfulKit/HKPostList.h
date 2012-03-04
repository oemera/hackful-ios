//
//  EntryListNew.h
//  hackful
//
//  Created by Ömer Avci on 02.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "HKList.h"
#import "HKListDelegate.h"

@interface HKPostList : HKList <RKRequestDelegate, RKObjectLoaderDelegate> {
    BOOL isLoading;
    id<HKListDelegate> delegate;
    NSString *resourcePath;
    RKObjectManager *_objectManager;
    RKObjectMapping *_postsMapping;
}

@property (nonatomic, assign) id<HKListDelegate> delegate;

- (id)initWithResourcePath:(NSString *)path;
- (void)beginLoading;
- (BOOL)isLoading;

@end
