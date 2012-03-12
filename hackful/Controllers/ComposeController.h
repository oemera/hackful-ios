//
//  ComposeController.h
//  hackful
//
//  Created by Ömer Avci on 12.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
