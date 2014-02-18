//
//  LoginViewController.h
//  Chef.me
//
//  Created by Kushan Shah on 2/11/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)loginWithFacebookButtonTouchHandler:(id)sender;
- (IBAction)loginWithTwitterButtonTouchHandler:(id)sender;

@end
