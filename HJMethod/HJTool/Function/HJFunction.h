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

/**
 *  拨打电话号码, if YES 则提示
 *
 *  @param phoneNumber  电话号码
 *  @param prompt   是否提示
 *
 *  @return
 */
void hj_callTelephoneNumber(NSString *phoneNumber, BOOL  prompt);

/**
 *  简单json字符串转成字典或者数组
 *
 *  @param jsonString json字符串
 *
 *  @return
 */
id hj_JSONTransformToDictionaryOrArray(NSString *jsonString);

/**
 *  简单字典或者数组转成JSON字符串
 *
 *  @param object 字典或者数组
 *
 *  @return 
 */
NSString *hj_dictionaryOrArrayTransformToJSONString(id object);

/**
 *  取值
 *
 *  @param key 键key
 *
 *  @return
 */
id hj_userDefaultGetValue(NSString *key);

/**
 *  存值
 *
 *  @param object 值value
 *  @param key    键key
 */
void hj_userDefaultSetValueKey(id object, NSString *key);

/**
 *  移除key-value
 *
 *  @param key 键key
 */
void hj_userDefaultRemoveKey(NSString *key);

/**
 *  清空userdefault
 */
void hj_userDefaultClean();
@end
