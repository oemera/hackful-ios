//
//  CommentComposeController.m
//  hackful
//
//  Created by Ömer Avci on 18.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKAPI.h"
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
        NSNumber *objectId = [NSNumber numberWithInteger:self.entry.objectId];
        NSString *commentableType = [self.entry isKindOfClass:[HKPost class]] ? @"Post" : @"Comment";
        
        NSURL *url = [NSURL URLWithString:kHKBaseAPIURL];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                HKSession.currentSession.authenticationToken, @"auth_token",
                                textView.text, @"comment[text]",
                                objectId, @"comment[commentable_id]",
                                commentableType, @"comment[commentable_type]", nil];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" 
                                                                path:kHKCommentCreateResourcePath
                                                          parameters:params];
        
        NSLog(@"text: %@ commentable_id: %@ commentable_type: %@", textView.text, objectId, commentableType);
        
        AFJSONRequestOperation *operation;
        operation =  [AFJSONRequestOperation 
                      JSONRequestOperationWithRequest:request
                      success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                          [self sendComplete];
                      }
                      failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                          NSLog(@"Couldn't create post with params: %@", params);
                          NSLog(@"error: %@", error);
                          // TODO: show HUD with error message
                          //[self sendFailed];
                      }];
        [operation start];
    }
}

- (BOOL)ableToSubmit {
    return (textView.text.length > 0);
}

@end
