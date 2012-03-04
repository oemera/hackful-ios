//
//  HKNotification.h
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HKNotification : NSObject

@property (nonatomic, strong) NSString* objectId;
@property (nonatomic, strong) NSString* alertableId;
@property (nonatomic, strong) NSString* alertableType;
@property (nonatomic, strong) NSString* alertedId;
@property (nonatomic, strong) NSString* alertedType;
@property (nonatomic, strong) NSString* created;
@property (nonatomic, strong) NSString* unread;
@property (nonatomic, strong) NSString* userId;

@end
