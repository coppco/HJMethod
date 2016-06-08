//
//  TouchID.m
//  XHJTool
//
//  Created by coco on 16/5/4.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "TouchID.h"
#import <LocalAuthentication/LocalAuthentication.h>


@implementation TouchID
+ (BOOL)isAvailable {
#ifdef __IPHONE_8_0
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        return YES;
    }
    /**
     *  @author XHJ, 16-05-04 09:05:27
     *
     *  NSAssert 断言,在Debug下如果条件不成立会抛出异常,并打印后面的字符串.
     * Release下不会抛出异常
     */
    NSAssert(error == nil, @"TouchID can't open because %@", error);
    return NO;
#else
    NSAssert(false, @"TouchID can't open because it only suppose iOS 8.0 ablove");
    return NO;
#endif
}
+ (void)showTouchIdOnCompletion:(void (^)(BOOL success, NSError *authenticationError))complet failed:(void (^)(NSError *authenticationError))failed
{
#ifdef __IPHONE_8_0
    LAContext *context = [[LAContext alloc] init];
    /*
     LAPolicyDeviceOwnerAuthentication  设置了这个后可以激活 使用密码验证的方法,此时localizedFallbackTitle需要设置值,不然默认enter passcode
     
     
     LAPolicyDeviceOwnerAuthenticationWithBiometrics 开启密码验证会无效
     这个时候可以设置
     localizedFallbackTitle @""为空字符串(不是nil) ,  再试一次里面只会有取消按钮,另外一个会隐藏
     */
//    context.localizedFallbackTitle = @"输入密码";
    context.localizedFallbackTitle = @"";
    NSError *error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请使用Touch ID解锁。" reply:^(BOOL success, NSError *authenticationError)
         {
             //放到主线程运行防止出现延迟
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (success) {
                     //成功
                     if (complet) {
                         complet(success, authenticationError);
                     }
                 } else {

                     switch (authenticationError.code) {
                         case LAErrorUserFallback: //选择输入密码
                         {
                             NSLog(@"输入TouchID密码解锁");
                         }
                             break;
                         case LAErrorSystemCancel: //切换app
                         case LAErrorUserCancel: //用户取消
                        case LAErrorAuthenticationFailed:
                         default:
                             if (failed) {
                                 failed(error);
                             }
                             break;
                     }
                 }
             });
             
         }];
    }
#else
    NSAssert(false, @"TouchID can't open because it only suppose iOS 8.0 ablove");
#endif
}
/*
 typedef NS_ENUM(NSInteger, LAError)
 {
 //授权失败
 LAErrorAuthenticationFailed = kLAErrorAuthenticationFailed,
 
 //用户取消Touch ID授权
 LAErrorUserCancel           = kLAErrorUserCancel,
 
 //用户选择输入密码
 LAErrorUserFallback         = kLAErrorUserFallback,
 
 //系统取消授权(例如其他APP切入)
 LAErrorSystemCancel         = kLAErrorSystemCancel,
 
 //系统未设置密码
 LAErrorPasscodeNotSet       = kLAErrorPasscodeNotSet,
 
 //设备Touch ID不可用，例如未打开
 LAErrorTouchIDNotAvailable  = kLAErrorTouchIDNotAvailable,
 
 //设备Touch ID不可用，用户未录入
 LAErrorTouchIDNotEnrolled   = kLAErrorTouchIDNotEnrolled,
 } NS_ENUM_AVAILABLE(10_10, 8_0);
 */
@end
