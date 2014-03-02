//
//  ShoppingCartItem.m
//  Chef.meV2
//
//  Created by Bhagyashree Shekhawat on 2/22/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import "ShoppingCartItem.h"

@implementation ShoppingCartItem

- (NSArray*)ingredients{
        return [self.data valueForKey:@"ingredients"];
}

-(NSInteger)quantity{
    return [[self.data valueForKey:@"quantity"] integerValue];
}

-(NSInteger)price{
    return [[self.data valueForKey:@"price"] integerValue];
}

-(NSString*)recipeId{
    return [self.data valueForKey:@"recipeId"];
}

-(Recipe*)recipeDetail {
    Recipe* recipe = [[Recipe alloc] initWithDictionary:[self.data valueForKey:@"recipeDetail"]];
    return recipe;
}

+ (NSMutableArray *)itemWithArray:(NSArray *)array {
    NSMutableArray *recipes = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [recipes addObject:[[ShoppingCartItem alloc] initWithDictionary:params]];
    }
    
    return recipes;
}

@end
