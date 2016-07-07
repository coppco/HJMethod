//
//  HJXAuthorizeFunction.h
//  HJMethod
//
//  Created by coco on 16/7/7.
//  Copyright © 2016年 XHJ. All rights reserved.
//  一些状态, 硬件授权检测,如:定位、相机、蓝牙、等等

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>  //定位

@interface HJAuthorizeFunction : NSObject
/**
 * 单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)shareAuthorize;

/**
 *  开始定位,  Info.plist里面需要至少添加NSLocationAlwaysUsageDescription 和 NSLocationWhenInUseUsageDescription其中的一个, 分别是使用期间和一直使用, 用户授权时可以看到.
 *
 *  @param success 成功的回调
 *  @param failed  失败的回调
 */
- (void)startLocationWithSuccessBlock:(void (^)(CLLocation *location,CLPlacemark *placemark))success failed:(void (^)())failed;

- (void)authorizeLocationStatue;

@end
