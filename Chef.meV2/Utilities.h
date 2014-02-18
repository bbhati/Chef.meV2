//
//  UTilities.h
//  Chef.me
//
//  Created by Bhagyashree Shekhawat on 2/16/14.
//  Copyright (c) 2014 Codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize source:(UIImage*)source;
+ (UIImage *) maskWithColor:(UIColor *)color image:(UIImage*)image;

@end
