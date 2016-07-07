//
//  HJXAuthorizeFunction.m
//  HJMethod
//
//  Created by coco on 16/7/7.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#import "HJAuthorizeFunction.h"
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


@end

@implementation HJAuthorizeFunction

static HJAuthorizeFunction *authorizeFunction = nil;

+ (instancetype)shareAuthorize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        authorizeFunction = [[HJAuthorizeFunction alloc] init];
    });
    return authorizeFunction;
}
//开始定位
- (void)startLocationWithSuccessBlock:(void (^)(CLLocation *location,CLPlacemark *placemark))success failed:(void (^)())failed {
    if (success) {
        self.locationSuccess = success;
    }
    if (failed) {
        self.locationFailed = failed;
    }
    
    if ([CLLocationManager locationServicesEnabled]) {  //定位服务总开关打开
        [authorizeFunction.locationManager startUpdatingLocation];
    } else {
        //定位服务未开启,提醒用户开启
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务未开启!\n请在设置-隐私-定位服务中\n开启本应用的定位功能!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

//获取定位状态
- (void)locationAuthorizationStatus {
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
    BOOL isAvailable = [CLLocationManager locationServicesEnabled];
    
    
    CLAuthorizationStatus locationStatue = [CLLocationManager authorizationStatus];
    
}




#pragma mark - CLLocationManagerDelegate 协议方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [authorizeFunction.locationManager stopUpdatingLocation];  //停止定位
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
    [authorizeFunction.locationManager stopUpdatingLocation]; //停止定位
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
@end
