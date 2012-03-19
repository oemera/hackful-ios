//
//  CommentComposeController.m
//  hackful
//
//  Created by Ömer Avci on 18.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommentComposeController.h"
#import "AFNetworking.h"
#import "PlaceholderTextView.h"
#import "HKSession.h"
#import "HKEntry.h"
#import "HKPost.h"
#import "HKComment.h"

@implementation CommentComposeController

@synthesize entry = _entry;

- (id)initWithEntry:(HKEntry*)entry_ {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (entry_ == nil) {
            NSLog(@"Entry is nil");
        }
        _entry = entry_;
    }
    return self;
}

- (BOOL)includeMultilineEditor {
    return YES;
}

- (NSString *)title {
    return @"Write Comment";
}

- (NSArray *)inputEntryCells {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    return nil;
}

- (UIResponder *)initialFirstResponder {
    return textView;
}

- (void)performSubmission {
    NSLog(@"performCreateComment");
    if (![self ableToSubmit]) {
        NSLog(@"is not able to submit");
        [self sendFailed];
    } else {
        [HKAPI createCommentWithText:textView.text forParent:self.entry delegate:self];
    }
}

- (BOOL)ableToSubmit {
    return (textView.text.length > 0);
}

#pragma mark - HKAPIDelegate

- (void)APICallComplete {
    [self sendComplete];
}

- (void)APICallFailed:(NSError*)error {
    [self sendFailed];
}

@end
