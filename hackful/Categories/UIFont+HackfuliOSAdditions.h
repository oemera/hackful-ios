//
//  UIFont+HackfuliOSAdditions.h
//  hackful
//
//  Created by Ömer Avci on 07.04.13.
//  Copyright (c) 2013 Ömer Avci. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (HackfuliOSAdditions)

#pragma mark - Standard

+ (UIFont *)hackfulFontOfSize:(CGFloat)fontSize;
//+ (UIFont *)italicHackfulFontOfSize:(CGFloat)fontSize;
//+ (UIFont *)boldHackfulFontOfSize:(CGFloat)fontSize;
//+ (UIFont *)boldItalicHackfulFontOfSize:(CGFloat)fontSize;

#pragma mark - Interface

+ (UIFont *)hackfulInterfaceFontOfSize:(CGFloat)fontSize;
+ (UIFont *)lightHackfulInterfaceFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldHackfulInterfaceFontOfSize:(CGFloat)fontSize;

@end
