//
//  NSDate+TimeAgo.m
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
