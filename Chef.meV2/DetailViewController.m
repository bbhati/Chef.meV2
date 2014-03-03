//
//  DetailViewController.m
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/17/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "DetailViewController.h"
#import "RecipeListViewController.h"
#import "YummlyClient.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Recipe: %@", self.recipe);
    if(self.recipe != nil) {
        [self getRecipeWithId:self.recipe.id];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popuLateView:) name:selectedRecipeNotification object:nil];
    }
	// Do any additional setup after loading the view.
    
}

-(void)popuLateView: (NSNotification *)notification{

        NSLog(@"Notification received: %@", notification);
        if(notification != nil){
            [self.recipeImage setImageWithURL:[NSURL URLWithString:self.recipe.largeImageURL]];
            self.recipeName.text = self.recipe.recipeName;
            self.sourceName.text = self.recipe.sourceDisplayName;
        }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getRecipeWithId: (NSString*)recipeId {
    NSLog(@"Reloading recipes");
    
    [[YummlyClient instance] fetchRecipeWithId:recipeId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success!!!");
        NSLog(@"%@", responseObject);
        NSDictionary* dict = (NSDictionary*) responseObject;
        Recipe* obj = [[Recipe alloc] initWithDictionary:dict];
        self.recipe = obj;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:selectedRecipeNotification
                                                            object:self];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure!!!");
        NSLog(@"%@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:selectedRecipeNotification
                                                            object:self];
        
    }];
}
@end
