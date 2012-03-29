//
//  SideSwipeTableViewCell.h
//  hackful
//
//  Created by Ömer Avci on 14.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ABTableViewCell.h"

@class HKPost;
@protocol SideSwipeTableViewCellDelegate;

@interface SideSwipeTableViewCell : ABTableViewCell {
    BOOL supressDeleteButton;
}

@property (nonatomic) BOOL supressDeleteButton;
@property (nonatomic, assign) id<SideSwipeTableViewCellDelegate> delegate;
@property (nonatomic, strong) HKPost *post;


- (id)initWithReuseIdentifier:(NSString *)identifier;

+ (CGFloat)heightForEntry:(HKPost *)post withWidth:(CGFloat)width;

@end

@protocol SideSwipeTableViewCellDelegate <NSObject>

@optional
- (void)commentButtonPressedForPost:(HKPost *)post;

@end


