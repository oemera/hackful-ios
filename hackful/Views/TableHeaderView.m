//
//  TableHeaderView.m
//  hackful
//
//  Created by Ömer Avci on 14.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableHeaderView.h"
#import "NSDate+TimeAgo.h"
#import "HKPost.h"

@implementation TableHeaderView

- (id)initWithPost:(HKPost *)post_ andWidth:(int)width_ {
    self = [super init];
    if (self) {
        post = post_;
        
        //[self addTarget:self action:@selector(viewPressed:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        textView = [[UIView alloc] init];
        [self addSubview:textView];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        CGRect frame;
        frame.origin = CGPointZero;
        frame.size.width = width_;
        frame.size.height = [self suggestedHeightWithWidth:width_];
        [self setFrame:frame];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize bounds = [self bounds].size;
    CGSize offsets = CGSizeMake(8.0f, 4.0f);
    
    NSString *title = post.title;
    NSString *date = [NSDate stringForTimeIntervalSinceCreated:post.posted];
    NSString *points = post.votes == 1 ? @"1 point" : [NSString stringWithFormat:@"%d points", post.votes];
    NSString *pointdate = [NSString stringWithFormat:@"%@ • %@", points, date];;
    NSString *user = post.user.name;
    UIImage *disclosure = [[self class] disclosureImage];
    
    CGRect titlerect;
    if ([[post title] length] > 0) {
        [[UIColor blackColor] set];
        
        titlerect.size.width = bounds.width - (offsets.width * 2) - [disclosure size].width - ([self hasURL] ? offsets.width : 0);
        titlerect.size.height = [[post title] sizeWithFont:[[self class] titleFont] constrainedToSize:CGSizeMake(titlerect.size.width, 400.0f) lineBreakMode:UILineBreakModeWordWrap].height;
        titlerect.origin.x = offsets.width;
        titlerect.origin.y = offsets.height + 8.0f;
    } else {
        titlerect = CGRectZero;
    }
    [title drawInRect:titlerect withFont:[[self class] titleFont]];
    
    if ([self hasURL]) {
        CGRect disclosurerect;
        disclosurerect.size = [disclosure size];
        disclosurerect.origin.x = bounds.width - offsets.width - disclosurerect.size.width;
        disclosurerect.origin.y = titlerect.origin.y + (titlerect.size.height / 2) - (disclosurerect.size.height / 2);
        [disclosure drawInRect:disclosurerect];
    }
    
    if ([[post text] length] > 0) {
        CGRect bodyrect;
        bodyrect.origin.y = titlerect.origin.y + titlerect.size.height + offsets.height;
        bodyrect.origin.x = offsets.width / 2;
        bodyrect.size.width = bounds.width - offsets.width;
        bodyrect.size.height = [textView sizeThatFits:CGSizeMake(bodyrect.size.width, 0)].height;
        [textView setFrame:bodyrect];
    } else {
        [textView setFrame:CGRectZero];
    }
    
    [[UIColor grayColor] set];
    CGRect pointsrect;
    pointsrect.size.width = bounds.width / 2 - (offsets.width * 2);
    pointsrect.size.height = [pointdate sizeWithFont:[[self class] subtleFont]].height;
    pointsrect.origin.x = offsets.width;
    pointsrect.origin.y = bounds.height - offsets.height - 2.0f - pointsrect.size.height;
    [pointdate drawInRect:pointsrect withFont:[[self class] subtleFont] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft];
    
    [[UIColor darkGrayColor] set];
    CGRect userrect;
    userrect.size.width = bounds.width / 2 - (offsets.width * 2);
    userrect.size.height = [user sizeWithFont:[[self class] subtleFont]].height;
    userrect.origin.x = bounds.width / 2 + offsets.width;
    userrect.origin.y = bounds.height - offsets.height - 2.0f - userrect.size.height;
    [user drawInRect:userrect withFont:[[self class] subtleFont] lineBreakMode:UILineBreakModeHeadTruncation alignment:UITextAlignmentRight];
}

- (BOOL)hasURL {
    return (post.link != nil && ![post.link isEqualToString:@""]);
}
                             
- (CGFloat)suggestedHeightWithWidth:(CGFloat)width {
    CGSize offsets = [[self class] offsets];
    CGFloat body = [textView sizeThatFits:CGSizeMake(width - offsets.width, 0)].height;
    CGFloat disclosure = [self hasURL] ? [[[self class] disclosureImage] size].width + offsets.width : 0.0f;
    CGFloat title = [[post title] sizeWithFont:[[self class] titleFont] constrainedToSize:CGSizeMake(width - (offsets.width * 2) - disclosure, 400.0f) lineBreakMode:UILineBreakModeWordWrap].height;
    CGFloat bodyArea = [[post text] length] > 0 ? offsets.height + body - 12.0f : 0;
    CGFloat titleArea = [[post title] length] > 0 ? offsets.height + title : 0;
    
    return titleArea + bodyArea + 30.0f + offsets.height + (titleArea > 0 && bodyArea > 0 ? 8.0f : 0);
}
     
#pragma mark - Style Attributes
     
+ (CGSize)offsets {
    return CGSizeMake(8.0f, 4.0f);
}
 
+ (UIFont *)titleFont {
    return [UIFont boldSystemFontOfSize:16.0f];
}
 
+ (UIFont *)subtleFont {
    return [UIFont systemFontOfSize:11.0f];
}
     
+ (UIImage *)disclosureImage; {
    return [UIImage imageNamed:@"disclosure.png"];
}

@end
