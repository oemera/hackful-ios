//
//  HackfulLoginController.m
//  hackful
//
//  Created by Ömer Avci on 11.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HKAPI.h"
#import "HackfulLoginController.h"
#import "AFNetworking.h"
#import "HKUser.h"
#import "HKSession.h"

@implementation HackfulLoginController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [topLabel setText:@"Hackful"];
    [topLabel setTextColor:[UIColor whiteColor]];
    [topLabel setShadowColor:[UIColor blackColor]];
    [bottomLabel setText:@"Your info is only shared with Hackful Europe."];
    UIColor *color = [UIColor colorWithRed:76.0/255.0 green:86.0/255.0 blue:108.0/255.0 alpha:1.0f];
    [bottomLabel setTextColor:color];
    usernameField.text = [HKSession emailFromPreviousSession];
}

- (BOOL)requiresPassword {
    return YES;
}

- (void)sessionDidRecieveToken:(HKSession *)session {
    [self finish];
    [self succeed];
}

- (void)sessionDidRecieveFailure:(HKSession *)session {
    [self finish];
    [self fail];
}

- (NSArray *)gradientColors {
    NSMutableArray *array = [NSMutableArray array];
    UIColor *color = [UIColor colorWithRed:174.0/255.0 green:185.0/255.0 blue:194.0/255.0 alpha:1.0f];
    [array addObject:(id) [color CGColor]];
    [array addObject:(id) [color CGColor]];
    return array;
}

- (void)authenticate {
    [super authenticate];
    
    [HKAPI authenticateUserWithName:usernameField.text 
                           password:passwordField.text 
                           delegate:self];
}

#pragma mark - HKAPIDelegate

- (void)APICallComplete {
    [self finish];
    [self succeed];
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)APICallFailed:(NSError*)error {
    [self finish];
    [self fail];
    //[self dismissModalViewControllerAnimated:YES];
}

@end
