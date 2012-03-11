//
//  HackfulAppDelegate.h
//  hackful
//
//  Created by Ömer Avci on 11.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NavigationController;

@interface HackfulAppDelegate : UIResponder <UIApplicationDelegate> {
    NavigationController *navigationController;
}

@property (strong, nonatomic) UIWindow *window;

- (NSURL *)applicationDocumentsDirectory;

@end
