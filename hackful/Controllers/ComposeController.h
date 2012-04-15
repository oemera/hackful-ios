//
//  ComposeController.h
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

#import <UIKit/UIKit.h>

@protocol ComposeControllerDelegate;
@class PlaceholderTextView;

@interface ComposeController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate> {
    UITableView *tableView;
    NSArray *entryCells;
    PlaceholderTextView *textView;
    UIBarButtonItem *cancelItem;
    UIBarButtonItem *completeItem;
    BOOL keyboardVisible;
    id<ComposeControllerDelegate> delegate;
}

@property (nonatomic, assign) id<ComposeControllerDelegate> delegate;

- (UITableViewCell *)generateTextFieldCell;
- (UITextField *)generateTextFieldForCell:(UITableViewCell *)cell;
- (UIResponder *)initialFirstResponder;

- (void)sendComplete;
- (void)sendFailed;
- (void)performSubmission;
- (BOOL)ableToSubmit;
- (void)textDidChange:(NSNotification *)notification;

@end

@protocol ComposeControllerDelegate <NSObject>
@optional

- (void)composeControllerDidSubmit:(ComposeController *)controller;
- (void)composeControllerDidCancel:(ComposeController *)controller;

@end
