//
//  RecipeCell.h
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/17/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIButton *rating1;
@property (weak, nonatomic) IBOutlet UIButton *rating2;
@property (weak, nonatomic) IBOutlet UIButton *rating3;
@property (weak, nonatomic) IBOutlet UIButton *rating4;
@property (weak, nonatomic) IBOutlet UIButton *rating5;

@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *clock;

@property (weak, nonatomic) IBOutlet UILabel *flavor1;
@property (weak, nonatomic) IBOutlet UIProgressView *flavor1ratio;
@property (weak, nonatomic) IBOutlet UILabel *flavor2;
@property (weak, nonatomic) IBOutlet UIProgressView *flavor2ratio;
@property (weak, nonatomic) IBOutlet UILabel *flavor3;
@property (weak, nonatomic) IBOutlet UIProgressView *flavor3ratio;

@property (weak, nonatomic) IBOutlet UILabel *flavor4;
@property (weak, nonatomic) IBOutlet UIProgressView *flavor4ratio;
@property (weak, nonatomic) IBOutlet UILabel *flavor5;
@property (weak, nonatomic) IBOutlet UIProgressView *flavor5ratio;
@property (weak, nonatomic) IBOutlet UILabel *flavor6;
@property (weak, nonatomic) IBOutlet UIProgressView *flavor6ratio;

@property (weak, nonatomic) IBOutlet UIView *tagContainer;

- (IBAction)bookMark:(id)sender;

extern NSString * bookMarkNotification;

@end


