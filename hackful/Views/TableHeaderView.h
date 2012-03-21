//
//  TableHeaderView.h
//  hackful
//
//  Created by Ömer Avci on 14.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKPost;
@protocol TableHeaderViewDelegate;

@interface TableHeaderView : UIControl {
    HKPost *post;
    UIView *textView;
}

@property (nonatomic, assign) id<TableHeaderViewDelegate> delegate;

- (id)initWithPost:(HKPost*)post_ andWidth:(int)width_;
- (BOOL)hasURL;

+ (CGSize)offsets;
+ (UIFont *)titleFont;
+ (UIFont *)subtleFont;
+ (UIImage *)disclosureImage;

@end

@protocol TableHeaderViewDelegate<NSObject>
@optional

- (void)tableHeaderView:(TableHeaderView *)header selectedURL:(NSURL *)url;

@end
