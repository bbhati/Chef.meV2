//
//  RecipeCell.m
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/17/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "RecipeCell.h"
@interface RecipeCell()

@end
@implementation RecipeCell

NSString* bookMarkNotification = @"BookMarkNotification";

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bookMark:(id)sender {
    //add notification for bookmark
    [[NSNotificationCenter defaultCenter] postNotificationName:bookMarkNotification
                                                        object:self];
}
@end
