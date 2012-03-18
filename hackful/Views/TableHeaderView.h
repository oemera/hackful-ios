//
//  TableHeaderView.h
//  hackful
//
//  Created by Ömer Avci on 14.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKPost;

@interface TableHeaderView : UIControl {
    HKPost *post;
    UIView *textView;
}

- (id)initWithPost:(HKPost*)post_ andWidth:(int)width_;
- (BOOL)hasURL;

+ (CGSize)offsets;
+ (UIFont *)titleFont;
+ (UIFont *)subtleFont;
+ (UIImage *)disclosureImage;

@end

@protocol HeaderViewDelegate<NSObject>
@optional

- (void)detailsHeaderView:(TableHeaderView *)header selectedURL:(NSURL *)url;

@end
