//
//  HKLogin.h
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKLogin : NSObject

@property (nonatomic, strong) NSString* success;
@property (nonatomic, strong) NSString* message;
@property (nonatomic, strong) NSString* authenticationToken;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* email;

@end
