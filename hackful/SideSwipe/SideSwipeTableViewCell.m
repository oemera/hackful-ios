//
//  SideSwipeTableViewCell.m
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012. All rights reserved.
// 
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "SideSwipeTableViewCell.h"
#import "UIImage+Color.h"
#import "HKPost.h"
#import "NSDate+TimeAgo.h"
#import "UIFont+HackfuliOSAdditions.h"

static UIImage *commentsImage = nil;

@interface SideSwipeTableViewCell () {
    CGRect commentButtonActiveArea;
}

- (void)commentButtonPressed;

+ (NSString*)createPointsAndDateLabelWith:(int)votes and:(NSString*)date;
+ (UIFont *)titleFont;
+ (UIFont *)userFont;
+ (UIFont *)dateFont;
+ (UIFont *)subtleFont;
@end

@implementation SideSwipeTableViewCell

@synthesize supressDeleteButton;
@synthesize post = _post;
@synthesize delegate = _delegate;

- (id)initWithReuseIdentifier:(NSString *)identifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier])) {
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        CALayer *layer = [contentView layer];
        [layer setContentsGravity:kCAGravityTopLeft];
        [layer setNeedsDisplayOnBoundsChange:YES];
        
        if (commentsImage == nil) {
            commentsImage = [UIImage imageNamed:@"comments-icon"];
        }
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
    CGSize commentOffsets = CGSizeMake(13.0f, 4.0f);
    
    NSString *user = [[self.post user] name];
    //NSString *site = [[NSURL URLWithString:[self.post link]] host];
    NSString *title = [self.post title];
    NSString *date = [NSDate stringForTimeIntervalSinceCreated:[self.post posted]];
    NSString *comments = [NSString stringWithFormat:@"%d", self.post.commentCount];
    NSString *points = [SideSwipeTableViewCell createPointsAndDateLabelWith:[self.post votes] 
                                                                        and:date];
    
    // CommentArea
    CGFloat commentAreaWidth = bounds.width - (bounds.width - commentsImage.size.width - commentOffsets.width) + 15;
    CGFloat commentAreaHeight = bounds.height;
    CGFloat commentAreaX = bounds.width - commentAreaWidth - commentOffsets.width + 15;
    CGFloat commentAreaY = 0;
    commentButtonActiveArea = CGRectMake(commentAreaX, commentAreaY, commentAreaWidth, commentAreaHeight);
    
    if ([self isHighlighted] || [self isSelected]) [[UIColor whiteColor] set];
    if (!([self isHighlighted] || [self isSelected])) [[UIColor grayColor] set];
    [user drawAtPoint:CGPointMake(offsets.width, offsets.height) withFont:[[self class] userFont]];
    
    /*if (!([self isHighlighted] || [self isSelected])) [[UIColor lightGrayColor] set];
    CGFloat datewidth = [date sizeWithFont:[[self class] dateFont]].width;
    [date drawAtPoint:CGPointMake(bounds.width - datewidth - offsets.width, offsets.height) withFont:[[self class] dateFont]];*/
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor blackColor] set];
    [title drawInRect:CGRectMake(offsets.width, offsets.height + 19.0f, bounds.width - (2 * offsets.width) - commentButtonActiveArea.size.width, bounds.height - 45.0f) 
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
    
    /*if (!([self isHighlighted] || [self isSelected])) [[UIColor lightGrayColor] set];
    CGRect siterect;
    siterect.size.height = [site sizeWithFont:[[self class] subtleFont]].height;
    siterect.size.width = (bounds.width / 2) * 0.9 - offsets.width * 2;
    siterect.size.width = floorf(siterect.size.width);
    siterect.origin = CGPointMake(bounds.width - offsets.width - siterect.size.width, bounds.height - offsets.height - siterect.size.height);
    [site drawInRect:siterect 
            withFont:[[self class] subtleFont] 
       lineBreakMode:UILineBreakModeHeadTruncation 
           alignment:UITextAlignmentRight];*/
    
    // BIG TODO: Refactoring! Too much copy paste code
    CGFloat commentImageY = ((bounds.height - (commentsImage.size.height + 15)) / 2);
    //offsets.height + 11
    [commentsImage drawAtPoint:CGPointMake(bounds.width - commentsImage.size.width - commentOffsets.width, commentImageY)];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor lightGrayColor] set];
    CGRect commentRect;
    commentRect.size.height = [comments sizeWithFont:[[self class] subtleFont]].height;
    commentRect.size.width = [comments sizeWithFont:[[self class] subtleFont]].width;
    
    CGFloat commentsImageCenterPoint    = (commentsImage.size.width/2);
    CGFloat commentsCenterPoint         = commentsImage.size.width - commentsImageCenterPoint - (commentRect.size.width/2);
    CGFloat commentLableX               = bounds.width - commentOffsets.width - commentsImage.size.width + commentsCenterPoint;
    //CGFloat commentLableY               = bounds.height - offsets.height - 6 - commentRect.size.height;
    CGFloat commentLableY               = commentImageY + commentsImage.size.height + offsets.height - 2;
    commentRect.origin = CGPointMake(commentLableX, commentLableY);
    [comments drawInRect:commentRect 
                withFont:[[self class] subtleFont] 
           lineBreakMode:UILineBreakModeHeadTruncation 
               alignment:UITextAlignmentRight];
    
    /*CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rectangle = commentButtonActiveArea;
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, rectangle);*/
}

#pragma mark - touch events

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch =[touches anyObject]; 
    CGPoint startPoint = [touch locationInView:self.contentView];
    if(CGRectContainsPoint(commentButtonActiveArea, startPoint)) {
        [self commentButtonPressed];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

#pragma mark - actions

- (void)commentButtonPressed {
    if ([self.delegate respondsToSelector:@selector(commentButtonPressedForPost:)]) {
        [self.delegate commentButtonPressedForPost:self.post];
    }
}

#pragma mark - helpers

+ (CGFloat)heightForEntry:(HKPost *)post withWidth:(CGFloat)width {
    CGSize titlesize = [[post title] sizeWithFont:[self titleFont] 
                                constrainedToSize:CGSizeMake(width - 16.0f, 200.0f) 
                                    lineBreakMode:UILineBreakModeWordWrap];
    return titlesize.height + 45.0f;
}

+ (NSString*)createPointsAndDateLabelWith:(int)votes and:(NSString*)date {
    NSString *point = nil;
    if (votes == 1) {
        point = @"1 point";
    } else {
        point = [NSString stringWithFormat:@"%d points", votes];
    }
    
    return [NSString stringWithFormat:@"%@ • %@", point, date];
}

+ (UIFont *)titleFont {
    //return [UIFont boldSystemFontOfSize:15.0f];
    return [UIFont hackfulInterfaceFontOfSize:15.0f];
}

+ (UIFont *)userFont {
    //return [UIFont systemFontOfSize:13.0f];
    return [UIFont hackfulInterfaceFontOfSize:13.0f];
}

+ (UIFont *)dateFont {
    //return [UIFont systemFontOfSize:13.0f];
    return [UIFont hackfulInterfaceFontOfSize:13.0f];
}

+ (UIFont *)subtleFont {
    //return [UIFont systemFontOfSize:13.0f];
    return [UIFont hackfulInterfaceFontOfSize:13.0f];
}

@end
