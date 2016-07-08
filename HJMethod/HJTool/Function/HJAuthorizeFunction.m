//
//  HJXAuthorizeFunction.m
//  HJMethod
//
//  Created by coco on 16/7/7.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJAuthorizeFunction.h"
#import <AssetsLibrary/AssetsLibrary.h>  //9.0前相册权限
#import <Photos/Photos.h>  //8.0后相册权限
#import <AddressBook/AddressBook.h>   //9.0前通讯录
#import <Contacts/Contacts.h>   //  9.0以后通讯录

#define kHJSystemVersion ([UIDevice currentDevice].systemVersion.floatValue)

@interface HJAuthorizeFunction ()<CLLocationManagerDelegate>
//定位服务
@property (nonatomic, strong)CLLocationManager *locationManager;
//地理编码和反地理编码
@property (nonatomic, strong)CLGeocoder *gecoder;
//定位成功回调
@property (nonatomic, copy)void (^locationSuccess)(CLLocation *location,CLPlacemark *placemark);
//定位失败回调
@property (nonatomic, copy)void (^locationFailed)();

//联网权限
@property (nonatomic, strong)CTCellularData *cellularData;
@end

@implementation HJAuthorizeFunction


+ (instancetype)shareAuthorize {
    static HJAuthorizeFunction *authorizeFunction = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authorizeFunction = [[HJAuthorizeFunction alloc] init];
    });
    return authorizeFunction;
}

- (void)openAppSetting {
    //8.0 以后才可以
    if (kHJSystemVersion >= 8.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - ==============定位相关===============
//开始定位
- (void)startLocationWithSuccessBlock:(void (^)(CLLocation *location,CLPlacemark *placemark))success failed:(void (^)())failed {
    if (success) {
        self.locationSuccess = success;
    }
    if (failed) {
        self.locationFailed = failed;
    }
    
    if ([self isAvailableForLocation]) {  //定位服务总开关打开
        [self.locationManager startUpdatingLocation];
    } else {
        //定位服务未开启,提醒用户开启
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务未开启!\n请在设置-隐私-定位服务中\n开启本应用的定位功能!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}
//定位服务总开关,是否打开
- (BOOL)isAvailableForLocation {
    return [CLLocationManager locationServicesEnabled];
}

//获取定位状态
- (void)authorizeLocationStatue:(void (^)(CLAuthorizationStatus))finished {
    /*
    typedef NS_ENUM(int, CLAuthorizationStatus) {
        kCLAuthorizationStatusNotDetermined = 0,  //用户未做选择
        kCLAuthorizationStatusRestricted,   //未授权
        kCLAuthorizationStatusDenied,   //用户拒绝
        kCLAuthorizationStatusAuthorizedAlways    //8.0以后
        kCLAuthorizationStatusAuthorizedWhenInUse //8.0以后
        kCLAuthorizationStatusAuthorized   //8.0之前  已授权
    };
     */
    if (finished) {
        finished([CLLocationManager authorizationStatus]);
    }
}
#pragma mark - ==============联网相关===============
- (void)authorizeNetworkStatue:(CellularDataRestrictionDidUpdateNotifier)finished {
    //NSAssert(kHJSystemVersion >= 9.0, @"Only support iOS 9.0 later");
    
    if (kHJSystemVersion < 9.0) {
        return;
    }
    
    /*
     typedef NS_ENUM(NSUInteger, CTCellularDataRestrictedState) {
     kCTCellularDataRestrictedStateUnknown,   //未知
     kCTCellularDataRestricted,    //受限制
     kCTCellularDataNotRestricted   //未受限制
     };
     */
    if (finished) {
        self.cellularData.cellularDataRestrictionDidUpdateNotifier = finished;
    }
}

#pragma mark - ==============相册相关===============
//获取相册访问状态
- (void)authorizePhotoStatue:(void (^)(HJPhotoAuthorizeStatue))finished {
    NSInteger value;
    if (kHJSystemVersion >= 8.0) {
        /*
         typedef NS_ENUM(NSInteger, PHAuthorizationStatus) {
         PHAuthorizationStatusNotDetermined = 0
         PHAuthorizationStatusRestricted,
         PHAuthorizationStatusDenied,
         PHAuthorizationStatusAuthorized
         } 
         */
        value = [PHPhotoLibrary authorizationStatus];
        
    } else {
        /*
         typedef NS_ENUM(NSInteger, ALAuthorizationStatus) {
         ALAuthorizationStatusNotDetermined
         ALAuthorizationStatusRestricted
         ALAuthorizationStatusDenied
         ALAuthorizationStatusAuthorized
         }

         */
        value = [ALAssetsLibrary authorizationStatus];
    }
    if (finished) {
        finished(value);
    }
}
//请求访问相册
- (void)startPhotoAuthorize {
    //还有就是UIImagePickerController也可以获取
    if (kHJSystemVersion <= 8.0) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        }];
    } else {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:(ALAssetsGroupAll) usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        } failureBlock:^(NSError *error) {
        }];
    }
}

#pragma mark - ==============相机相关===============
//获取相机状态 
- (void)authorizeCameraStatue:(void (^)(AVAuthorizationStatus))finished {
    //MediaType 在 AVMediaFormat.h  文件中定义
    //AVMediaTypeVideo  相机
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (finished) {
        finished(status);
    }
}

//请求访问相机弹窗
- (void)startCameraAuthorize {
    //其他方式也行
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
    }];
}

#pragma mark - ==============麦克风相关===============
//查询麦克风授权状态
- (void)authorizeMicroStatue:(void (^)(AVAuthorizationStatus))finished {
    //MediaType 在 AVMediaFormat.h  文件中定义
    //AVMediaTypeVideo  相机
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (finished) {
        finished(status);
    }
}
//请求麦克风弹窗
- (void)startMicroAuthorize {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
    }];
}

#pragma mark - ==============通讯录相关===============
//查询通讯录授权状态
- (void)authorizeAddressBookStatue:(void (^)(HJAddressBookAuthorizeStatue))finished {
    NSInteger value;
    if (kHJSystemVersion < 9.0) {
        /*
         typedef CF_ENUM(CFIndex, ABAuthorizationStatus) {
         kABAuthorizationStatusNotDetermined = 0
         kABAuthorizationStatusRestricted
         kABAuthorizationStatusDenied
         kABAuthorizationStatusAuthorized
         }
         */
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        value = status;
    } else {
        /*
        typedef NS_ENUM(NSInteger, CNAuthorizationStatus)
        {
            CNAuthorizationStatusNotDetermined = 0,
            CNAuthorizationStatusRestricted,
            CNAuthorizationStatusDenied,
            CNAuthorizationStatusAuthorized
        }
        */
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:(CNEntityTypeContacts)];
        value = status;
    }
    
    if (finished) {
        finished(value);
    }
}

//请求通讯录权限弹窗
- (void)startAddressBookAuthorize {
    if (kHJSystemVersion < 9.0) {
        ABAddressBookRef addressBook = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
        });
    } else {
        CNContactStore *contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:(CNEntityTypeContacts) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            
        }];
    }
}

#pragma mark - ==============日历备忘录相关===============
//查询日历备忘录授权状态
- (void)authorizeEKForEKEntityType:(EKEntityType)type finished:(void (^)(EKAuthorizationStatus))finished {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:type];
    if (finished) {
        finished(status);
    }
}
//获取权限弹窗
- (void)startEKAuthorizeForKEntityType:(EKEntityType)type {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    [eventStore requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
        
    }];
}

#pragma mark - ==============蓝牙相关===============
- (void)authorizeBluetoothStatue:(void (^)(CBPeripheralManagerAuthorizationStatus))finished {
    /*
     typedef NS_ENUM(NSInteger, CBPeripheralManagerAuthorizationStatus) {
     CBPeripheralManagerAuthorizationStatusNotDetermined = 0,
     CBPeripheralManagerAuthorizationStatusRestricted,
     CBPeripheralManagerAuthorizationStatusDenied,
     CBPeripheralManagerAuthorizationStatusAuthorized,
     } NS_ENUM_AVAILABLE(NA, 7_0);

     */
    CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
    if (finished) {
        finished(status);
    }
}

//申请蓝牙授权
- (void)startBluetoothAuthorize {
    
}


#pragma mark - ==============推送相关===============

- (void)authorizeAddressBookStatu1e:(void (^)(HJAddressBookAuthorizeStatue))finished {
    NSUInteger value;
    if (kHJSystemVersion >= 8.0) {
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        UIUserNotificationType type = settings.types;
        value = type;
    } else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        value = type;
    }
    if (finished) {
        finished(value);
    }
}
- (void)startNotificationAuthorize {
#warning 需要实现的application方法
    if (kHJSystemVersion >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}
#pragma mark - CLLocationManagerDelegate 协议方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];  //停止定位
    switch ([error code]) {
        case kCLErrorLocationUnknown: //未知原因
            break;
        case kCLErrorDenied:  //用户拒绝
            break;
        case kCLErrorNetwork: //网络错误
            break;
        default:
            break;
    }
}
//完成定位的代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count != 0) {
        CLLocation *location = locations.firstObject;
        if (locations) {
            [self reverseGeocoderWithLocation:location];
        } else {
            if (self.locationFailed) {
                self.locationFailed();
            }
        }
    } else {
        if (self.locationFailed) {
            self.locationFailed();
        }
    }
    [self.locationManager stopUpdatingLocation]; //停止定位
}

//反地理编码
- (void)reverseGeocoderWithLocation:(CLLocation *)location {
    [self.gecoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error == nil && placemarks.count != 0) {
            CLPlacemark *placemark = placemarks.firstObject;
            if (self.locationSuccess) {
                self.locationSuccess(location, placemark);
            }
        } else {
            if (self.locationFailed) {
                self.locationFailed();
            }
        }
    }];
}

#pragma mark - 懒加载
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //定位精准度
        _locationManager.distanceFilter = 10;
        
        NSArray *infoKey = [[NSBundle mainBundle] infoDictionary].allKeys;
        BOOL isAvailable = [infoKey containsObject:@"NSLocationAlwaysUsageDescription"] || [infoKey containsObject:@"NSLocationWhenInUseUsageDescription"];
        
        NSAssert(isAvailable, @"Info.plist should add \"key-value\" with \"NSLocationAlwaysUsageDescription: NSString\"  or \"NSLocationWhenInUseUsageDescription: NSString\\");
       
        if (kHJSystemVersion >= 8.0) {  //8.0以后
            [_locationManager requestAlwaysAuthorization];  //一直
            [_locationManager requestWhenInUseAuthorization];  //使用期间
        }
    }
    return _locationManager;
}

- (CLGeocoder *)gecoder {
    if (!_gecoder) {
        _gecoder = [[CLGeocoder alloc] init];
    }
    return _gecoder;
}

- (CTCellularData *)cellularData {
    if (!_cellularData) {
        _cellularData = [[CTCellularData alloc] init];
    }
    return _cellularData;
}
@end
