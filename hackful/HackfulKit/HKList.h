//
//  HKList.h
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKList : NSObject{
    NSMutableArray *_mutableEntries;
}

@property (nonatomic, strong) NSMutableArray *mutableEntries;

- (NSArray *)entries;

@end
