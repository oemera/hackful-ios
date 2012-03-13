//
//  NSDate+FormatDate.h
//  hackful
//
//  Created by Ömer Avci on 13.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (RailsDate)

+ (NSDate*)dateForRailsDateString:(NSString*)dateStr;

@end
