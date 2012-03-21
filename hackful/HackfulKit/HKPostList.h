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
#import "HKAPI.h"

@interface HKPostList : HKList <HKAPIDelegate> {
    BOOL isLoading;
    NSString *resourcePath;
}

@property (nonatomic, assign) id<HKListDelegate> delegate;

- (id)initWithResourcePath:(NSString *)path;
- (void)beginLoading;
- (BOOL)isLoading;

@end
