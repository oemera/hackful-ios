//
//  HKLogin.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012. All rights reserved.
// 
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
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
