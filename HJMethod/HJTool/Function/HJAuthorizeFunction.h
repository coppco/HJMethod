//
//  HJXAuthorizeFunction.h
//  HJMethod
//
//  Created by coco on 16/7/7.
//  Copyright © 2016年 XHJ. All rights reserved.
//  一些状态, 硬件授权检测,如:定位、联网、蓝牙、相机、通讯录、相册、麦克风、日历、备忘录和推送

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>  //定位
#import <CoreTelephony/CTCellularData.h>  //联网权限
#import <AVFoundation/AVFoundation.h>  //相机  麦克风等
#import <EventKit/EventKit.h>   //日历备忘录
#import <CoreBluetooth/CoreBluetooth.h>  //蓝牙

//相册状态
typedef NS_ENUM(NSInteger, HJPhotoAuthorizeStatue) {
    HJPhotoAuthorizeStatueNotDetermined = 0,  //没有选择
    AHJPhotoAuthorizeStatueusRestricted,  //限制
    HJPhotoAuthorizeStatueDenied,   //拒绝
    HJPhotoAuthorizeStatueAuthorized   //授权
};

//通讯录状态
typedef NS_ENUM(NSInteger, HJAddressBookAuthorizeStatue) {
    HJAddressBookAuthorizeStatueNotDetermined = 0,  //没有选择
    HJAddressBookAuthorizeStatueRestricted,  //限制
    HJAddressBookAuthorizeStatueDenied,   //拒绝
    HJAddressBookAuthorizeStatueAuthorized   //授权
};

//通知状态
typedef NS_OPTIONS(NSUInteger, HJNotificationAuthorizeType) {
    HJNotificationAuthorizeTypeNone    = 0,      // the application may not present any UI upon a notification being received
    HJNotificationAuthorizeTypeBadge   = 1 << 0, // the application may badge its icon upon a notification being received
    HJNotificationAuthorizeTypeSound   = 1 << 1, // the application may play a sound upon a notification being received
    HJNotificationAuthorizeTypeAlert   = 1 << 2, // the application may display an alert upon a notification being received
};

@interface HJAuthorizeFunction : NSObject
/**
 * 单例
 *
 *  @return 返回单例对象
 */
+ (instancetype)shareAuthorize;

/**
 *  打开程序设置
 */
- (void)openAppSetting;

/*==============定位相关===============*/
/**
 *  开始定位,  Info.plist里面需要至少添加NSLocationAlwaysUsageDescription 和 NSLocationWhenInUseUsageDescription其中的一个, 分别是使用期间和一直使用, 用户授权时可以看到.
 *
 *  @param success 成功的回调
 *  @param failed  失败的回调
 */
- (void)startLocationWithSuccessBlock:(void (^)(CLLocation *location,CLPlacemark *placemark))success failed:(void (^)())failed;

/**
 *  查询定位服务是否打开
 *
 *  @return
 */
- (BOOL)isAvailableForLocation;
/**
 *  查询定位状态
 *
 *  @param finished 结束的回调
 */
- (void)authorizeLocationStatue:(void(^)(CLAuthorizationStatus status))finished;

/*==============联网相关===============*/
/**
 *  查询联网权限, 只能iOS9.0以后
 *
 *  @param finished 得到结果回调
 */
- (void)authorizeNetworkStatue:(CellularDataRestrictionDidUpdateNotifier)finished;

/*==============相册相关===============*/

/**
 *  查询相册授权状态
 *
 *  @param finished 回调
 */
- (void)authorizePhotoStatue:(void (^)(HJPhotoAuthorizeStatue status))finished;

/**
 *  请求访问相册弹窗
 */
- (void)startPhotoAuthorize;

/*==============相机相关===============*/
/**
 *  查询相机访问状态
 *
 *  @param finished 回调
 */
- (void)authorizeCameraStatue:(void (^)(AVAuthorizationStatus status))finished;

/**
 *  请求访问相机弹窗, 模拟器弹窗也出来
 */
- (void)startCameraAuthorize;

/*==============麦克风相关===============*/
/**
 *  查询麦克风访问状态
 *
 *  @param finished 回调
 */
- (void)authorizeMicroStatue:(void (^)(AVAuthorizationStatus status))finished;

/**
 *  请求访问麦克风弹窗, 模拟器弹窗也出来
 */
- (void)startMicroAuthorize;

/*==============通讯录相关===============*/
/**
 *  查询通讯录授权状态
 *
 *  @param finished 回调
 */
- (void)authorizeAddressBookStatue:(void (^)(HJAddressBookAuthorizeStatue))finished;
/**
 *  请求通讯录权限弹窗
 */
- (void)startAddressBookAuthorize;

/*==============日历、备忘录相关===============*/
/**
 *  查询日历 备忘录授权状态
 *
 *  @param type     日历或者备忘录
 *  @param finished 回调
 */
- (void)authorizeEKForEKEntityType:(EKEntityType)type finished:(void (^)(EKAuthorizationStatus))finished;

/**
 *  请求访问日历备忘录弹窗
 *
 *  @param type 日历或者备忘录
 */
- (void)startEKAuthorizeForKEntityType:(EKEntityType)type;

/*==============蓝牙相关===============*/
/**
 *  查询蓝牙授权状态
 *
 *  @param finished 回调
 */
- (void)authorizeBluetoothStatue:(void (^)(CBPeripheralManagerAuthorizationStatus))finished;

/**
 *  申请蓝牙授权
 */
- (void)startBluetoothAuthorize;

/*==============推送相关===============*/
- (void)authorizeNotificationStatue:(void (^)(HJNotificationAuthorizeType))finished;

- (void)startNotificationAuthorize;
@end
