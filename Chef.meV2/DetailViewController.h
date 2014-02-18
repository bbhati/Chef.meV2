//
//  DetailViewController.h
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/17/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
//@property (weak, nonatomic) IBOutlet UITextView *description;

@property(nonatomic, strong) Recipe* recipe;
@end
