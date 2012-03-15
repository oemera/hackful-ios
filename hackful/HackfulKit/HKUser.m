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

+ (HKUser*)userFromJSON:(id)json {
    NSInteger objectId = [[json objectForKey:@"id"] intValue];
    NSString *name = [json objectForKey:@"name"];
    NSString *email = [json objectForKey:@"email"];
    
    HKUser *user = [[HKUser alloc] initWithId:objectId username:name andEmail:email];
    return user;
}

@end
