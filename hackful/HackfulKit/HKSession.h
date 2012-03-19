//
//  HKLogin.h
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HKUser;
@interface HKSession : NSObject

@property (nonatomic, strong) NSString* authenticationToken;
@property (nonatomic, strong) HKUser* user;

- (id)initWithUser:(HKUser *)user_ token:(NSString *)token_;

+ (BOOL)isAnonymous;
+ (HKSession *)currentSession;
+ (void)setCurrentSession:(HKSession *)session;
+ (void)initialize;
+ (HKSession *)sessionFromJSON:(id)json;

@end