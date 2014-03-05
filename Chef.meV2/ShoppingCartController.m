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
@property (nonatomic, strong) NSMutableDictionary* images;
@property (nonatomic, strong) NSMutableDictionary* prices;
@property (nonatomic) int price;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *recipeCount;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UIView *innerView;

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

        self.recipeCount.text =0;

        self.total.text = 0;
        self.images = [[NSMutableDictionary alloc] init];
        self.prices = [[NSMutableDictionary alloc] init];
   }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView* v = self.innerView;
    // border radius
    [v.layer setCornerRadius:10.0f];
    
    // border
    [v.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [v.layer setBorderWidth:1.0f];
    
    // drop shadow
    [v.layer setShadowColor:[UIColor blackColor].CGColor];
    [v.layer setShadowOpacity:0.8];
    [v.layer setShadowRadius:3.0];
    [v.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    [self.tableView.layer setCornerRadius:10.0f];
    self.tableView.dataSource =self;
    self.tableView.delegate =self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ShoppingCartRowCell" bundle:nil] forCellReuseIdentifier:@"ShoppingCartRowCell"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"Checkout" style:UIBarButtonItemStyleDone target:self action:@selector(openCheckout)];
    
    NSArray *items = [NSArray arrayWithObjects:item1,item2, nil];
    self.toolbarItems = items;
    
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
        [cell.photo setImage:[Utilities imageByScalingAndCroppingForSize:(CGSize)CGSizeMake(90,90) source:[self.images objectForKey:item.recipeId]]];
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
        NSString* labeltext = self.recipeCount.text;
        NSArray* comp = [labeltext componentsSeparatedByString:@" "];
        
        NSInteger text = [comp[1] integerValue ] -1;
        self.recipeCount.text = [NSString stringWithFormat:@"%@%d",@"Recipes: ", text];
        
        labeltext = self.total.text;
        comp = [labeltext componentsSeparatedByString:@" "];
        
        float total = [comp[1] floatValue];
        NSLog(@"floatVal: %f", total);
        total = total - [[self.prices objectForKey:toDelete.recipeId] floatValue];
        
        self.total.text = [NSString stringWithFormat:@"%@%0.2f%@", @"Total: ", total, @" $"];
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
           
             self.recipeCount.text = [NSString stringWithFormat:@"%@%d",@"Recipes: ", objects.count];
            
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

                 [self.prices setObject:[NSString stringWithFormat:@"%0.2f", [self getPriceForItem]] forKey:item.recipeId];
                UITableViewCell* dummy = [[UITableViewCell alloc] init];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [recipe image90]]
                                                                       cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                                   timeoutInterval:10000];
                [request setHTTPMethod:@"GET"];
                
                [dummy.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                    ////resize
                    
                    [self.images setObject:image forKey:item.recipeId];
                    if([self.images count] == objects.count) {

                        [self.tableView reloadData];
                    }
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    NSLog(@"Failed to load image");
                    if(index == objects.count -1) {
                        [self.tableView reloadData];
                    }
                }];
            }
            float total =0;
            for(int index =0; index < objects.count; index++) {
                ShoppingCartItem* item = self.cartItems[index];
                total = total + [[self.prices objectForKey:item.recipeId] floatValue];
            }
            self.total.text = [NSString stringWithFormat:@"%@%0.2f%@", @"Total: ", total, @" $"];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (void) openCheckout {
    
}

-(float) getPriceForItem {

    float low_bound = 5.50;
    float high_bound = 15.09;
    float rndValue = (((float)arc4random()/0x100000000)*(high_bound-low_bound)+low_bound);
    return rndValue;
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
