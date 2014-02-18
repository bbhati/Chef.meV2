//
//  ContentViewController.h
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/15/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView* upperHalf;
@property (weak, nonatomic) IBOutlet UIView* lowerHalf;
@property (weak, nonatomic) IBOutlet UIImageView* category1;
@property (weak, nonatomic) IBOutlet UIImageView* category2;
@property (weak, nonatomic) IBOutlet UIImageView* category3;
@property (weak, nonatomic) IBOutlet UIImageView* category4;
@property (weak, nonatomic) IBOutlet UIImageView* category5;
@property (weak, nonatomic) IBOutlet UIImageView* category6;
@property (weak, nonatomic) IBOutlet UIImageView* category7;
@property (weak, nonatomic) IBOutlet UIImageView* category8;

@property (weak, nonatomic) IBOutlet UILabel* label1;
@property (weak, nonatomic) IBOutlet UILabel* label2;
@property (weak, nonatomic) IBOutlet UILabel* label3;
@property (weak, nonatomic) IBOutlet UILabel* label4;
@property (weak, nonatomic) IBOutlet UILabel* label5;
@property (weak, nonatomic) IBOutlet UILabel* label6;
@property (weak, nonatomic) IBOutlet UILabel* label7;
@property (weak, nonatomic) IBOutlet UILabel* label8;


// Index of the page
@property (assign, nonatomic) NSUInteger pageIndex;

@end
