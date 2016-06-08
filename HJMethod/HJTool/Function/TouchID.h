//
//  TouchID.h
//  XHJTool
//
//  Created by coco on 16/5/4.
//  Copyright © 2016年 XHJ. All rights reserved.
//  调用苹果手机自带的touchid验证

#import <Foundation/Foundation.h>

@interface TouchID : NSObject
/**
 *  @author XHJ, 16-05-04 09:05:53
 *
 *  检测touchID是否可用
 *
 *  @return 返回是否可用, YES:可用  NO:不可用
 */
+ (BOOL)isAvailable;

+ (void)showTouchIdOnCompletion:(void (^)(BOOL success, NSError *authenticationError))completion failed:(void (^)(NSError *authenticationError))failed;



@end
