//
//  HKUser.m
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKUser.h"

@implementation HKUser

@synthesize objectId = _objectId;
@synthesize name = _name;
@synthesize email = _email;

- (id)initWithId:(NSInteger)userId username:(NSString*)username andEmail:(NSString*)email {
    if ((self = [super init])) {
        _objectId = userId;
        _name = [username copy];
        _email = [email copy];
    }
    
    return self;
}

@end
