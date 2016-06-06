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

AppDelegate *getApp() {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
UIWindow *getAppKeyWindow() {
    return [UIApplication sharedApplication].keyWindow;
}

BOOL hj_checkVaildCamera() {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

@end
