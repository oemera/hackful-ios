//
//  WebViewController.h
//  hackful
//
//  Created by Ömer Avci on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate> {
    NSURL *url;
    UIWebView *webView;
    UIToolbar *toolbar;
    UIBarButtonItem *backItem;
    UIBarButtonItem *forwardItem;
    UIBarButtonItem *refreshItem;
    UIBarButtonItem *spacerItem;
}

- (id)initWithURL:(NSURL*)url_;

@end
