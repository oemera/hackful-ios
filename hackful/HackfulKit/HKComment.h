//
//  HKComment.h
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKEntry.h"

@interface HKComment : HKEntry

@property (nonatomic, strong) NSArray* comments;
@property (nonatomic) NSInteger depth;

+ (HKComment*)commentFromJSON:(id)json;

@end
