//
//  HKLogin.m
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kHKUserDefaultsKeyForAuthToken  @"HackfulKit:SessionToken"
#define kHKUserDefaultsKeyForUserId     @"HackfulKit:SessionUserId"
#define kHKUserDefaultsKeyForUserName   @"HackfulKit:SessionUserName"
#define kHKUserDefaultsKeyForUserEmail  @"HackfulKit:SessionUserEmail"

#import "HKSession.h"
#import "HKUser.h"

static HKSession *_currentSession = nil;

@implementation HKSession

@synthesize authenticationToken = _authenticationToken;
@synthesize user = _user;

- (id)initWithUser:(HKUser *)user_ token:(NSString *)token_ {
    if ((self = [super init])) {
        [self setUser:user_];
        [self setAuthenticationToken:token_];
    }
    
    return self;
}

+ (BOOL)isAnonymous {
    NSLog(@"currentSession.authToken %@ user.name %@", _currentSession.authenticationToken, _currentSession.user.name);
    return (_currentSession == nil || _currentSession.authenticationToken == nil || _currentSession.user.name == nil) ? YES : NO;
}

+ (NSString*)emailFromPreviousSession {
    NSString *email = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:kHKUserDefaultsKeyForUserEmail];
    
    if ([email isEqualToString:@""]) return nil; 
    return email;
}

+ (HKSession *)currentSession {
    return _currentSession;
}

+ (void)setCurrentSession:(HKSession *)session {
    NSLog(@"Setting currentSession");
    _currentSession = session;
    if (session != nil) {
        NSNumber *userId = [NSNumber numberWithInt:session.user.objectId];
        [[NSUserDefaults standardUserDefaults] setObject:session.authenticationToken forKey:kHKUserDefaultsKeyForAuthToken];
        [[NSUserDefaults standardUserDefaults] setObject:userId forKey:kHKUserDefaultsKeyForUserId];
        [[NSUserDefaults standardUserDefaults] setObject:session.user.name forKey:kHKUserDefaultsKeyForUserName];
        [[NSUserDefaults standardUserDefaults] setObject:session.user.email forKey:kHKUserDefaultsKeyForUserEmail];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHKUserDefaultsKeyForAuthToken];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHKUserDefaultsKeyForUserId];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHKUserDefaultsKeyForUserName];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kHKUserDefaultsKeyForUserEmail];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)initialize {
    // XXX: is it safe to use NSUserDefaults here?
    NSString *token = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:kHKUserDefaultsKeyForAuthToken];
    NSNumber *userId = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:kHKUserDefaultsKeyForUserId];
    NSString *username = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:kHKUserDefaultsKeyForUserName];
    NSString *email = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:kHKUserDefaultsKeyForUserEmail];
    
    HKUser *user = (HKUser*) [[HKUser alloc] initWithId:[userId intValue] username:username andEmail:email];
    
    if (user != nil && token != nil) {
        HKSession *session = [[HKSession alloc] initWithUser:user token:token];
        [self setCurrentSession:session];
    } else {
        [self setCurrentSession:nil];
    }
}

+ (HKSession *)sessionFromJSON:(id)json {
    id userJson = [json objectForKey:@"user"];
    NSInteger userId = [[userJson objectForKey:@"id"] intValue];
    NSString *username = [userJson objectForKey:@"name"];
    NSString *email = [userJson objectForKey:@"email"];
    NSString *authToken = [json objectForKey:@"auth_token"];
    HKUser *user = [[HKUser alloc] initWithId:userId username:username andEmail:email];
    
    return [[HKSession alloc] initWithUser:user token:authToken];
}

@end
