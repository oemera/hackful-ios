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
    
    //bodyText = [bodyText stringByRemovingHTMLTags];
    //bodyText = [bodyText stringByDecodingHTMLEntities];
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

+ (BOOL)entryShowsPoints:(HKComment *)comment {
    // Re-enable this for everyone if comment score viewing is re-enabled.
    return NO;//[comment submitter] == [[HNSession currentSession] user];
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
    //if ([self entryShowsPoints:comment] || (replies && [comment children] > 0)) height += 14.0f;
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
    //NSString *comments = @"not implemented";
    NSString *body = [[self class] formatBodyText:[comment text]];
    
    if ([self isHighlighted] || [self isSelected]) [[UIColor whiteColor] set];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor blackColor] set];
    [user drawAtPoint:CGPointMake(bounds.origin.x + offsets.width, offsets.height) withFont:[[self class] userFont]];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor lightGrayColor] set];
    CGFloat datewidth = [date sizeWithFont:[[self class] dateFont]].width;
    [date drawAtPoint:CGPointMake(bounds.size.width - datewidth - offsets.width, offsets.height) withFont:[[self class] dateFont]];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor blackColor] set];
    CGRect bodyrect;
    NSLog(@"height: %f", [[self class] heightForBodyText:body withWidth:bounds.size.width indentationLevel:self.comment.depth]);
    
    bodyrect.size.height = [[self class] heightForBodyText:body withWidth:bounds.size.width indentationLevel:self.comment.depth];
    bodyrect.size.width = bounds.size.width - bounds.origin.x - offsets.width - offsets.width;
    bodyrect.origin.x = bounds.origin.x + offsets.width;
    bodyrect.origin.y = offsets.height + 19.0f;
    [body drawInRect:bodyrect withFont:[[self class] bodyFont] lineBreakMode:UILineBreakModeWordWrap | UILineBreakModeTailTruncation];
    
    if (!([self isHighlighted] || [self isSelected])) [[UIColor grayColor] set];
    CGRect pointsrect;
    pointsrect.size.height = [points sizeWithFont:[[self class] subtleFont]].height;
    pointsrect.size.width = (bounds.size.width + bounds.origin.x) / 2 - offsets.width * 2;
    pointsrect.origin.x = bounds.origin.x + offsets.width;
    pointsrect.origin.y = bounds.size.height - offsets.height - pointsrect.size.height;
    if ([[self class] entryShowsPoints:comment])
          [points drawInRect:pointsrect withFont:[[self class] subtleFont] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
    
    if (comment.depth > 0) {
        UIImage *replyArrow = [UIImage imageNamed:@"comment-arrow.png"];
        [replyArrow drawInRect:CGRectMake(bounds.origin.x - 5, bounds.origin.y + 6, 9, 10)];
    }
    /*if (!([self isHighlighted] || [self isSelected])) [[UIColor grayColor] set];
    CGRect commentsrect;
    commentsrect.size.height = [comments sizeWithFont:[[self class] subtleFont]].height;
    commentsrect.size.width = (bounds.size.width - bounds.origin.x) / 2 - offsets.width * 2;
    commentsrect.origin.x = 100 + bounds.size.width - (bounds.size.width - bounds.origin.x) / 2 + offsets.width;
    commentsrect.origin.y = bounds.size.height - offsets.height - commentsrect.size.height;
    if (showReplies)
        [comments drawInRect:commentsrect withFont:[[self class] subtleFont] lineBreakMode:UILineBreakModeHeadTruncation alignment:UITextAlignmentRight];*/
    
}

@end
