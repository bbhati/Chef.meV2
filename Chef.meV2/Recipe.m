//
//  Recipe.m
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/16/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "Recipe.h"
#import "Parse/Parse.h"

@implementation Recipe

/*
 
 @property (nonatomic, strong, readonly) NSArray* images;
 @property (nonatomic, strong, readonly) NSArray* ingredientLines;
 @property (nonatomic) NSInteger numberOfServings;
 @property (nonatomic, strong, readonly) NSArray* nutritionEstimates;

 */
-(NSArray *)images {
    return [self.data valueForKey:@"images"];
}

-(NSArray *)ingredientLines {
    return [self.data valueForKey:@"ingredientLines"];
}

-(NSInteger) numberOfServings {
    return [[self.data valueForKey:@"numberOfServings"] integerValue];
}

-(NSString *)largeImageURL {
    return [self.images[0] valueForKey:@"hostedLargeUrl"];
}

- (NSString *)id {
    return [self.data valueOrNilForKeyPath:@"id"];
}

- (NSString *)image90 {
    return [self.data valueOrNilForKeyPath:@"imageUrlsBySize.90"];
}

- (NSString *)imageLarge {
    return [self.data valueOrNilForKeyPath:@"images"];
}

- (NSString *)sourceDisplayName {
    return [self.data valueOrNilForKeyPath:@"sourceDisplayName"];
}

- (NSString *)recipeName {
    NSLog(@"recipe: %@", [self.data valueOrNilForKeyPath:@"recipeName"]);
    return [self.data valueOrNilForKeyPath:@"recipeName"];
}

- (NSArray *)ingredients{
    NSLog(@"ingredients: %@", [self.data valueOrNilForKeyPath:@"ingredients"]);
    return [self.data valueOrNilForKeyPath:@"ingredients"];
    
}

- (NSInteger)rating{
    NSString* stars = [self.data valueForKey:@"rating"];
    if(stars != nil) {
        return [stars integerValue];
    }
    return 0;
}

- (NSInteger)totalTimeInSeconds{
    NSString* timeSeconds = [self.data valueForKey:@"totalTimeInSeconds"];
    if(timeSeconds != nil && timeSeconds != NULL){
        NSLog(@"time: %@", timeSeconds);
        return [timeSeconds integerValue];
    }
    return 0;
}

- (NSString*)formattedTime {
    NSUInteger h = self.totalTimeInSeconds / 3600;
    NSUInteger m = (self.totalTimeInSeconds / 60) % 60;
    NSUInteger s = self.totalTimeInSeconds % 60;
    
    NSString *formattedTime = nil;
    if(h > 0) {
        if(m > 0) {
            formattedTime = [NSString stringWithFormat:@"%uh%02um", h, m];
        } else {
            formattedTime = [NSString stringWithFormat:@"%uh", h];
        }
        
    } else if(m > 0) {
        formattedTime = [NSString stringWithFormat:@"%02um", m];
    } else {
        formattedTime = [NSString stringWithFormat:@"%02us", s];
    }
    return formattedTime;
}
- (CGFloat) salty{
    NSString* flavor = [self.data valueOrNilForKeyPath:@"flavors.salty"];
    if(flavor != nil){
        return [flavor floatValue];
    }
    return 0;

}
- (CGFloat) sour{
    NSString* flavor = [self.data valueOrNilForKeyPath:@"flavors.sour"];
    if(flavor != nil){
        return [flavor floatValue];
    }
    return 0;
    
}

- (CGFloat) bitter{
    NSString* flavor = [self.data valueOrNilForKeyPath:@"flavors.bitter"];
    if(flavor != nil){
        return [flavor floatValue];
    }
    return 0;
    
}
- (CGFloat) sweet{
    NSString* flavor = [self.data valueOrNilForKeyPath:@"flavors.sweet"];
    if(flavor != nil){
        return [flavor floatValue];
    }
    return 0;
    
}
- (CGFloat) savory{
    NSString* flavor = [self.data valueOrNilForKeyPath:@"flavors.meaty"];
    if(flavor == nil) {
        flavor = [self.data valueOrNilForKeyPath:@"flavors.savory"];
    }
    if(flavor != nil){
        return [flavor floatValue];
    }
    return 0;
    
}

- (CGFloat) spicy{
    NSString* flavor = [self.data valueOrNilForKeyPath:@"flavors.spicy"];
    if(flavor == nil) {
        flavor = [self.data valueOrNilForKeyPath:@"flavors.piquant"];
    }
    if(flavor != nil){
        return [flavor floatValue];
    }
    return 0;
    
}

+ (NSMutableArray *)recipesWithArray:(NSArray *)array {
    NSMutableArray *recipes = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [recipes addObject:[[Recipe alloc] initWithDictionary:params]];
    }
    
    return recipes;
}

+ (NSMutableArray *)recipesParseWithArray:(NSArray *)array {
    NSMutableArray *recipes = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (PFObject *params in array) {
        NSString *str = [params objectForKey:@"recipeOverview"];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
  //      NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:kNilOptions];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        [recipes addObject:[[Recipe alloc] initWithDictionary:dictionary]];
    }
    return recipes;
}
@end
