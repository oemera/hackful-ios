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

@property (nonatomic, strong) NSString* commentableId;
@property (nonatomic, strong) NSString* commentableType;

@end
