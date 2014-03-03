//
//  RecipeListViewController.m
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/16/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "RecipeListViewController.h"
#import "YummlyClient.h"
#import "Recipe.h"
#import <objc/runtime.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "Utilities.h"
#import "RecipeCell.h"
#import "DetailViewController.h"
#import "IngredientsViewController.h"
#import "StepsViewController.h"
#import "MHTabBarController.h"

@interface RecipeListViewController ()
@property (nonatomic, strong) NSMutableArray* recipes;
@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic) BOOL downloadedImages;
@property (nonatomic, strong) RestObject* currRecipe;

@end

@implementation RecipeListViewController
NSString* selectedRecipeNotification = @"SelectedRecipeNotification";

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.recipes = [[NSMutableArray alloc] init];
        self.images = [[NSMutableArray alloc] init];
        [self.tableView registerNib:[UINib nibWithNibName:@"RecipeListCell" bundle:nil] forCellReuseIdentifier:@"RecipeListCell"];
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self navigationController] setToolbarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bookMarkRequestReceived:) name:bookMarkNotification object:nil];
}

- (void)bookMarkRequestReceived:(NSNotification *)notification
{
	NSLog(@"Notification received: %@", notification);
    if(notification != nil){
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recipes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecipeListCell";
    RecipeCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Recipe* recipe = self.recipes[indexPath.row];
    objc_setAssociatedObject(cell, "recipe", recipe, OBJC_ASSOCIATION_RETAIN);

    NSLog(@"images count %d", self.images.count);
    NSLog(@"index count %d", indexPath.row);
    if(self.images.count > indexPath.row) {
        [cell.photo setImage:[Utilities imageByScalingAndCroppingForSize:(CGSize)CGSizeMake(90,90) source:self.images[indexPath.row]]];
    }
 
    NSInteger rating = recipe.rating;

    UIColor * color = [UIColor colorWithRed:252.0/255.0 green:194.0/255.0 blue:0 alpha:1.0];
    UIColor* white = [UIColor whiteColor];
    UIImage* star = [cell.rating1 imageForState:UIControlStateNormal];
    if(rating > 0){
        [cell.rating1 setImage:[Utilities maskWithColor:color image:star] forState:UIControlStateNormal];
    }
    else {
        [cell.rating1 setImage:[Utilities maskWithColor:white image:star] forState:UIControlStateNormal];
    }
    if(rating > 1) {
        [cell.rating2 setImage:[Utilities maskWithColor:color image:star] forState:UIControlStateNormal];
    } else {
        [cell.rating2 setImage:[Utilities maskWithColor:white image:star] forState:UIControlStateNormal];
    }
    if(rating > 2) {
        [cell.rating3 setImage:[Utilities maskWithColor:color image:star] forState:UIControlStateNormal];
    } else {
         [cell.rating3 setImage:[Utilities maskWithColor:white image:star] forState:UIControlStateNormal];
    }
    if(rating > 3) {
        [cell.rating4 setImage:[Utilities maskWithColor:color image:star] forState:UIControlStateNormal];
    } else{
        [cell.rating4 setImage:[Utilities maskWithColor:white image:star] forState:UIControlStateNormal];
    }
    if(rating > 4) {
        [cell.rating5 setImage:[Utilities maskWithColor:color image:star] forState:UIControlStateNormal];
    } else {
        [cell.rating5 setImage:[Utilities maskWithColor:white image:star] forState:UIControlStateNormal];
    }
    
    cell.title.text = recipe.recipeName;
    UIColor* progress = [UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    
    UIImage* clock = [cell.clock imageForState:UIControlStateNormal];

    [cell.clock setImage:[Utilities maskWithColor:progress image:clock] forState:UIControlStateNormal];
    
    cell.time.text = recipe.formattedTime;
    
    [cell.flavor1ratio setProgressTintColor:progress];
    [cell.flavor2ratio setProgressTintColor:progress];
    [cell.flavor3ratio setProgressTintColor:progress];
    [cell.flavor4ratio setProgressTintColor:progress];
    [cell.flavor5ratio setProgressTintColor:progress];
    [cell.flavor6ratio setProgressTintColor:progress];
    
    [cell.flavor1ratio setProgress:recipe.salty];
    [cell.flavor2ratio setProgress:recipe.savory];
    [cell.flavor3ratio setProgress:recipe.sour];
    [cell.flavor4ratio setProgress:recipe.spicy];
    [cell.flavor5ratio setProgress:recipe.bitter];
    [cell.flavor6ratio setProgress:recipe.sweet];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create the next view controller.
   // UITabBarController* outerTabBarController = [[UITabBarController alloc] init];
    MHTabBarController * tabBarController =[[MHTabBarController alloc] init];
    DetailViewController* detailViewController = [[DetailViewController alloc] init];
    
    Recipe* recipe = [self.recipes objectAtIndex:indexPath.row];
    detailViewController.recipe = recipe;
    detailViewController.tabBarItem.title = @"Details";
    
    //detailViewController.tabBarItem.image = [UIImage imageNamed:@"star.png"];

    IngredientsViewController* ingVC = [[IngredientsViewController alloc] init];
    ingVC.recipe = recipe;
    ingVC.tabBarItem.title = @"Ingredients";
    
    //ingVC.tabBarItem.image = [UIImage imageNamed:@"star.png"];

    
    
    StepsViewController* stepsVC =[[StepsViewController alloc] init];
    stepsVC.recipe = recipe;
    stepsVC.tabBarItem.title = @"Steps";
    
    NSArray* controllers = [NSArray arrayWithObjects:detailViewController, ingVC, stepsVC, nil];
    tabBarController.viewControllers = controllers;
    
    [self.navigationController pushViewController:tabBarController animated:YES];

}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void) reload {
    NSLog(@"Reloading recipes");
    
    [[YummlyClient instance] fetchRecipesWithQuery:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success!!!");
        NSLog(@"%@", responseObject);
        NSDictionary* dict = (NSDictionary*) responseObject;
        self.recipes = [Recipe recipesWithArray:[dict objectForKey:@"matches"]];
        //download images

        for(int index =0 ; index < self.recipes.count; index++) {
//            NSInteger index = [self.recipes indexOfObject:recipe];
            Recipe* recipe = [self.recipes objectAtIndex:index];
            UITableViewCell* dummy = [[UITableViewCell alloc] init];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: recipe.image90]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                               timeoutInterval:10000];
            [request setHTTPMethod:@"GET"];

                [dummy.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    ////resize
            
                    [self.images addObject:image];
                    if(index == self.recipes.count -1) {
                        self.downloadedImages = YES;
                        [self.tableView reloadData];
                    }
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"Failed to load image");
                    if(index == self.recipes.count -1) {
                        self.downloadedImages = YES;
                        [self.tableView reloadData];
                    }
                }];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure!!!");
        NSLog(@"%@", error);
        
    }];
}

@end
