//
//  StepsViewController.m
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/18/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "StepsViewController.h"
#import "YummlyClient.h"

@interface StepsViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *viewWeb;
@property (weak, nonatomic) NSString *sourceUrl;

@end

@implementation StepsViewController
NSString* stepsLoadedRecipeNotification = @"StepsLoadedRecipeNotification";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)popuLateView: (NSNotification *)notification{
    
    NSLog(@"Notification received: %@", notification);
    if(notification != nil){
        self.sourceUrl = self.recipe.sourceRecipeUrl;
        NSLog(@"Opening page %@", self.sourceUrl);
        NSURL *url = [NSURL URLWithString:self.sourceUrl];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [_viewWeb loadRequest:requestObj];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

//    NSString *fullURL = @"http://conecode.com";

    [self getRecipeWithId:self.recipe.id];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popuLateView:) name:stepsLoadedRecipeNotification object:nil];
    // Do any additional setup after loading the view from its nib.
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:stepsLoadedRecipeNotification
                                                            object:self];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure!!!");
        NSLog(@"%@", error);
        [[NSNotificationCenter defaultCenter] postNotificationName:stepsLoadedRecipeNotification
                                                            object:self];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
