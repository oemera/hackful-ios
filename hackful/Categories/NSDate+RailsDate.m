//
//  NSDate+FormatDate.m
//  hackful
//
//  Created by Ömer Avci on 13.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+RailsDate.h"

static NSDateFormatter* dateFormatter = nil;

@implementation NSDate (RailsDate)

+ (NSDate*)dateForRailsDateString:(NSString*)dateStr  {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init]; 
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    
    return [dateFormatter dateFromString:dateStr];
}

@end
