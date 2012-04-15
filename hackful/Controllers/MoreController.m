//
//  MoreControllerViewController.m
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

#define kEmailAddress       @"oemer.a@me.com"
#define kTwitterAccount     @"@ObviousCaptain"
#define kDeveloperWebsite   @"dailyOemer.com"

#define kHackfulHomepage    @"http://hackful.com"
#define kGithubPage         @"http://github.com/Oemera/hackful-ios"

#import "MoreController.h"
#import "SVWebViewController.h"
#import "NavigationController.h"
#import "HackfulLoginController.h"
#import "SVProgressHUD.h"
#import "HKSession.h"

@interface MoreController () {
    NSString *loginStatusLabel;
}
@end

@implementation MoreController

- (void)loadView {
    [super loadView];
    
    tableView = [[UITableView alloc] initWithFrame:[[self view] bounds] style:UITableViewStyleGrouped];
    [tableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [[self view] addSubview:tableView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[tableView bounds]];
    [backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    UIColor *color = [UIColor colorWithRed:230.0/255.0 green:233.0/255.0 blue:235.0/255.0 alpha:1.0f];
    [tableView setBackgroundColor:color];
    [tableView setBackgroundView:backgroundView];
    
    NSLog(@"loadView and loginLabel");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"More"];
    
    NSLog(@"viewDidLoad and loginLabel");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    loginStatusLabel = [HKSession isAnonymous] ? @"Login" : @"Logout";
    [tableView reloadData];
    
    NSLog(@"viewWillAppear and changed loginLabel");
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 4;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return 0;
        case 1: return 3;
        case 2: return 2;
        case 3: return 1;
        default: return 0;
    }
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    if ([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            [[cell textLabel] setText:kEmailAddress];
        } else if ([indexPath row] == 1) {
            [[cell textLabel] setText:kTwitterAccount];
        } else if ([indexPath row] == 2) {
            [[cell textLabel] setText:kDeveloperWebsite];
        }
    } else if ([indexPath section] == 2) {
        if ([indexPath row] == 0) {
            [[cell textLabel] setText:@"Hackful Europe"];
        } else if ([indexPath row] == 1) {
            [[cell textLabel] setText:@"Github Page"];
        }
    } else if ([indexPath section] == 3) {
        if ([indexPath row] == 0) {
            [[cell textLabel] setText:loginStatusLabel];
        } 
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Contact";
    } else if (section == 2) {
        return @"Other";
    } else if (section == 3) {
        return @"Hackful Account";
    } 
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return [NSString stringWithFormat:@"Hackful for iOS version %@\nCreated by Ömer Avci\n\nIf you have feature requests or just want to say thank you, feel free to contact me.\n\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *controller = nil;
    
    if ([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            if ([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *composeController = [[MFMailComposeViewController alloc] init];
                [composeController setMailComposeDelegate:self];
                [composeController setToRecipients:[NSArray arrayWithObject:kEmailAddress]];
                
                [self presentModalViewController:composeController animated:YES];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Can't send mails!" duration:1.2];
                [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            }
            return;
        } else if ([indexPath row] == 1) {
            controller = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://twitter.com/obviouscaptain"]];
        } else if ([indexPath row] == 2) {
            controller = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://dailyoemer.com"]];
        }
    } else if ([indexPath section] == 2) {
        if ([indexPath row] == 0) {
            controller = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:kHackfulHomepage]];
        } else if ([indexPath row] == 1) {
            controller = [[SVWebViewController alloc] initWithURL:[NSURL URLWithString:kGithubPage]];
        }
    } else if ([indexPath section] == 3) {
        if ([indexPath row] == 0) {
            if (![HKSession isAnonymous]) {
                // Logout
                [HKAPI logoutCurrentSessionWithDelegate:self];
                [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            } else {
                // Login
                HackfulLoginController *loginController = [[HackfulLoginController alloc] init];
                [loginController setDelegate:self];
                NavigationController *navigation = [[NavigationController alloc] initWithRootViewController:loginController];
                [self presentModalViewController:navigation animated:YES];
            }
            
        }
    }
    
    if (controller != nil) [[self navigationController] pushViewController:controller animated:YES];
}

#pragma mark - LoginControllerDelegate

- (void)loginControllerDidLogin:(LoginController *)controller {
    [self dismissModalViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    loginStatusLabel = [HKSession isAnonymous] ? @"Login" : @"Logout";
    [tableView reloadData];
}

- (void)loginControllerDidCancel:(LoginController *)controller {
    [self dismissModalViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - MailDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - HKAPIDelegate

- (void)APICallComplete {
    loginStatusLabel = [HKSession isAnonymous] ? @"Login" : @"Logout";
    [tableView reloadData];
}

- (void)APICallFailed:(NSError*)error {
    loginStatusLabel = [HKSession isAnonymous] ? @"Login" : @"Logout";
    [tableView reloadData];
}

@end
