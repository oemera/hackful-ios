//
//  ComposeController.m
//  hackful
//
//  Created by Ömer Avci on 12.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ComposeController.h"
#import "PlaceholderTextView.h"
#import "SVProgressHUD.h"

@implementation ComposeController
@synthesize delegate = _delegate;

- (id)init {
    self = [super init];
    return self;
}

- (void)close {
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)hasText {
    return [[textView text] length] > 0;
}

- (void)_cancel {
    [self close];
    
    if ([self.delegate respondsToSelector:@selector(composeControllerDidCancel:)]) {
        [self.delegate composeControllerDidCancel:self];
    }
}

- (void)actionSheet:(UIActionSheet *)sheet clickedButtonAtIndex:(NSInteger)index {
    if (index == [sheet cancelButtonIndex]) return;
    [self _cancel];
}

- (void)cancel {
    if (![self hasText]) {
        [self _cancel];
    } else {
        UIActionSheet *sheet = [[UIActionSheet alloc] init];
        [sheet addButtonWithTitle:@"Discard"];
        [sheet addButtonWithTitle:@"Cancel"];
        [sheet setDestructiveButtonIndex:0];
        [sheet setCancelButtonIndex:1];
        [sheet setDelegate:self];
        [sheet showInView:[[self view] window]];
    }
}

- (void)sendComplete {
    [self close];
    
    if ([self.delegate respondsToSelector:@selector(composeControllerDidSubmit:)])
        [self.delegate composeControllerDidSubmit:self];
}

- (void)sendFailed {
    [[self navigationItem] setRightBarButtonItem:completeItem];
    
    [SVProgressHUD showErrorWithStatus:@"Error Posting" duration:1.2];
}

- (void)performSubmission {
    // Overridden in subclasses.
}

- (void)send {
    // TODO: show loading item instead send-button
    // [[self navigationItem] setRightBarButtonItem:loadingItem];
    [self performSubmission];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [entryCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [entryCells objectAtIndex:[indexPath row]];
}

- (UITableViewCell *)generateTextFieldCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    CGRect cellFrame = [cell frame];
    cellFrame.size.width = 320.0f;
    [cell setFrame:cellFrame];
    [[cell textLabel] setTextColor:[UIColor darkGrayColor]];
    [[cell textLabel] setFont:[UIFont systemFontOfSize:16.0f]];
    return cell;
}

- (UITextField *)generateTextFieldForCell:(UITableViewCell *)cell {
    UITextField *field = [[UITextField alloc] initWithFrame:CGRectMake(0, 11, 295, 30)];
    [field setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [field setAdjustsFontSizeToFitWidth:YES];
    [field setTextColor:[UIColor blackColor]];
    [field setDelegate:self];
    [field setBackgroundColor:[UIColor whiteColor]];
    [field setAutocorrectionType:UITextAutocorrectionTypeNo];
    [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [field setTextAlignment:UITextAlignmentLeft];
    [field setEnabled:YES];
    
    CGSize label = [[[cell textLabel] text] sizeWithFont:[[cell textLabel] font]];
    CGRect frame = [field frame];
    frame.origin.x = 10.0f + label.width + 10.0f;
    frame.size.width -= label.width + 10.0f;
    [field setFrame:frame];
    
    return field;
}

- (UITableViewCell *)entryInputCellWithTitle:(NSString *)title {
    UITableViewCell *cell = [self generateTextFieldCell];
    [[cell textLabel] setText:title];
    UITextField *field = [self generateTextFieldForCell:cell];
    [cell addSubview:field];
    return cell;
}

- (BOOL)includeMultilineEditor {
    return YES;
}

- (NSString *)multilinePlaceholder {
    return nil;
}

- (NSArray *)inputEntryCells {
    return [NSArray array];
}

- (void)scrollToBottom {
    [tableView setContentOffset:CGPointMake(0, [tableView contentSize].height - [tableView bounds].size.height) animated:NO];
}

- (void)updateTextViewHeight {
    UITableViewCell *last = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:([entryCells count] - 1) inSection:0]];
    CGFloat offset = [last frame].origin.y + [last bounds].size.height;
    CGFloat minimum = [tableView bounds].size.height - offset;
    
    CGRect frame = [textView frame];
    frame.size.height = [textView contentSize].height;
    if (frame.size.height < minimum) frame.size.height = minimum;
    [textView setFrame:frame];
}

- (void)textDidChange:(NSNotification *)notification {
    [completeItem setEnabled:[self ableToSubmit]];
}

- (void)textViewDidChange:(UITextView *)textView_ {
    [self updateTextViewHeight];
    
    [completeItem setEnabled:[self ableToSubmit]];
    
    // Since our UITextView isn't managing it's own scrolling,
    // it doesn't know to scroll if you are typing at the end.
    // Instead, we need to scroll the table view ourself.
    NSRange selected = [textView selectedRange];
    if (selected.location == [[textView text] length]) {
        // XXX: find out why this needs to be done on the next runloop cycle to work
        [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.0f];
        [self scrollToBottom];
    }
    
    if ([self includeMultilineEditor]) [tableView setTableFooterView:textView];
}

- (BOOL)ableToSubmit {
    return NO;
}

- (void)loadView {
    [super loadView];
    
    // Match background color in case the keyboard animation is
    // slightly off, and you would otherwise see an ugly black
    // background behind the keyboard.
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    entryCells = [self inputEntryCells];
    
    textView = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(0, 0, [[self view] bounds].size.width, 0)];
    [textView setDelegate:self];
    [textView setScrollEnabled:NO];
    [textView setEditable:YES];
    [textView setPlaceholder:[self multilinePlaceholder]];
    [textView setFont:[UIFont systemFontOfSize:16.0f]];
    
    tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStylePlain];
    [tableView setAllowsSelection:NO];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    if ([self includeMultilineEditor]) [tableView setTableFooterView:textView];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self view] addSubview:tableView];
    
    completeItem = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    [completeItem setEnabled:NO];
    cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    //loadingItem = [[ActivityIndicatorItem alloc] initWithSize:kActivityIndicatorItemStandardSize];
    
    // Make sure that the text view's height is setup properly.
    // (Reloading is needed to force the cells to be initialized.)
    [tableView reloadData];
    [self updateTextViewHeight];
}

- (NSString *)title {
    return @"Compose";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:[[self view] window]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:[[self view] window]];
    
    [[self navigationItem] setRightBarButtonItem:completeItem];
    [[self navigationItem] setLeftBarButtonItem:cancelItem];
    
    [self setTitle:[self title]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:[[self view] window]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:[[self view] window]];
    
    [[self navigationItem] setLeftBarButtonItem:nil];
    [[self navigationItem] setRightBarButtonItem:nil];
    
    tableView = nil;
    cancelItem = nil;
    completeItem = nil;
    entryCells = nil;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!keyboardVisible) return;
    
    NSDictionary *info = [notification userInfo];
    NSValue *boundsValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
    
    CGRect frame = [tableView frame];
    if (UIInterfaceOrientationIsPortrait([self interfaceOrientation])) {
        frame.size.height += keyboardSize.height;
    } else {
        frame.size.height += keyboardSize.width;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDuration:[duration floatValue]];
    [tableView setFrame:frame];
    [UIView commitAnimations];
    
    keyboardVisible = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (keyboardVisible) return;
    
    NSDictionary *info = [notification userInfo];
    NSValue *boundsValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSNumber *curve = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    CGSize keyboardSize = [boundsValue CGRectValue].size;
    
    CGRect frame = [tableView frame];
    if (UIInterfaceOrientationIsPortrait([self interfaceOrientation])) {
        frame.size.height -= keyboardSize.height;
    } else {
        frame.size.height -= keyboardSize.width;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationCurve:[curve intValue]];
    [UIView setAnimationDuration:[duration floatValue]];
    [tableView setFrame:frame];
    [UIView commitAnimations];
    
    keyboardVisible = YES;
}

- (UIResponder *)initialFirstResponder {
    return nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    [[self initialFirstResponder] becomeFirstResponder];
}

@end
