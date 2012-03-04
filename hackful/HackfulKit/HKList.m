//
//  HKList.m
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKList.h"

@implementation HKList

@synthesize mutableEntries = _mutableEntries;

- (NSArray *)entries {
    return [self.mutableEntries copy];
}

@end
