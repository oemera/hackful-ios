//
//  SubmissionComposeController.m
//  hackful
//
//  Created by Ömer Avci on 12.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKAPI.h"
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
        NSURL *url = [NSURL URLWithString:kHKBaseAPIURL];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                                HKSession.currentSession.authenticationToken, @"auth_token", 
                                urlField.text, @"post[link]", 
                                titleField.text, @"post[title]", 
                                textView.text, @"post[text]", nil];
        NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" 
                                                                path:kHKPostCreateResourcePath
                                                          parameters:params];
        
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
    NSURL *url = nil;
    if (urlField.text.length > 0) {
         url = [NSURL URLWithString:urlField.text];
    }
    
    return (titleField.text.length > 0) 
            && ((urlField.text.length > 0 && url != nil) || (urlField.text.length == 0))
            && (textView.text.length > 0);
}

@end
