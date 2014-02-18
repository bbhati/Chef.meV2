//
//  IngredientsViewController.m
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/18/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "IngredientsViewController.h"
#import "YummlyClient.h"

@interface IngredientsViewController ()
- (IBAction)addToCart:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *servings;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic) NSMutableArray* ingredients;
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.ingredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Create the cell and add the labels
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0.0f, 0.0f, 320.0f, 44.0f)];
        titleLabel.tag = 1;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:titleLabel];
    }
  
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Access labels in the cell using the tag #
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    // Display the data in the table
    titleLabel.text = [self.ingredients objectAtIndex:indexPath.row];
//    dataLabel.text = [self.rowDataArray objectAtIndex:indexPath.row];
    return cell;
}

- (void) getRecipeWithId: (NSString*)recipeId {
    NSLog(@"Reloading recipes");
    
    [[YummlyClient instance] fetchRecipeWithId:recipeId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success!!!");
        NSLog(@"%@", responseObject);
        NSDictionary* dict = (NSDictionary*) responseObject;
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

@end
