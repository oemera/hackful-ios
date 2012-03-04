//
//  HKPost.h
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKEntry.h"

@interface HKPost : HKEntry

@property (nonatomic, strong) NSURL* link;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSNumber* commentCount;

@end
