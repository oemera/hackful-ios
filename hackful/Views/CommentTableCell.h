#import "ABTableViewCell.h"

@class HKComment;
@interface CommentTableCell : ABTableViewCell {
    HKComment *comment;
    int indentationLevel;
    BOOL showReplies;
}

@property (nonatomic, retain) HKComment *comment;
@property (nonatomic, assign) int indentationLevel;
@property (nonatomic, assign) BOOL showReplies;

+ (CGFloat)heightForEntry:(HKComment *)comment withWidth:(CGFloat)width showReplies:(BOOL)replies;
+ (CGFloat)heightForEntry:(HKComment *)comment withWidth:(CGFloat)width showReplies:(BOOL)replies indentationLevel:(int)indentationLevel;

- (id)initWithReuseIdentifier:(NSString *)identifier;

@end
