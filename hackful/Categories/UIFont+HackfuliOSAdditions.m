//
//  UIFont+HackfuliOSAdditions.m
//  hackful
//
//  Created by Ömer Avci on 07.04.13.
//  Copyright (c) 2013 Ömer Avci. All rights reserved.
//

#import "UIFont+HackfuliOSAdditions.h"

NSString *const kInterfaceFontName = @"HelveticaNeue";
NSString *const kLightInterfaceFontName = @"HelveticaNeue-Light";
NSString *const kBoldInterfaceFontName = @"HelveticaNeue-Bold";

@implementation UIFont (HackfuliOSAdditions)

#pragma mark - Standard

+ (UIFont *)hackfulFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kInterfaceFontName size:fontSize];
}

#pragma mark - Interface

+ (UIFont *)hackfulInterfaceFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kInterfaceFontName size:fontSize];
}

+ (UIFont *)lightHackfulInterfaceFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kLightInterfaceFontName size:fontSize];
}

+ (UIFont *)boldHackfulInterfaceFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kBoldInterfaceFontName size:fontSize];
}

@end
