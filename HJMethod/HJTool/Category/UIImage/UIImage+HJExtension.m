//
//  UIImage+HJExtension.m
//  HJMethod
//
//  Created by coco on 16/6/6.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "UIImage+HJExtension.h"

@implementation UIImage (HJExtension)

+ (UIImage *)hj_imageFromColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)hj_scaleToSize:(CGSize)size {
    CGImageRef imgRef = self.CGImage;
    CGSize originSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // 原始大小
    if (CGSizeEqualToSize(originSize, size)) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);//[UIScreen mainScreen].scale
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;

}

- (UIImage *)hj_scaleWithRatio:(CGFloat)ratio {
    if (ratio >= 1 || ratio <= 0) {
        return self;
    }
    CGImageRef imgRef = self.CGImage;
    CGSize size = CGSizeMake(CGImageGetWidth(imgRef) * ratio, CGImageGetHeight(imgRef) * ratio); // 缩放后大小
    return [self hj_scaleToSize:size];
}

- (UIImage *)hj_addLogo:(UIImage *)logo {
    if (!self) {
        return nil;
    }
    if (!logo) {
        return self;
    }
    int w = self.size.width;
    int h = self.size.height;
    int logoWidth = logo.size.width;
    int logoHeight = logo.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 44 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
    CGContextDrawImage(context, CGRectMake(w-logoWidth-15, 10, logoWidth, logoHeight), [logo CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage *returnImage = [UIImage imageWithCGImage:imageMasked];
    CGContextRelease(context);
    CGImageRelease(imageMasked);
    CGColorSpaceRelease(colorSpace);
    return returnImage;
}

+ (UIImage *)HJ_imageWithScreenshotNoStatusBar {
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if ([window screen] == [UIScreen mainScreen]) {
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)hj_imageWithScreenshot {
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if ([window screen] == [UIScreen mainScreen]) {
            [window drawViewHierarchyInRect:[[UIScreen mainScreen] bounds] afterScreenUpdates:NO];
        }
    }
    
    UIView *statusBar = [[UIApplication sharedApplication] valueForKey:@"statusBar"];
    [statusBar drawViewHierarchyInRect:[statusBar bounds] afterScreenUpdates:NO];
    
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return screenImage;
}
@end
