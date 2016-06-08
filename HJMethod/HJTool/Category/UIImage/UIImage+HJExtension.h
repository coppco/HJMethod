//
//  UIImage+HJExtension.h
//  HJMethod
//
//  Created by coco on 16/6/6.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HJExtension)

/**
 *  颜色生成图片
 *
 *  @param color 颜色
 *
 *  @return 返回图片
 */
+ (UIImage *)hj_imageFromColor:(UIColor *)color;

/**
 *  按照大小缩放图片
 *
 *  @param size 压缩后的图片大小
 *
 *  @return 返回压缩后的图片
 */
- (UIImage *)hj_scaleToSize:(CGSize)size;

/**
 *  等比例缩放图片
 *
 *  @param ratio 比例
 *
 *  @return 返回压缩后的图片
 */
- (UIImage *)hj_scaleWithRatio:(CGFloat)ratio;

/**
 *  添加水印
 *
 *  @param logo logo图片
 *
 *  @return 返回添加水印后的图片
 */
- (UIImage *)hj_addLogo:(UIImage *)logo;

/**
 *  手机屏幕截图(有状态栏)
 *
 *  @return
 */
+ (UIImage *)hj_imageWithScreenshot;

/**
 *  手机屏幕截图无状态栏
 *
 *  @return 
 */
+ (UIImage *)HJ_imageWithScreenshotNoStatusBar;
@end
