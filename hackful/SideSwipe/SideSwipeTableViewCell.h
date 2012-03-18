//
//  SideSwipeTableViewCell.h
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//
#import "ABTableViewCell.h"

@class HKPost;

@interface SideSwipeTableViewCell : ABTableViewCell {
    BOOL supressDeleteButton;
}

@property (nonatomic) BOOL supressDeleteButton;
@property (nonatomic, strong) HKPost *post;

- (id)initWithReuseIdentifier:(NSString *)identifier;

+ (CGFloat)heightForEntry:(HKPost *)post withWidth:(CGFloat)width;

@end
