//
//  DetailsHeaderView.m
//  newsyc
//
//  Created by Grant Paul on 3/6/11.
//  Copyright 2011 Xuzz Productions, LLC. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "DetailsHeaderView.h"
#import "HKPost.h"

@implementation DetailsHeaderView
@synthesize delegate = _delegate, post = _post;

- (id)initWithPost:(HKPost *)post_ widthWidth:(CGFloat)width {
    if ((self = [super init])) {
        CALayer *layer = [self layer];
        [layer setNeedsDisplayOnBoundsChange:YES];
        
        [self addTarget:self action:@selector(viewPressed:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        textView = [[UIView alloc] init];
        [self addSubview:textView];
        
        [self setPost:post_];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        CGRect frame;
        frame.origin = CGPointZero;
        frame.size.width = width;
        frame.size.height = [self suggestedHeightWithWidth:width];
        [self setFrame:frame];
    }
    
    return self;
}

- (BOOL)hasDestination {
    return ([post link] != nil && [[post link] length] > 0);
}

- (void)viewPressed:(DetailsHeaderView *)view withEvent:(UIEvent *)event {
    
}

+ (CGSize)offsets {
    return CGSizeMake(8.0f, 4.0f);
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [self setNeedsDisplay];
}

+ (UIFont *)titleFont {
    return [UIFont boldSystemFontOfSize:16.0f];
}

+ (UIFont *)subtleFont {
    return [UIFont systemFontOfSize:11.0f];
}

- (void)setPost:(HKPost *)post_ {
    _post = post_;
    
    [self setNeedsDisplay];
}

+ (UIImage *)disclosureImage; {
    return [UIImage imageNamed:@"disclosure.png"];
}

- (CGFloat)suggestedHeightWithWidth:(CGFloat)width {
    CGSize offsets = [[self class] offsets];
    CGFloat body = 0.0;//[[textView contentView] sizeThatFits:CGSizeMake(width - offsets.width, 0)].height;
    CGFloat disclosure = [self hasDestination] ? [[[self class] disclosureImage] size].width + offsets.width : 0.0f;
    CGFloat title = [[post title] sizeWithFont:[[self class] titleFont] constrainedToSize:CGSizeMake(width - (offsets.width * 2) - disclosure, 400.0f) lineBreakMode:UILineBreakModeWordWrap].height;
    CGFloat bodyArea = [[post text] length] > 0 ? offsets.height + body - 12.0f : 0;
    CGFloat titleArea = [[post title] length] > 0 ? offsets.height + title : 0;
    
    return titleArea + bodyArea + 30.0f + offsets.height + (titleArea > 0 && bodyArea > 0 ? 8.0f : 0);
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGSize bounds = [self bounds].size;
    CGSize offsets = [[self class] offsets];
    
    if ([self isHighlighted]) {
        [[UIColor colorWithWhite:0.85f alpha:1.0f] set];
        UIRectFill([self bounds]);
    }
    
    NSString *title = [post title];
    NSDate *date = [post posted];
    NSString *points = [post votes] == 1 ? @"1 point" : [NSString stringWithFormat:@"%d points", [post votes]];
    NSString *pointdate = [NSString stringWithFormat:@"%@ • %@", points, date];
    NSString *user = [[post user] name];
    UIImage *disclosure = [[self class] disclosureImage];
    
    CGRect titlerect;
    if ([[post title] length] > 0) {
        [[UIColor blackColor] set];
        
        titlerect.size.width = bounds.width - (offsets.width * 2) - [disclosure size].width - ([self hasDestination] ? offsets.width : 0);
        titlerect.size.height = [[post title] sizeWithFont:[[self class] titleFont] constrainedToSize:CGSizeMake(titlerect.size.width, 400.0f) lineBreakMode:UILineBreakModeWordWrap].height;
        titlerect.origin.x = offsets.width;
        titlerect.origin.y = offsets.height + 8.0f;
    } else {
        titlerect = CGRectZero;
    }
    [title drawInRect:titlerect withFont:[[self class] titleFont]];
    
    if ([self hasDestination]) {
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
        //bodyrect.size.height = [[textView contentView] sizeThatFits:CGSizeMake(bodyrect.size.width, 0)].height;
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

/*- (void)linkPushed:(DTLinkButton *)button {
	if ([delegate respondsToSelector:@selector(detailsHeaderView:selectedURL:)]) {
        [delegate detailsHeaderView:self selectedURL:[button url]];
    }
}*/

- (void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)index {
	if (index == [sheet cancelButtonIndex]) return;
	
    if (index == [sheet firstOtherButtonIndex]) {
        [[UIApplication sharedApplication] openURL:savedURL];
    } else if (index == [sheet firstOtherButtonIndex] + 1) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setURL:savedURL];
        [pasteboard setString:[savedURL absoluteString]];
    }
    
    savedURL = nil;
}

/*- (void)linkLongPressed:(UILongPressGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateBegan) {
		DTLinkButton *button = (id) [gesture view];
        [button setHighlighted:NO];
        savedURL = [button url];
		
        UIActionSheet *action = [[UIActionSheet alloc]
            initWithTitle:[[button url] absoluteString]
            delegate:self
            cancelButtonTitle:@"Cancel"
            destructiveButtonTitle:nil
            otherButtonTitles:@"Open in Safari", @"Copy Link", nil];
        [action showFromRect:[button frame] inView:[button superview] animated:YES];
    }
}*/


@end
