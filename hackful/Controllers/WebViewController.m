//
//  WebViewController.m
//  hackful
//
//  Created by Ömer Avci on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (id)initWithURL:(NSURL*)url_ {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        url = url_;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView {
    [super loadView];
    
    toolbar = [[UIToolbar alloc] init];
    UIColor *color = [UIColor colorWithRed:52.0/255.0 green:80.0/255.0 blue:101.0/255.0 alpha:1.0f];
    [toolbar setTintColor:color];
    [toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    
    [toolbar sizeToFit];
    CGRect toolbarFrame = [toolbar bounds];
    toolbarFrame.origin.y = [[self view] bounds].size.height - toolbarFrame.size.height;
    [toolbar setFrame:toolbarFrame];
    [[self view] addSubview:toolbar];
    
    backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] 
                                                style:UIBarButtonItemStylePlain 
                                               target:self action:@selector(goBack)];
    
    forwardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward.png"] 
                                                   style:UIBarButtonItemStylePlain 
                                                  target:self action:@selector(goForward)];
    
    refreshItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"refresh.png"] 
                                                   style:UIBarButtonItemStylePlain 
                                                  target:self action:@selector(reload)];
    
    spacerItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                               target:nil action:NULL];
    [self updateToolbarItems];
    
    CGRect webviewFrame = [[self view] bounds];
    webviewFrame.size.height -= toolbarFrame.size.height;
    webView = [[UIWebView alloc] initWithFrame:webviewFrame];
    [webView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [webView setDelegate:self];
    [webView setScalesPageToFit:YES];
    [[self view] addSubview:webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![webView request]) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [webView loadRequest:request];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [webView setDelegate:nil];
    webView = nil;
    toolbar = nil;
    backItem = nil;
    forwardItem = nil;
    refreshItem = nil;
    spacerItem = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

# pragma mark - Browser Actions

- (void)reload {
    [webView reload];
}

- (void)stop {
    [webView stopLoading];
}

- (void)goBack {
    [webView goBack];
}

- (void)goForward {
    [webView goForward];
}

# pragma mark - Toolbar

- (void)updateToolbarItems {
    [backItem setEnabled:[webView canGoBack]];
    [forwardItem setEnabled:[webView canGoForward]];
    
    UIBarButtonItem *changableItem = nil;
    if ([webView isLoading]) changableItem = refreshItem;
    else changableItem = refreshItem;
    
    [toolbar setItems:[NSArray arrayWithObjects:spacerItem, backItem, spacerItem, 
                       spacerItem, forwardItem, spacerItem, spacerItem, spacerItem, 
                       spacerItem, spacerItem, spacerItem, spacerItem, spacerItem, 
                       spacerItem, spacerItem, changableItem, nil]];
}

# pragma mark - WebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self updateToolbarItems];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView_ {
    [self updateToolbarItems];
    [[self navigationItem] setTitle:[webView_ stringByEvaluatingJavaScriptFromString:@"document.title"]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self updateToolbarItems];
    [UIApplication sharedApplication];
}

@end
