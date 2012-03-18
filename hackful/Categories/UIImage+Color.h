//
//  NSImage+FIllColor.h
//  hackful
//
//  Created by Ömer Avci on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImage (Color)

+ (UIImage*)imageFilledWith:(UIColor*)color using:(UIImage*)image;

@end
