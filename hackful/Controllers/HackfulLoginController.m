//
//  HackfulLoginController.m
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
