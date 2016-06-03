//
//  UIColor+Extension.h
//  HJMethod
//
//  Created by coco on 16/6/2.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HJExtension)
/**
 *  @author XHJ, 16-06-02 13:06:15
 *
 *  从字符串(如:0x123abc 或者#123abc)获取颜色, 如果错误则返回clearColor
 *
 *  @param string 颜色字符串
 *
 *  @return 返回颜色
 */
+ (UIColor *)colorFromHexString:(NSString *)string;


/**
 *  @author XHJ, 16-06-02 16:06:33
 *
 *  从一个RGB数值(如0x666666, 34234)中获取颜色
 *
 *  @param value RGB数值
 *
 *  @return 返回颜色
 */
+ (UIColor *)colorFromRGBValue:(UInt32)value;


/**
 *  @author XHJ, 16-06-03 09:06:58
 *
 * 随机颜色
 *
 *  @return 返回颜色
 */
+ (UIColor *)randomColor;

/**
 *  @author XHJ, 16-06-03 18:06:04
 *
 *  
 *
 *  @param image <#image description#>
 *
 *  @return <#return value description#>
 */
+ (UIColor *)colorWithImage:(UIImage *)image;
@end
