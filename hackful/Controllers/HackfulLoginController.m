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
    [bottomLabel setTextColor:[UIColor whiteColor]];
    usernameField.text = [HKSession emailFromPreviousSession];
}

- (BOOL)requiresPassword {
    return YES;
}

- (void)sessionDidRecieveToken:(HKSession *)session {
    [HKSession setCurrentSession:session];
    
    [self finish];
    [self succeed];
}

- (void)sessionDidRecieveFailure:(HKSession *)session {
    [self finish];
    [self fail];
}

- (NSArray *)gradientColors {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:(id) [[UIColor colorWithRed:1.0f green:0.6f blue:0.2f alpha:1.0f] CGColor]];
    [array addObject:(id) [[UIColor colorWithRed:0.4f green:0.1f blue:0.0f alpha:1.0f] CGColor]];
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
    [self dismissModalViewControllerAnimated:YES];
}

- (void)APICallFailed:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

@end
