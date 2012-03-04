//
//  NSDate+TimeAgo.m
//  hackful
//
//  Created by Ömer Avci on 04.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+TimeAgo.h"

@implementation NSDate (TimeAgo)

+ (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)creationDate {
    return [NSDate stringForTimeIntervalSinceCreated:creationDate andTime:[NSDate date]];
}

+ (NSString *)stringForTimeIntervalSinceCreated:(NSDate *)creationDate andTime:(NSDate *)comparingDate {
    NSInteger minInterval;
    NSInteger hourInterval;
    NSInteger dayInterval;
    NSInteger dayModules;
    NSInteger interval = abs((NSInteger)[creationDate timeIntervalSinceDate:comparingDate]);
    
    if(interval >= 86400) {
        dayInterval = interval/86400;
        dayModules = interval%86400;
        if(dayModules != 0) {
            if(dayModules >= 3600) {
                //HourInterval=DayModules/3600;
                return [NSString stringWithFormat:@"%i days", dayInterval];
            } else {
                if(dayModules >= 60) {
                    //MinInterval=DayModules/60;
                    return [NSString stringWithFormat:@"%i days", dayInterval];
                } else {
                    return [NSString stringWithFormat:@"%i days", dayInterval];
                }
            }
        } else {
            return [NSString stringWithFormat:@"%i days", dayInterval];
        }
    } else {
        if(interval >= 3600) {
            hourInterval = interval/3600;
            return [NSString stringWithFormat:@"%i hours", hourInterval];
        } else if(interval >= 60){
            minInterval = interval/60;
            return [NSString stringWithFormat:@"%i minutes", minInterval];
        }
        else{
            return [NSString stringWithFormat:@"%i Sec", interval];
        }
    }
}

@end
