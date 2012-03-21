#import <QuartzCore/QuartzCore.h>

#import "CommentTableCell.h"
#import "HKComment.h"
#import "NSDate+TimeAgo.h"

@implementation CommentTableCell
@synthesize comment;

- (id)initWithReuseIdentifier:(NSString *)identifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier])) {
        [contentView setBackgroundColor:[UIColor whiteColor]];
        
        CALayer *layer = [contentView layer];
        [layer setContentsGravity:kCAGravityTopLeft];
        [layer setNeedsDisplayOnBoundsChange:YES];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self setNeedsDisplay];
}

- (void)setComment:(HKComment *)comment_ {
    comment = comment_;
    
    [self setNeedsDisplay];
}

+ (NSString *)formatBodyText:(NSString *)bodyText {
    NSNumber *shortComments = [[NSUserDefaults standardUserDefaults] objectForKey:@"interface-short-comments"];

    if (shortComments != nil && ![shortComments boolValue]) {
        bodyText = [bodyText stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
    }
    
    bodyText = [bodyText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return bodyText;
}

+ (UIFont *)bodyFont {
    NSNumber *smallText = [[NSUserDefaults standardUserDefaults] objectForKey:@"interface-small-text"];
    
    if (smallText == nil || [smallText boolValue]) {
        return [UIFont systemFontOfSize:12.0f];
    } else {
        return [UIFont systemFontOfSize:14.0f];
    }
}

+ (UIFont *)userFont {
    return [UIFont boldSystemFontOfSize:13.0f];
}

+ (UIFont *)dateFont {
    return [UIFont systemFontOfSize:13.0f];
}

+ (UIFont *)subtleFont {
    return [UIFont systemFontOfSize:13.0f];
}

+ (CGFloat)heightForBodyText:(NSString *)text withWidth:(CGFloat)width indentationLevel:(int)indentationLevel {
    CGSize size = CGSizeMake(width - 16.0f, CGFLOAT_MAX);
    size.width -= (indentationLevel * 15.0f);
    
    //NSNumber *shortComments = [[NSUserDefaults standardUserDefaults] objectForKey:@"interface-short-comments"];
    
    /*if (shortComments == nil || [shortComments boolValue]) {
        // Show only three lines of text.
        CGFloat singleHeight = [[self bodyFont] lineHeight];
        CGFloat tripleHeight = singleHeight * 3;
        if (size.height > tripleHeight) size.height = tripleHeight;
    }*/
    
    return ceilf([[self formatBodyText:text] sizeWithFont:[self bodyFont] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap].height);
}

+ (CGFloat)heightForEntry:(HKComment *)comment withWidth:(CGFloat)width showReplies:(BOOL)replies indentationLevel:(int)indentationLevel {
    CGFloat height = [self heightForBodyText:[comment text] withWidth:width indentationLevel:indentationLevel] + 30.0f;
    height += 14.0f;
    return height;
}

+ (CGFloat)heightForEntry:(HKComment *)comment withWidth:(CGFloat)width showReplies:(BOOL)replies {
    return [self heightForEntry:comment withWidth:width showReplies:replies indentationLevel:0];
}

- (void)drawContentView:(CGRect)rect {
    CGRect bounds = [self bounds];
    bounds.origin.x += (comment.depth * 15.0f);
    
    int replyOffset = 0;
    if (comment.depth > 0) replyOffset = 1; 
    CGSize offsets = CGSizeMake((8.0f + replyOffset), 4.0f);
    
    NSString *user = [[comment user] name];
    NSString *date = [NSDate stringForTimeIntervalSinceCreated:[comment posted]];
    NSString *points = [comment votes] == 1 ? @"1 point" : [NSString stringWithFormat:@"%d points", [comment votes]];
    NSString *pointsAndDate = [NSString stringWithFormat:@"%@ • %@", points, date];
    NSString *body = [[self class] formatBodyText:[comment text]];
    
    if ([self isHighlighted] || [self isSelected]) [[UIColor whiteColor] set];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor blackColor] set];
    [user drawAtPoint:CGPointMake(bounds.origin.x + offsets.width, offsets.height) withFont:[[self class] userFont]];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor blackColor] set];
    CGRect bodyrect;
    bodyrect.size.height = [[self class] heightForBodyText:body withWidth:bounds.size.width indentationLevel:self.comment.depth];
    bodyrect.size.width = bounds.size.width - bounds.origin.x - offsets.width - offsets.width;
    bodyrect.origin.x = bounds.origin.x + offsets.width;
    bodyrect.origin.y = offsets.height + 19.0f;
    [body drawInRect:bodyrect withFont:[[self class] bodyFont] lineBreakMode:UILineBreakModeWordWrap | UILineBreakModeTailTruncation];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor grayColor] set];
    CGRect pointsrect;
    pointsrect.size.height = [pointsAndDate sizeWithFont:[[self class] subtleFont]].height;
    pointsrect.size.width = (bounds.size.width + bounds.origin.x) / 2 - offsets.width * 2;
    pointsrect.origin.x = bounds.origin.x + offsets.width;
    pointsrect.origin.y = bounds.size.height - offsets.height - pointsrect.size.height;
    [pointsAndDate drawInRect:pointsrect withFont:[[self class] subtleFont] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
    
    if (comment.depth > 0) {
        UIImage *replyArrow = [UIImage imageNamed:@"comment-arrow.png"];
        [replyArrow drawInRect:CGRectMake(bounds.origin.x - 5, bounds.origin.y + 6, 9, 10)];
    }
}

@end
