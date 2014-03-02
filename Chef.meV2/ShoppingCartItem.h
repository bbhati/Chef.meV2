//
//  ShoppingCartItem.h
//  Chef.meV2
//
//  Created by Bhagyashree Shekhawat on 2/22/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestObject.h"
#import "Recipe.h"

@interface ShoppingCartItem : RestObject

@property(strong, nonatomic) NSArray* ingredients;
@property(nonatomic)NSInteger price;
@property(nonatomic)NSInteger quantity;
@property(nonatomic)NSString* recipeId;

+ (NSMutableArray *)itemWithArray:(NSArray *)array;
@end
