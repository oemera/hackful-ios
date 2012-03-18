//
//  SideSwipeTableViewCell.m
//  SideSwipeTableView
//
//  Created by Peter Boctor on 4/13/11.
//  Copyright 2011 Peter Boctor. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SideSwipeTableViewCell.h"
#import "UIImage+Color.h"
#import "HKPost.h"
#import "NSDate+TimeAgo.h"

static UIImage *commentImage = nil;

@interface SideSwipeTableViewCell () {
    CGRect commentButtonActiveArea;
}

- (void)touchUpInsideComment;

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
        
        if (commentImage == nil) {
            commentImage = [UIImage imageFilledWith:[UIColor colorWithWhite:0.5 alpha:1.0] using:[UIImage imageNamed:@"comments.png"]];
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
    
    NSString *user = [[self.post user] name];
    //NSString *site = [[NSURL URLWithString:[self.post link]] host];
    NSString *title = [self.post title];
    NSString *date = [NSDate stringForTimeIntervalSinceCreated:[self.post posted]];
    NSString *comments = [NSString stringWithFormat:@"%d", self.post.commentCount];
    NSString *points = [SideSwipeTableViewCell createPointsAndDateLabelWith:[self.post votes] 
                                                                         and:date];
    
    
    if ([self isHighlighted] || [self isSelected]) [[UIColor whiteColor] set];
    if (!([self isHighlighted] || [self isSelected])) [[UIColor grayColor] set];
    [user drawAtPoint:CGPointMake(offsets.width, offsets.height) withFont:[[self class] userFont]];
    
    /*if (!([self isHighlighted] || [self isSelected])) [[UIColor lightGrayColor] set];
    CGFloat datewidth = [date sizeWithFont:[[self class] dateFont]].width;
    [date drawAtPoint:CGPointMake(bounds.width - datewidth - offsets.width, offsets.height) withFont:[[self class] dateFont]];*/
    
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
    CGSize commentOffsets = CGSizeMake(13.0f, 4.0f);
    UIImage *commentsImage = [UIImage imageFilledWith:[UIColor colorWithWhite:0.5 alpha:1.0] using:[UIImage imageNamed:@"comments.png"]];
    [commentsImage drawAtPoint:CGPointMake(bounds.width - commentsImage.size.width - commentOffsets.width, offsets.height + 11)];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor lightGrayColor] set];
    CGRect commentRect;
    commentRect.size.height = [comments sizeWithFont:[[self class] subtleFont]].height;
    commentRect.size.width = [comments sizeWithFont:[[self class] subtleFont]].width;
    
    CGFloat commentsImageCenterPoint    = (commentsImage.size.width/2);
    CGFloat commentsCenterPoint         = commentsImage.size.width - commentsImageCenterPoint - (commentRect.size.width/2);
    CGFloat commentLableX               = bounds.width - commentOffsets.width - commentsImage.size.width + commentsCenterPoint;
    CGFloat commentLableY               = bounds.height - offsets.height - 6 - commentRect.size.height;
    commentRect.origin = CGPointMake(commentLableX, commentLableY);
    [comments drawInRect:commentRect 
                withFont:[[self class] subtleFont] 
           lineBreakMode:UILineBreakModeHeadTruncation 
               alignment:UITextAlignmentRight];
    
    
    CGFloat commentAreaWidth = bounds.width - (bounds.width - commentsImage.size.width - commentOffsets.width) + 15;
    CGFloat commentAreaHeight = bounds.height;
    CGFloat commentAreaX = bounds.width - commentAreaWidth - commentOffsets.width + 15;
    CGFloat commentAreaY = 0;
    commentButtonActiveArea = CGRectMake(commentAreaX, commentAreaY, commentAreaWidth, commentAreaHeight);
    
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
        [self touchUpInsideComment];
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

#pragma mark - actions

- (void)touchUpInsideComment {
    if ([self.delegate respondsToSelector:@selector(touchUpInsideCommentButtonForPost:)]) {
        [self.delegate touchUpInsideCommentButtonForPost:self.post];
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
    
    /*NSString *comment = nil;
    if (commentCount == 0) {
        comment = @"no comments";
    } else {
        if (commentCount == 1) {
            comment = @"1 comment";
        } else {
            comment = [NSString stringWithFormat:@"%d comments", commentCount];
        }
    }*/
    
    return [NSString stringWithFormat:@"%@ • %@", point, date];
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
