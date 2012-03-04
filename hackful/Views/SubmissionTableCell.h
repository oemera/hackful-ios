#import "ABTableViewCell.h"

@class HKPost;
@interface SubmissionTableCell : ABTableViewCell {
    HKPost *submission;
}

@property (nonatomic, retain) HKPost *submission;

+ (CGFloat)heightForEntry:(HKPost *)post withWidth:(CGFloat)width;
- (id)initWithReuseIdentifier:(NSString *)identifier;

@end
