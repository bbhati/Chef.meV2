//
//  ShoppingCartController.m
//  Chef.meV2
//
//  Created by Bhagyashree Shekhawat on 2/22/14.
//  Copyright (c) 2014 Bhagyashree Shekhawat. All rights reserved.
//

#import "ShoppingCartController.h"
#import "ShoppingCartRowCell.h"
#import "ShoppingCartItem.h"
#import "YummlyClient.h"
#import "Parse/Parse.h"
#import "Utilities.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ShoppingCartController ()
@property(nonatomic, strong) NSMutableArray* recipes;
@property(nonatomic, strong) NSMutableArray* cartItems;
@property (nonatomic, strong) NSMutableArray* images;
@property (nonatomic) int price;
//@property (weak, nonatomic) IBOutlet UITableView *table;


@end
//ShoppingCartRowCell
@implementation ShoppingCartController

- (id)init
{
    self = [super init];
    if (self) {
        //read recipes from parse
        self.cartItems = [[NSMutableArray alloc] init];
//        self.recipes = [[NSUserDefaults standardUserDefaults] objectForKey:@"shoppingCart"];
        self.images = [[NSMutableArray alloc] init];
       // self.navigationItem.rightBarButtonItem = self.editButtonItem;
        [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCartRowCell" bundle:nil] forCellReuseIdentifier:@"ShoppingCartRowCell"];
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
   }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    //get from parse
    
    [self reload];
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
    // Return the number of rows in the section.
    return [self.cartItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShoppingCartRowCell";
    //UITableViewCell* mainCell = [[UITableViewCell alloc] init];
    ShoppingCartRowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    cell.recipe = [self.recipes objectAtIndex:indexPath.row];
    //NSString * current = [self.recipes objectAtIndex:indexPath.row];
    //Get from Parse

    ShoppingCartItem* item = self.cartItems[indexPath.row];
    
    if(self.images.count > indexPath.row) {
        //[cell.photo setImage:[UIImage imageNamed:@"image1.jpg"]];
        [cell.photo setImage:[Utilities imageByScalingAndCroppingForSize:(CGSize)CGSizeMake(90,90) source:self.images[indexPath.row]]];
    }
    Recipe* recipe= [[Recipe alloc] initWithDictionary: item.recipeDetail];
    cell.name.text = recipe.recipeName;
    
    cell.qty.text = [NSString stringWithFormat:@"Quantity %d", item.quantity];
    //get image from saved recipeDetail

  //  cell.price.text = @"50$";


    
    return cell;
    
    //return mainCell;
}


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

/*
 
 */

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.

    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //remove from parse
        NSLog(@"Trying to delete row: %d", [indexPath row]);
        
        ShoppingCartItem* toDelete = [self.cartItems objectAtIndex:[indexPath row]];
        NSLog(@"Trying to delete : %@", toDelete);
        
        [self.cartItems removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void) reload {
    NSLog(@"Reloading Shopping cart");
    
    [[YummlyClient instance] fetchShoppingCartWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
           
            
             for(int index =0 ; index < objects.count; index++) {
                PFObject * object = objects[index];
                Recipe* recipe= [[Recipe alloc] initWithDictionary: object[@"recipeDetail"]];
                NSLog(@"%@", object.objectId);
                NSMutableDictionary* itemAsDictionary = [[NSMutableDictionary alloc] init];

                itemAsDictionary[@"quantity"] = object[@"quantity"];
                itemAsDictionary[@"ingredients"] = object[@"ingredients"];
                itemAsDictionary[@"recipe"] = object[@"recipe"];
                itemAsDictionary[@"recipeDetail"] = object[@"recipeDetail"];
                itemAsDictionary[@"userId"] = object[@"userId"];
                
                ShoppingCartItem* item = [[ShoppingCartItem alloc] initWithDictionary:itemAsDictionary];
                [self.cartItems addObject:item];

                UITableViewCell* dummy = [[UITableViewCell alloc] init];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [recipe image90]]
                                                                       cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                   timeoutInterval:10000];
                [request setHTTPMethod:@"GET"];
                
                [dummy.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    ////resize
                    
                    [self.images addObject:image];
                    if(index == objects.count -1) {
                        [self.tableView reloadData];
                    }
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"Failed to load image");
                    if(index == objects.count -1) {
                        [self.tableView reloadData];
                    }
                }];
            }
            //reload table

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

//- (void)getPriceForShoppingCart{
//    self.price = 0;
//    for(int index =0 ; index < self.cartItems.count; index++) {
//        NSArray* ingredients = [(ShoppingCartItem *)(self.cartItems[index]) ]
//    }
//    [[YummlyClient instance] getPriceForShoppingCart: ^(NSArray *objects, NSError *error) {
//        if (!error) {
//            // The find succeeded.
//            NSLog(@"Successfully retrieved %d scores.", objects.count);
//            // Do something with the found objects
//            
//            
//            for(int index =0 ; index < objects.count; index++) {
//                PFObject * object = objects[index];
//                NSLog(@"%@", object.objectId);
//                self.price = self.price + [object[@"price"] integerValue];
//            }
//            
//        } else {
//            // Log details of the failure
//            NSLog(@"Error: %@ %@", error, [error userInfo]);
//        }
//    }];
//}

@end
