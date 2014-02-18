//
//  RecipeListViewController.h
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/16/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecipeListViewController : UITableViewController

@property (nonatomic, strong) NSString* category;
extern NSString* selectedRecipeNotification;
@end
