//
//  SideSwipeTableViewCell.m
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SideSwipeTableViewCell.h"
#import "HKPost.h"
#import "NSDate+TimeAgo.h"

@interface SideSwipeTableViewCell ()
+ (NSString*)createPointsCommentsLabelWith:(int)votes and:(int)commentCount;
+ (UIFont *)titleFont;
+ (UIFont *)userFont;
+ (UIFont *)dateFont;
+ (UIFont *)subtleFont;
@end

@implementation SideSwipeTableViewCell

@synthesize supressDeleteButton;
@synthesize post = _post;

- (id)initWithReuseIdentifier:(NSString *)identifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier])) {
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        CALayer *layer = [contentView layer];
        [layer setContentsGravity:kCAGravityTopLeft];
        [layer setNeedsDisplayOnBoundsChange:YES];
    }
    
    return self;
}

// Recursively go up the view hierarchy to find our tableView
-(UITableView*)getTableView:(UIView*)theView {
    if (!theView.superview) return nil;

    if ([theView.superview isKindOfClass:[UITableView class]]) {
        return (UITableView*)theView.superview;
    }

    return [self getTableView:theView.superview];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    // We suppress the Delete button by explicitly not calling
    // super's implementation
    if (supressDeleteButton) {
        // Reset the editing state of the table back to NO
        UITableView* tableView = [self getTableView:self];
        tableView.editing = NO;
    } else {
        [super setEditing:editing animated:animated];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self setNeedsDisplay];
}

- (void)setPost:(HKPost *)aPost {
    _post = aPost;
    [self setNeedsDisplay];
}

- (void)drawContentView:(CGRect)rect {
    CGSize bounds = [self bounds].size;
    CGSize offsets = CGSizeMake(8.0f, 4.0f);
    
    NSString *user = [[self.post user] name];
    NSString *site = [[NSURL URLWithString:[self.post link]] host];
    NSString *title = [self.post title];
    NSString *date = [NSDate stringForTimeIntervalSinceCreated:[self.post posted]];
    NSString *points = [SideSwipeTableViewCell createPointsCommentsLabelWith:[self.post votes] 
                                                                         and:[self.post commentCount]];
    
    
    if ([self isHighlighted] || [self isSelected]) [[UIColor whiteColor] set];
    if (!([self isHighlighted] || [self isSelected])) [[UIColor grayColor] set];
    [user drawAtPoint:CGPointMake(offsets.width, offsets.height) withFont:[[self class] userFont]];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor lightGrayColor] set];
    CGFloat datewidth = [date sizeWithFont:[[self class] dateFont]].width;
    [date drawAtPoint:CGPointMake(bounds.width - datewidth - offsets.width, offsets.height) withFont:[[self class] dateFont]];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor blackColor] set];
    [title drawInRect:CGRectMake(offsets.width, offsets.height + 19.0f, bounds.width - (2 * offsets.width), bounds.height - 45.0f) 
             withFont:[[self class] titleFont] 
        lineBreakMode:UILineBreakModeWordWrap];
    
    // Points and comments
    if (!([self isHighlighted] || [self isSelected])) [[UIColor grayColor] set];
    CGRect pointsrect;
    pointsrect.size.height = [points sizeWithFont:[[self class] subtleFont]].height;
    pointsrect.size.width = (bounds.width / 2) * 1.1 - offsets.width * 2;
    pointsrect.size.width = floorf(pointsrect.size.width);
    pointsrect.origin = CGPointMake(offsets.width, bounds.height - offsets.height - pointsrect.size.height);
    [points drawInRect:pointsrect 
              withFont:[[self class] subtleFont] 
         lineBreakMode:UILineBreakModeTailTruncation 
             alignment:UITextAlignmentLeft];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor lightGrayColor] set];
    CGRect siterect;
    siterect.size.height = [site sizeWithFont:[[self class] subtleFont]].height;
    siterect.size.width = (bounds.width / 2) * 0.9 - offsets.width * 2;
    siterect.size.width = floorf(siterect.size.width);
    siterect.origin = CGPointMake(bounds.width - offsets.width - siterect.size.width, bounds.height - offsets.height - siterect.size.height);
    [site drawInRect:siterect 
            withFont:[[self class] subtleFont] 
       lineBreakMode:UILineBreakModeHeadTruncation 
           alignment:UITextAlignmentRight];
}

#pragma mark helpers

+ (CGFloat)heightForEntry:(HKPost *)post withWidth:(CGFloat)width {
    CGSize titlesize = [[post title] sizeWithFont:[self titleFont] 
                                constrainedToSize:CGSizeMake(width - 16.0f, 200.0f) 
                                    lineBreakMode:UILineBreakModeWordWrap];
    return titlesize.height + 45.0f;
}

+ (NSString*)createPointsCommentsLabelWith:(int)votes and:(int)commentCount {
    NSString *point = nil;
    if (votes == 1) {
        point = @"1 point";
    } else {
        point = [NSString stringWithFormat:@"%d points", votes];
    }
    
    NSString *comment = nil;
    if (commentCount == 0) {
        comment = @"no comments";
    } else {
        if (commentCount == 1) {
            comment = @"1 comment";
        } else {
            comment = [NSString stringWithFormat:@"%d comments", commentCount];
        }
    }
    
    return [NSString stringWithFormat:@"%@ • %@", point, comment];
}

+ (UIFont *)titleFont {
    return [UIFont boldSystemFontOfSize:15.0f];
}

+ (UIFont *)userFont {
    return [UIFont systemFontOfSize:13.0f];
}

+ (UIFont *)dateFont {
    return [UIFont systemFontOfSize:13.0f];
}

+ (UIFont *)subtleFont {
    return [UIFont systemFontOfSize:13.0f];
}

@end
