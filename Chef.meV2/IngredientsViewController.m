//
//  IngredientsViewController.m
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/18/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "IngredientsViewController.h"
#import "YummlyClient.h"
#import "ShoppingCartController.h"
#import "Parse/Parse.h"
#import "ShoppingCart.h"
#import "ShoppingCartItem.h"
#import "Utilities.h"

@interface IngredientsViewController ()
- (IBAction)addToCart:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *servings;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) NSMutableArray* ingredients;

- (IBAction)onHome:(id)sender;
- (IBAction)onShowCart:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *footerView;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define FONT_SIZE 14.0
@end

@implementation IngredientsViewController
NSString* loadedRecipeNotification = @"LoadedRecipeNotification";


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
        self.table.delegate = self;
        self.table.dataSource = self;
        self.ingredients = [[NSMutableArray alloc] init];
        [self getRecipeWithId:self.recipe.id];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popuLateView:) name:loadedRecipeNotification object:nil];
    }
    
}

-(void)popuLateView: (NSNotification *)notification{
    
    NSLog(@"Notification received: %@", notification);
    if(notification != nil){
        self.ingredients = [NSMutableArray arrayWithArray: self.recipe.ingredientLines];
        self.servings.text = [NSString stringWithFormat:@"%d", self.recipe.numberOfServings ];
        [self.table reloadData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToCart:(id)sender {
    // add recipe to shopping cart
    
    //store to parse
    [Parse setApplicationId:@"G0eP59QGmBZWO2v4klysid1aDMvkVcMwmoHbAd3U" clientKey:@"JYQQiB2CVxXS0olE122ZQbpnb00GmCJEO4nucrOI"];

    NSDictionary* recipe = [NSDictionary dictionaryWithObject:self.recipe forKey:@"recipe"];

    NSMutableDictionary * md = [recipe mutableCopy];
    
    NSString* qty = self.servings.text;
    [md setObject:qty forKey:@"quantity"];

    NSLog(@"ingredients %@", self.recipe.ingredients);
    PFObject *item = [PFObject objectWithClassName:@"ShoppingCart"];
    item[@"quantity"] = qty;
    item[@"ingredients"] = self.recipe.ingredients;
    item[@"recipe"] = self.recipe.id;
    item[@"recipeDetail"] = self.recipe.data;
    item[@"userId"] = [Utilities getUserId];
    [item saveInBackground];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ingredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString* cellText = [self.ingredients objectAtIndex:indexPath.row];
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        float height = [self textSize:cellText constrainedToSize:CGSizeMake(280, FLT_MAX)].height;
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 280.0f, height)];
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.tag = 1;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        titleLabel.backgroundColor = [UIColor clearColor];

        [cell.contentView addSubview:titleLabel];
    }
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Access labels in the cell using the tag #
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    // Display the data in the table
    titleLabel.text = cellText;
//    dataLabel.text = [self.rowDataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void) getRecipeWithId: (NSString*)recipeId {
    NSLog(@"Reloading recipes");
    
    [[YummlyClient instance] fetchRecipeWithId:recipeId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success!!!");
        NSLog(@"%@", responseObject);
        //NSDictionary* dict = (NSDictionary*) responseObject;
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*) responseObject];
        [dict addEntriesFromDictionary:self.recipe.data];
        Recipe* obj = [[Recipe alloc] initWithDictionary:dict];
        
        
        self.recipe = obj;

        [[NSNotificationCenter defaultCenter] postNotificationName:loadedRecipeNotification
                                                            object:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure!!!");
        NSLog(@"%@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:loadedRecipeNotification
                                                            object:self];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  
        NSLog(@"Calculating height for content %@", [self.ingredients objectAtIndex:indexPath.row]);
        
        NSString* content = [self.ingredients objectAtIndex:indexPath.row];
        float horizontalPadding = 40;
        
        float widthOfTextView = self.table.bounds.size.width;
        widthOfTextView = widthOfTextView - horizontalPadding;
        
        float height = [self textSize:content constrainedToSize:CGSizeMake(widthOfTextView, FLT_MAX)].height;
        
        
        if(height < 44){
            height = 44;
        }
        
        NSLog(@"Content height: %f", height);
        
        return height + 15;
   
    
}

- (CGSize)textSize:(NSString *)text constrainedToSize:(CGSize)size
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect frame = [text boundingRectWithSize:size
                                          options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                       attributes:attributes
                                          context:nil];
        NSLog(@"Bound size: height %f", size.height);
        NSLog(@"Bound size: width %f", size.width);
        NSLog(@"Frame size: height %f", frame.size.height);
        NSLog(@"Frame size: width %f", frame.size.width);
        return frame.size;
    }
    else
    {
        return [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:size];
    }
}


- (IBAction)onHome:(id)sender {

}

- (IBAction)onShowCart:(id)sender {
    ShoppingCartController* cartController = [[ShoppingCartController alloc] init];

    [self.navigationController pushViewController:cartController animated:YES];
}
@end
