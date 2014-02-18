//
//  MainViewController.h
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/12/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YummlyClient.h"
#import "MPFlipViewController.h"

@interface MainViewController : UIViewController <MPFlipViewControllerDataSource, MPFlipViewControllerDelegate>

@property (strong, nonatomic) MPFlipViewController *flipViewController;
@property (weak, nonatomic) IBOutlet UIView * mainview;
@end
