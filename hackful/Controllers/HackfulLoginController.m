//
//  HackfulLoginController.m
//  hackful
//
//  Created by Ömer Avci on 11.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HackfulLoginController.h"
#import "AFNetworking.h"
#import "HKUser.h"
#import "HKSession.h"

#define HACKFUL_API_BASE_URL @"http://192.168.1.110:3000"

@implementation HackfulLoginController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [topLabel setText:@"Hackful"];
    [topLabel setTextColor:[UIColor whiteColor]];
    [topLabel setShadowColor:[UIColor blackColor]];
    [bottomLabel setText:@"Your info is only shared with Hackful Europe."];
    [bottomLabel setTextColor:[UIColor whiteColor]];
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
    
    NSURL *url = [NSURL URLWithString:HACKFUL_API_BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            usernameField.text, @"user[email]", 
                            passwordField.text, @"user[password]", nil];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST" 
                                                            path:@"/api/v1/sessions/login"
                                                      parameters:params];
    
    AFJSONRequestOperation *operation;
    operation =  [AFJSONRequestOperation 
                  JSONRequestOperationWithRequest:request
                  success:^(NSURLRequest *req, NSHTTPURLResponse *response, id jsonObject) {
                      NSInteger userId = [[jsonObject objectForKey:@"id"] intValue];
                      NSString *username = [jsonObject objectForKey:@"name"];
                      NSString *email = [jsonObject objectForKey:@"email"];
                      NSString *authToken = [jsonObject objectForKey:@"auth_token"];
                      HKUser *user = [[HKUser alloc] initWithId:userId username:username andEmail:email];
                      
                      HKSession *session = [[HKSession alloc] initWithUser:user
                                                                     token:authToken];
                      HKSession.currentSession = session;
                      [self dismissModalViewControllerAnimated:YES];
                  }
                  failure:^(NSURLRequest *req, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
                      NSLog(@"Couldn't login user");
                      // TODO: show HUD with error message
                      [HKSession setCurrentSession:nil];
                      [self dismissModalViewControllerAnimated:YES];
                  }];
    
    [operation start];
}

@end
