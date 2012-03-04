//
//  HKEntry.h
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKUser.h"

@interface HKEntry : NSObject

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSDate* posted;
@property (nonatomic, strong) NSNumber* votes;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, strong) HKUser* user;

@end
