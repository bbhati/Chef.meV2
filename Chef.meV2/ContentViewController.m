//
//  ContentViewController.m
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/15/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import "ContentViewController.h"
#import "YummlyClient.h"
#import "RecipeListViewController.h"

@interface ContentViewController ()

@property (assign, nonatomic, getter = isRotating) BOOL rotating;
@property(nonatomic) NSArray* categories;
-(void)addScrollingGradientToView:(UIImageView*)imageView;
@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    self.categories = [YummlyClient categories];

    NSMutableString* imageName = nil;
    
//	[self.category1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"matrix_%02d", [self movieIndex]]]];
    NSUInteger totalCount = [self.categories count];
    NSUInteger currCount = self.pageIndex < 3 ? 8 : totalCount - (self.pageIndex-1)*8;
    NSLog(@"Total:%d, pageindex:%d, Currcount %d", totalCount, self.pageIndex, currCount);
    NSMutableArray* currCategories = [[NSMutableArray alloc] init];
    for (int i =0; i < currCount; i++) {
        imageName = [[NSMutableString alloc] initWithString:@"image"];
        [imageName appendString:[NSString stringWithFormat:@"%d", (i+1)*self.pageIndex]];
        [imageName appendString:@".jpg"];
        currCategories[i] = imageName;
        
    }
//    if(currCount < 8) {
//        for(int i =currCount; i<8 ; i++ ) {
//            currCategories[i] = nil;
//        }
//    }
    NSLog(@"Size of currCategories %d", [currCategories count]);
    NSLog(@"Categories: %@", currCategories);
    [currCategories count] > 0 ? [self setImage:currCategories[0] label:self.categories[8*(self.pageIndex-1)] category:[self category1] catLabel:[self label1]]:nil;
    [currCategories count] > 1 ? [self setImage:currCategories[1] label:self.categories[8*(self.pageIndex -1) + 1] category:[self category2] catLabel:[self label2]]:nil;
    [currCategories count] > 2 ? [self setImage:currCategories[2] label:self.categories[8*(self.pageIndex-1) + 2] category:[self category3] catLabel:[self label3]]:nil;
    [currCategories count] > 3 ? [self setImage:currCategories[3] label:self.categories[8*(self.pageIndex-1) +3] category:[self category4] catLabel:[self label4]]:nil;
    [currCategories count] > 4 ? [self setImage:currCategories[4] label:self.categories[8*(self.pageIndex-1) +4] category:[self category5] catLabel:[self label5]]:nil;
    [currCategories count] > 5 ? [self setImage:currCategories[5] label:self.categories[8*(self.pageIndex-1) +5] category:[self category6] catLabel:[self label6]]:nil;
    [currCategories count] > 6 ? [self setImage:currCategories[6] label:self.categories[8*(self.pageIndex-1) +6] category:[self category7] catLabel:[self label7]]:nil;
    [currCategories count] > 7 ? [self setImage:currCategories[7] label:self.categories[8*(self.pageIndex-1) +7] category:[self category8] catLabel:[self label8]]:nil;
    
    self.category1.userInteractionEnabled = YES;
    [currCategories count] > 0? [self.category1 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(actionHandleTapOnImageView:)]]:nil;
    self.category2.userInteractionEnabled = YES;
    [currCategories count] > 1? [self.category2 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(actionHandleTapOnImageView:)]]:nil;
    self.category3.userInteractionEnabled = YES;
    [currCategories count] > 2? [self.category3 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(actionHandleTapOnImageView:)]] :nil;
    self.category4.userInteractionEnabled = YES;
    [currCategories count] > 3? [self.category4 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(actionHandleTapOnImageView:)]] : nil;
    self.category5.userInteractionEnabled = YES;
    [currCategories count] > 4? [self.category5 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(actionHandleTapOnImageView:)]] : nil;
    self.category6.userInteractionEnabled = YES;
    [currCategories count] > 5? [self.category6 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(actionHandleTapOnImageView:)]] : nil;
    self.category7.userInteractionEnabled = YES;
    [currCategories count] > 6 ? [self.category7 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(actionHandleTapOnImageView:)]] : nil;
    self.category8.userInteractionEnabled = YES;
    [currCategories count] > 7 ? [self.category8 addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(actionHandleTapOnImageView:)]] : nil;
    NSLog(@"last image, %@", self.category8);
}

- (void)viewDidUnload
{
	[self setCategory1:nil];
	[self setCategory2:nil];
	[self setCategory3:nil];
	[self setCategory4:nil];
    [self setCategory5:nil];
	[self setCategory6:nil];
    [self setCategory7:nil];
	[self setCategory8:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
	[self setRotating:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
	[self setShadowPathsWithAnimationDuration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    
	[self setRotating:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	NSLog(@"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	NSLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	NSLog(@"viewDidDisappear");
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
    
	if (![self isRotating])
		[self setShadowPathsWithAnimationDuration:0];
    
	NSLog(@"viewWillLayoutSubviews");
}

- (void)setShadowPathsWithAnimationDuration:(NSTimeInterval)duration
{
	UIBezierPath *newPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 320, 284)];
	CGPathRef oldPath = CGPathRetain([self.upperHalf.layer shadowPath]);
	[self.upperHalf.layer setShadowPath:[newPath CGPath]];
    
	if (duration > 0)
	{
		CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"shadowPath"];
		[pathAnimation setFromValue:(__bridge id)oldPath];
		[pathAnimation setToValue:(id)[self.upperHalf.layer shadowPath]];
		[pathAnimation setDuration:duration];
		[pathAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[pathAnimation setRemovedOnCompletion:YES];
        
		[self.upperHalf.layer addAnimation:pathAnimation forKey:@"shadowPath"];
	}
    
	CGPathRelease(oldPath);
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	NSLog(@"viewDidLayoutSubviews");
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
	[super willMoveToParentViewController:parent];
	if (parent)
		NSLog(@"willMoveToParentViewController");
	else
		NSLog(@"willRemoveFromParentViewController");
}

-(void) setImage: (NSString*)image label: (NSString*)label category:(UIImageView*)category catLabel:(UILabel*)catLabel{
    [category setImage:[UIImage imageNamed:image]];
    [self addScrollingGradientToView:category];
    [catLabel setText:label];
    [catLabel setTextColor:[UIColor blackColor]];

}

-(void)addScrollingGradientToView:(UIImageView*)imageView
{
    imageView.backgroundColor = [ UIColor clearColor ] ;
    imageView.opaque = NO;
    //add in the gradient to show scrolling
    CAGradientLayer *nextImageFade = [CAGradientLayer layer];
    nextImageFade.frame = imageView.bounds;
    
    nextImageFade.colors =  //@[[UIColor whiteColor], [UIColor blackColor]];
                            [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor whiteColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
//                            [NSArray arrayWithObjects:(id)
//                            [UIColor colorWithRed:0. green:0. blue:0. alpha:0.0].CGColor,
//                            [UIColor colorWithRed:0. green:0. blue:0. alpha:1.0].CGColor,
//                            [UIColor colorWithRed:0. green:0. blue:0. alpha:1.0].CGColor,
//                            [UIColor colorWithRed:0. green:0. blue:0. alpha:0.0].CGColor,nil];
    //nextImageFade.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
     //                          [NSNumber numberWithFloat:20 / imageView.frame.size.height],
      //                         [NSNumber numberWithFloat:(imageView.frame.size.height - 20) / imageView.frame.size.height],
       //                        [NSNumber numberWithFloat:1.], nil];
    nextImageFade.startPoint = CGPointMake(.5, 0);
    nextImageFade.endPoint = CGPointMake(.5, 1);
    
    //Put in the fading last so that it is above everything else
    [imageView.layer setMask:nextImageFade];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)actionHandleTapOnImageView:(UITapGestureRecognizer*)touch {
    NSLog(@"handling touch");
    NSLog(@"Image %@", touch);
    NSLog(@"Ended!!! ");
    if([touch view] == self.category1) {
        [self handleTapOnCategory:self.categories[8*(self.pageIndex-1)]];  // <-- Handle it!
    } else if([touch view] == self.category2){
        [self handleTapOnCategory:self.categories[8*(self.pageIndex-1) + 1]];
    } else if([touch view] == self.category3){
        [self handleTapOnCategory:self.categories[8*(self.pageIndex-1) + 2]];
    } else if([touch view] == self.category4){
        [self handleTapOnCategory:self.categories[8*(self.pageIndex-1) + 3]];
    } else if([touch view] == self.category5){
        [self handleTapOnCategory:self.categories[8*(self.pageIndex-1) + 4]];
    } else if([touch view] == self.category6){
        [self handleTapOnCategory:self.categories[8*(self.pageIndex-1) + 5]];
    } else if([touch view] == self.category7){
        [self handleTapOnCategory:self.categories[8*(self.pageIndex-1) + 6]];
    } else if([touch view] == self.category8){
        [self handleTapOnCategory:self.categories[8*(self.pageIndex-1) + 7]];
    }
}

- (void) handleTapOnCategory:(NSString*) category{
    NSLog(@"Handled touch on %@", category);
    //load view controller
    RecipeListViewController *controller = [[RecipeListViewController alloc] init];
    controller.category = category;
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (void)didMoveToParentViewController:(UIViewController *)parent
{
	[super didMoveToParentViewController:parent];
	if (parent)
		NSLog(@"didMoveToParentViewController");
	else
		NSLog(@"didRemoveFromParentViewController");
}
@end
