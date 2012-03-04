//
//  HKNotifications.h
//  hackful
//
//  Created by Ömer Avci on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HKNotification.h"

@interface HKNotifications : NSObject

@property (nonatomic, strong) NSString* unread;
@property (nonatomic, strong) NSString* read;

@end
