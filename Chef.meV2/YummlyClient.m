//
//  YummlyClient.m
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/12/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//
/*
 Request samples
http://www.yummly.com/recipes?q=breakfast

 http://www.yummly.com/recipes?q=lettuce%2C+tomatoes&noUserSettings=true&allowedIngredient=fresh+lemon+juice&allowedIngredient=romaine+lettuce&excludedIngredient=&maxTotalTimeInSeconds=Any+time&flavor.salty=+&flavor.savory=+&flavor.sour=+&flavor.bitter=+&flavor.sweet=+&flavor.spicy=+&nutrition.cholesterol=+&nutrition.fat=+&nutrition.calories=+&nutrition.carbs=+&imagesOnly=false&blogsOnly=false&sortBy=relevance
 
 http://www.yummly.com/api/keywords?q=brea&yv=19010594-dbe4-496f-9e93-4e19d5a3544e
 
 http://www.yummly.com/browse/seasonal
 Chef.meV2/Chef.meV2.xcworkspace
Popular now http://www.yummly.com/browse/popular-now
filters: ingredient, cuisine, course, holiday, time, nutrition, and taste restrictions
 
 Categories: Main Dishes, Desserts, Side Dishes, Lunch and Snacks, Appetizers, Salads, Breads, Breakfast and Brunch, Soups, Beverages, Condiments and Sauces, Cocktails, Romantic,Cakes, Gluten free,
 
 American, Italian, Asian, Mexican, Southern & Soul Food, French, Southwestern, Barbecue, Indian, Chinese, Cajun & Creole, English, Mediterranean, Greek, Spanish, German, Thai, Moroccan, Irish, Japanese, Cuban, Hawaiin, Swedish, Hungarian, Portugese
 */

#import "YummlyClient.h"
#import "Parse/Parse.h"
#import "Utilities.h"

#define YUMMLY_BASE_URL @"http://api.yummly.com/v1/api"
//#define BIGOVEN_BASE_URL @"http://api.bigoven.com/recipes"
#define KEYWORDS_SEARCH @"http://www.yummly.com/api/keywords" 

#define APP_ID @"c477e0ed"
#define APP_KEY @"331036844c49afdc4f414ca8abd56f6b"

#define PARSE_APP_ID @"G0eP59QGmBZWO2v4klysid1aDMvkVcMwmoHbAd3U"
#define PARSE_APP_KEY @"JYQQiB2CVxXS0olE122ZQbpnb00GmCJEO4nucrOI"


@implementation YummlyClient

+ (YummlyClient *)instance {
    static dispatch_once_t once;
    static YummlyClient *instance;
    
    dispatch_once(&once, ^{
        instance = [[YummlyClient alloc] init];
    });
    
    return instance;
}

+ (NSArray* ) categories {
    NSArray *categories = [NSArray arrayWithObjects:@"Main Dishes", @"Dessert", @"Side Dishes", @"Lunch and Snacks", @"Appetizers", @"Salads", @"Breads", @"Breakfast and Brunch", @"Soups", @"Beverages", @"Condiments and Sauces", @"Cocktails", @"American" ,@"French", @"Italian", @"Chinese", @"Mexican", @"Cakes", @"High Protein", @"Vegan", @"Low Carb", @"Gluten Free", nil];
    return categories;
    
}
- (void)fetchRecipesWithQuery: (NSString*)query success:(void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSMutableString *url = [NSMutableString stringWithString:YUMMLY_BASE_URL];
    NSString* recipesSearch = [NSString stringWithFormat:@"/recipes?_app_id=%@&_app_key=%@&q=%@&allowedCourse[]=course^course-Desserts&maxResult=10&start=1&maxTotalTimeInSeconds=864000", APP_ID, APP_KEY, query];

    [url appendString:recipesSearch];

    NSLog(@"URL: %@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    [manager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:success failure:failure];
}

- (void)fetchRecipeWithId: (NSString*)recipeId success: (void(^)(AFHTTPRequestOperation *operation, id responseObject))success failure: (void(^)(AFHTTPRequestOperation *operation, NSError *error)) failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *url = [NSMutableString stringWithString:YUMMLY_BASE_URL];
    NSString* recipeGet = [NSString stringWithFormat:@"/recipe/%@?_app_id=%@&_app_key=%@", recipeId, APP_ID, APP_KEY];
    
    [url appendString:recipeGet];
    NSLog(@"URL: %@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    [manager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:success failure:failure];
}

- (void) fetchShoppingCartWithBlock: (void(^)(NSArray *objects, NSError *error)) successErrorBlock  {
    
    [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_APP_KEY];
    
        PFQuery *query = [PFQuery queryWithClassName:@"ShoppingCart"];
        NSString* userId = [Utilities getUserId];
        [query whereKey:@"userId" equalTo:userId];
    
        [query findObjectsInBackgroundWithBlock:successErrorBlock];
}
@end
