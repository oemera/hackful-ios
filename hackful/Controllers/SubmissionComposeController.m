//
//  SubmissionComposeController.m
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

#import "SubmissionComposeController.h"
#import "AFNetworking.h"
#import "PlaceholderTextView.h"
#import "HKPost.h"
#import "HKSession.h"

@implementation SubmissionComposeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (nil != pasteboard.string) {
        NSDataDetector* detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        NSArray* matches = [detector matchesInString:pasteboard.string options:0 range:NSMakeRange(0, [pasteboard.string length])];
        if ([matches count] > 0) {            
            urlField.text = [[[matches objectAtIndex:0] URL] absoluteString];
        }
    }
}

- (BOOL)includeMultilineEditor {
    return YES;
}

- (NSString *)multilinePlaceholder {
    return @"Text";
}

- (NSString *)title {
    return @"Submit Post";
}

- (NSArray *)inputEntryCells {
    UITableViewCell *cell = [self generateTextFieldCell];
    [[cell textLabel] setText:@"Title:"];
    titleField = [self generateTextFieldForCell:cell];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [cell addSubview:titleField];
    
    UITableViewCell *cellUrl = [self generateTextFieldCell];
    [[cellUrl textLabel] setText:@"URL:"];
    urlField = [self generateTextFieldForCell:cellUrl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [cellUrl addSubview:urlField];
    
    return [NSArray arrayWithObjects:cell, cellUrl, nil];
}

- (UIResponder *)initialFirstResponder {
    return titleField;
}


- (void)performSubmission {
    if (![self ableToSubmit]) {
        [self sendFailed];
    } else {
        [HKAPI createPostWithTitle:titleField.text 
                               URL:urlField.text 
                              text:textView.text 
                          delegate:self];
    }
}

- (BOOL)ableToSubmit {
    NSURL *url = nil;
    if (urlField.text.length > 0) {
         url = [NSURL URLWithString:urlField.text];
    }
    
    return (titleField.text.length > 0) 
            && ((urlField.text.length > 0 && url != nil) || (urlField.text.length == 0))
            && (textView.text.length > 0);
}

#pragma mark - HKAPIDelegate

- (void)APICallComplete {
    [self sendComplete];
}

- (void)APICallFailed:(NSError*)error {
    [self sendFailed];
}

@end
