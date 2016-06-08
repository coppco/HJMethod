//
//  HJFunction.m
//  HJMethod
//
//  Created by coco on 16/6/6.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJFunction.h"
#import <UIKit/UIKit.h>
@implementation HJFunction

//获取代理
AppDelegate *getApp() {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
//主窗口
UIWindow *getAppKeyWindow() {
    return [UIApplication sharedApplication].keyWindow;
}
//检查摄像头
BOOL hj_checkVaildCamera() {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}
//播打电话
void hj_callTelephoneNumber(NSString *phoneNumber, BOOL  prompt) {
    if (prompt) {
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneNumber]]];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]]];
    }
}

id hj_JSONTransformToDictionaryOrArray(NSString *jsonString) {
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:(NSJSONReadingMutableContainers) error:&error];
    if (error != nil) {
#ifdef  DEBUG
        NSLog(@"fail to get dictioanry or array from JSON: %@, error: %@", jsonString, error);
#endif
    }
    return object;
}
NSString *hj_dictionaryOrArrayTransformToJSONString(id object) {
    if (![object isKindOfClass:[NSArray class]] && ![object isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSError *error;
    //NSJSONWritingPrettyPrinted  有空格和换行符  使用(0)没有换行符和空格
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:(0) error:&error];
    if (error != nil) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from object: %@, error: %@", object, error);
#endif
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

}

#pragma mark - NSUserDefault相关
//  从NSUserDefault取值
id hj_userDefaultGetValue(NSString *key) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}
//存入NSUserDefault
void hj_userDefaultSetValueKey(id object, NSString *key) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:object forKey:key];
    [ud synchronize];
}
//根据key移除key-value对
void hj_userDefaultRemoveKey(NSString *key) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];
    [ud synchronize];
}
//清空NSUserDefault
void hj_userDefaultClean() {
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
}

@end
