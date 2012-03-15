//
//  DetailsHeaderView.h
//  newsyc
//
//  Created by Grant Paul on 3/6/11.
//  Copyright 2011 Xuzz Productions, LLC. All rights reserved.
//

@protocol DetailsHeaderViewDelegate;
@class HKPost;

@interface DetailsHeaderView : UIControl <UIActionSheetDelegate> {
    HKPost *post;
    id<DetailsHeaderViewDelegate> delegate;
    UIView *textView;
    NSURL *savedURL;
}

@property (nonatomic, assign) id<DetailsHeaderViewDelegate> delegate;
@property (nonatomic, retain) HKPost *post;

- (id)initWithEntry:(HKPost *)post_ widthWidth:(CGFloat)width;
- (CGFloat)suggestedHeightWithWidth:(CGFloat)width;
+ (CGSize)offsets;

@end

@protocol DetailsHeaderViewDelegate<NSObject>
@optional

- (void)detailsHeaderView:(DetailsHeaderView *)header selectedURL:(NSURL *)url;

@end
