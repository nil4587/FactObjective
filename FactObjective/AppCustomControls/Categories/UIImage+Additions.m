//
//  UIImage+Additions.m
//  FactObjective
//
//  Created by Nilesh Prajapati on 21/11/17.
//  Copyright © 2017 Nilesh Prajapati. All rights reserved.
//

#import "UIImage+Additions.h"

@implementation UIImage(Additions)

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    
    CGSize size = image.size;
    
    CGFloat widthRatio  = newSize.width  / image.size.width;
    CGFloat heightRatio = newSize.height / image.size.height;
    
    // Figure out what our orientation is, and use that to form the rectangle
    if(widthRatio > heightRatio) {
        newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio);
    } else {
        newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio);
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    CGRect rect = CGRectMake(0, 0, newSize.width, newSize.height);
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
