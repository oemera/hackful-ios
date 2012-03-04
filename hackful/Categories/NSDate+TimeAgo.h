//
//  NSDate+TimeAgo.h
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TimeAgo)

+ (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)dateTime;
+ (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)creationDate andTime:(NSDate *)comparingDate;


@end
