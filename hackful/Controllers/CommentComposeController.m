//
//  CommentComposeController.m
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
    if ([self ableToSubmit]) {
        [HKAPI createCommentWithText:textView.text forParent:self.entry delegate:self];
    } else {
        [self sendFailed];
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
