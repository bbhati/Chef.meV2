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

@interface ShoppingCartController ()
@property(nonatomic, strong) NSMutableArray* recipes;
@property(nonatomic, strong) NSMutableArray* cartItems;
@property (weak, nonatomic) IBOutlet UITableView *table;


@end

@implementation ShoppingCartController

- (id)init
{
    self = [super init];
    if (self) {
        //read recipes from parse
        self.cartItems = [[NSMutableArray alloc] init];
        self.recipes = [[NSUserDefaults standardUserDefaults] objectForKey:@"shoppingCart"];

   }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    //get from parse
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.table registerNib:[UINib nibWithNibName:@"ShoppingCartRowCell" bundle:nil] forCellReuseIdentifier:@"ShoppingCartRowCell"];

    self.table.delegate = self;
    self.table.dataSource = self;
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
//    return [self.recipes count];
    return [self.cartItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShoppingCartRowCell";
    //UITableViewCell *mainCell = [[UITableViewCell alloc] init];
    ShoppingCartRowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
   // cell.recipe = [self.recipes objectAtIndex:indexPath.row];
//    NSString * current = [self.recipes objectAtIndex:indexPath.row];
    //Get from Parse

    ShoppingCartItem* item = self.cartItems[indexPath.row];
    cell.name.text = item.recipeId;
    //get image from saved recipeDetail
    [cell.photo setImage:[UIImage imageNamed:@"image1.jpg"]];
    cell.price.text = @"50$";

    return cell;
//    return mainCell;
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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
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
//        NSString* toDelete = [self.recipes objectAtIndex:[indexPath row]];
  //      NSLog(@"Trying to delete : %@", toDelete);
        //[self.recipes removeObjectAtIndex:[indexPath row]];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //update core data
        
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.table setEditing:editing animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void) reload {
    NSLog(@"Reloading Shopping cart");
    
    [[YummlyClient instance] fetchShoppingCartWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSMutableDictionary* itemAsDictionary = [[NSMutableDictionary alloc] init];

                itemAsDictionary[@"quantity"] = object[@"quantity"];
                itemAsDictionary[@"ingredients"] = object[@"ingredients"];
                itemAsDictionary[@"recipe"] = object[@"recipe"];
                itemAsDictionary[@"recipeDetail"] = object[@"recipeDetail"];
                itemAsDictionary[@"userId"] = object[@"userId"];
                
                ShoppingCartItem* item = [[ShoppingCartItem alloc] initWithDictionary:itemAsDictionary];
                [self.cartItems addObject:item];

            }
            //reload table
            

            [self.table reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

@end
