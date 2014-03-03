//
//  ShoppingCartRowCell.h
//  Chef.meV2
//
//  Created by Bhagyashree Shekhawat on 2/22/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
@interface ShoppingCartRowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *qty;
@property (weak, nonatomic) Recipe* recipe;
@end
