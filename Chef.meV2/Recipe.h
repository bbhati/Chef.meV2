//
//  Recipe.h
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/16/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "RestObject.h"

@interface Recipe : RestObject
+ (NSMutableArray *)recipesWithArray:(NSArray *)array;
+ (NSMutableArray *)recipesParseWithArray:(NSArray *)array;
@property (nonatomic, strong, readonly) NSString* id;
@property (nonatomic, strong, readonly) NSDictionary* imageUrlsBySize;
@property (nonatomic, strong, readonly) NSArray* ingredients;
@property (nonatomic, readonly) NSInteger rating;
@property (nonatomic, strong, readonly) NSString* recipeName;
@property (nonatomic, strong, readonly) NSArray* smallImageUrls;
@property (nonatomic, readonly) NSInteger totalTimeInSeconds;
@property (nonatomic, strong, readonly) NSString* sourceDisplayName;
@property (nonatomic, strong, readonly) NSString* sourceRecipeUrl;
//from detailed view
@property (nonatomic, strong, readonly) NSArray* images;
@property (nonatomic, strong, readonly) NSArray* ingredientLines;
@property (nonatomic) NSInteger numberOfServings;
@property (nonatomic, strong, readonly) NSArray* nutritionEstimates;
-(NSString *)largeImageURL;

- (NSString*)formattedTime;
- (NSString *)image90;
- (CGFloat) salty;
- (CGFloat) sour;
- (CGFloat) sweet;
- (CGFloat) spicy;
- (CGFloat) bitter;
- (CGFloat) savory;

@end
