//
//  CommentTableCell.h
//  hackful
//
//  Created by Ömer Avci on 14.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ABTableViewCell.h"

@class HKComment;
@interface CommentTableCell : ABTableViewCell {
    HKComment *comment;
}

@property (nonatomic, retain) HKComment *comment;

+ (CGFloat)heightForEntry:(HKComment *)comment withWidth:(CGFloat)width showReplies:(BOOL)replies;
+ (CGFloat)heightForEntry:(HKComment *)comment withWidth:(CGFloat)width showReplies:(BOOL)replies indentationLevel:(int)indentationLevel;

- (id)initWithReuseIdentifier:(NSString *)identifier;

@end
