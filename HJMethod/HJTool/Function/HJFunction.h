//
//  HJFunction.h
//  HJMethod
//
//  Created by coco on 16/6/6.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface HJFunction : NSObject

/**
 *  获取AppDelegate
 *
 *  @return
 */
AppDelegate *getApp();

/**
 *  获取keyWindow
 *
 *  @return 
 */
UIWindow *getAppKeyWindow();

/**
 *  检查摄像头是否可用
 *
 *  @return YES 摄像头可用
 */
BOOL hj_checkVaildCamera();



@end
