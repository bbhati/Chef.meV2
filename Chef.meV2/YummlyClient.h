//
//  YummlyClient.h
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/12/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPRequestOperationManager.h>

@interface YummlyClient : NSObject

+ (YummlyClient*) instance;
+ (NSArray *) categories;

//- (void)fetchDessertsWithSuccess:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

//- (void)fetchMainDishesWithSuccess: (NSString*)query success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

//- (void)fetchAppetizersWithSuccess: (NSString*)query success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void)fetchRecipesWithQuery: (NSString*)query success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void)fetchRecipeWithId: (NSString*)recipeId success: (void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure;

- (void)fetchRecipesWithCategory: (NSString*)category sucess: (void(^)(NSArray *objects, NSError *error)) successErrorBlock;


- (void) fetchShoppingCartWithBlock: (void(^)(NSArray *objects, NSError *error)) successErrorBlock;

- (void) getPriceForIngredient:(NSString*)name block:(void(^)(NSArray *objects, NSError *error)) successErrorBlock;

@end
