//
//  HKLogin.m
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKSession.h"
#import "HKUser.h"

static HKSession *current = nil;

@implementation HKSession

@synthesize authenticationToken = _authenticationToken;
@synthesize user = _user;

+ (BOOL)isAnonymous {
    return current == nil ? YES : NO;
}

+ (HKSession *)currentSession {
    return current;
}

+ (void)setCurrentSession:(HKSession *)session {
    current = session;
    if (session != nil) {
        NSNumber *userId = [NSNumber numberWithInt:session.user.objectId];
        [[NSUserDefaults standardUserDefaults] setObject:session.authenticationToken forKey:@"HackfulKit:SessionToken"];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"HackfulKit:SessionUserId"];
        [[NSUserDefaults standardUserDefaults] setObject:session.user.name forKey:@"HackfulKit:SessionUserName"];
        [[NSUserDefaults standardUserDefaults] setObject:session.user.email forKey:@"HackfulKit:SessionUserEmail"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HNKit:SessionToken"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HNKit:SessionUserId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HNKit:SessionUserName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"HNKit:SessionUserEmail"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)initialize {
    // XXX: is it safe to use NSUserDefaults here?
    NSString *token = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:@"HackfulKit:SessionToken"];
    NSNumber *userId = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:@"HackfulKit:SessionUserId"];
    NSString *username = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:@"HackfulKit:SessionUserName"];
    NSString *email = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:@"HackfulKit:SessionUserEmail"];
    
    HKUser *user = (HKUser*) [[HKUser alloc] initWithId:[userId intValue] username:username andEmail:email];
    
    if (user != nil && token != nil) {
        HKSession *session = [[HKSession alloc] initWithUser:user token:token];
        [self setCurrentSession:session];
    } else {
        [self setCurrentSession:nil];
    }
}

- (id)initWithUser:(HKUser *)user_ token:(NSString *)token_ {
    if ((self = [super init])) {
        [self setUser:user_];
        [self setAuthenticationToken:token_];
    }
    
    return self;
}

@end
