//
//  UIColor+Extension.m
//  HJMethod
//
//  Created by coco on 16/6/2.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "UIColor+HJExtension.h"

@implementation UIColor (HJExtension)

+ (UIColor *)hj_colorFromHexString:(NSString *)string {
    if (string.length == 0) {
        return [UIColor clearColor];
    }
    if ([string hasPrefix:@"#"]) {
        string  = [string stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    NSScanner *scanner = [NSScanner scannerWithString:string];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return [UIColor clearColor];
   
    return [self hj_colorFromRGBValue:hexNum];
}
+ (UIColor *)hj_colorFromRGBValue:(UInt32)value {
    float red = ((value >> 24) & 0xFF)/255.0f;
    float green = ((value >> 16) & 0xFF)/255.0f;
    float blue = ((value >> 8) & 0xFF)/255.0f;
    float alpha = ((value >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
+ (UIColor *)hj_randomColor {
    return [UIColor colorWithRed:(arc4random() % 256) / 255.0f
                           green:(arc4random() % 256) / 255.0f
                            blue:(arc4random() % 256) / 255.0f
                           alpha:1];
}

+ (UIColor *)hj_colorWithImage:(NSString *)imageName {
    return [UIColor colorWithPatternImage:[UIImage imageNamed:imageName]];
}
@end
