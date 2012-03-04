//
//  HKUser.h
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface HKUser : NSObject

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* email;

@end
