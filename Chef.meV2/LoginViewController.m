////
////  LoginViewController.m
////  Chef.me
////
////  Created by Kushan Shah on 2/11/14.
////  Copyright (c) 2014 Codepath. All rights reserved.
////
//
////
////  Copyright (c) 2013 Parse. All rights reserved.
//
//#import "LoginViewController.h"
//#import "UserAccountViewController.h"
//#import <Parse/Parse.h>
//
//@implementation LoginViewController
//
//
//#pragma mark - UIViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.title = @"Facebook Profile";
//    
//    // Check if user is cached and linked to Facebook, if so, bypass login
//    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
//        [self.navigationController pushViewController:[[UserAccountViewController alloc] init] animated:NO];
//    }
//}
//
//
//#pragma mark - Login mehtods
//
///* Login to facebook method */
//- (IBAction)loginWithFacebookButtonTouchHandler:(id)sender  {
//    // Set permissions required from the facebook user account
//    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
//    
//    // Login PFUser using facebook
//    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        [_activityIndicator stopAnimating]; // Hide loading indicator
//        
//        if (!user) {
//            if (!error) {
//                NSLog(@"Uh oh. The user cancelled the Facebook login.");
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
//                [alert show];
//            } else {
//                NSLog(@"Uh oh. An error occurred: %@", error);
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
//                [alert show];
//            }
//        } else if (user.isNew) {
//            NSLog(@"User with facebook signed up and logged in!");
//            [self loadFacebookProfile];
//        } else {
//            NSLog(@"User with facebook logged in!");
//            [self loadFacebookProfile];
//        }
//    }];
//    
//    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
//}
//
//- (IBAction)loginWithTwitterButtonTouchHandler:(id)sender {
//    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
//        [_activityIndicator stopAnimating]; // Hide loading indicator
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Twitter login.");
//            NSLog(@"%@", error);
//            return;
//        } else if (user.isNew) {
//            NSLog(@"User signed up and logged in with Twitter!");
//            NSLog(@"%@", user);
//        } else {
//            NSLog(@"User logged in with Twitter!");
//            NSLog(@"%@", user);
//        }
//    }];
//    
//    [_activityIndicator startAnimating]; // Show loading indicator until login is finished
//}
//
//- (void) loadFacebookProfile {
//    // Send request to Facebook
//    FBRequest *request = [FBRequest requestForMe];
//    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        // handle response
//        if (!error) {
//            // Parse the data received
//            NSDictionary *userData = (NSDictionary *)result;
//            
//            NSString *facebookID = userData[@"id"];
//            
//            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
//            
//            
//            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
//            
//            if (facebookID) {
//                userProfile[@"facebookId"] = facebookID;
//            }
//            
//            if (userData[@"name"]) {
//                userProfile[@"name"] = userData[@"name"];
//            }
//            
//            if (userData[@"location"][@"name"]) {
//                userProfile[@"location"] = userData[@"location"][@"name"];
//            }
//            
//            if (userData[@"gender"]) {
//                userProfile[@"gender"] = userData[@"gender"];
//            }
//            
//            if (userData[@"birthday"]) {
//                userProfile[@"birthday"] = userData[@"birthday"];
//            }
//            
//            if (userData[@"relationship_status"]) {
//                userProfile[@"relationship"] = userData[@"relationship_status"];
//            }
//            
//            if ([pictureURL absoluteString]) {
//                userProfile[@"pictureURL"] = [pictureURL absoluteString];
//            }
//            
//            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
//            [[PFUser currentUser] saveInBackground];
//            
//            //call my account view
//        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
//                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
//            NSLog(@"The facebook session was invalidated");
//        } else {
//            NSLog(@"Some other error: %@", error);
//        }
//    }];
//}
//
//- (void) loadTwitterProfile {
//    NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1/account/verify_credentials.json"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
//    [[PFTwitterUtils twitter] signRequest:request];
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:&response
//                                                     error:&error];
//}
//
//@end
//
