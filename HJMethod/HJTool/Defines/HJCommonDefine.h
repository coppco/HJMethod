//
//  HJCommonDefine.h
//  HJMethod
//
//  Created by coco on 16/6/2.
//  Copyright © 2016年 XHJ. All rights reserved.
//

#ifndef HJCommonDefine_h
#define HJCommonDefine_h

#ifdef __OBJC__  //如果定义了OC

/*==================坐标相关==================*/
#define kViewH(view) view.frame.size.height
#define kViewW(view) view.frame.size.width
#define kViewX(view) view.frame.origin.x
#define kViewY(view) view.frame.origin.y

//获取主窗口的bounds
#define kMainScreenBounds ([UIScreen mainScreen].bounds)
//获取主窗口的bounds
#define kMainScreenSize ([UIScreen mainScreen].bounds.size)
//获取主窗口的高度
#define kMainScreenHeight ([UIScreen mainScreen].bounds.size.height)
//获取主窗口的宽度
#define kMainScreenWidth  ([UIScreen mainScreen].bounds.size.width)
/**获取主窗口*/
#define kMainScreen ([[UIApplication sharedApplication] keyWindow])
//获取正在显示的窗口(有可能是键盘等)
#define kVisibleScreen ([[UIApplication sharedApplication].windows lastObject])

/*==================字符串拼接==================*/
#define kStringFormat(FORMAT, ...) ([NSString stringWithFormat:FORMAT, ##__VA_ARGS__])

/*==================Property==================*/
// 通用 Property 宏定义
#define kHJpropertyAssign(__v__)      @property (nonatomic, assign)       __v__
#define kHJpropertyCopy(__v__)        @property (nonatomic, copy)         __v__
#define kHJpropertyWeak(__v__)        @property (nonatomic, weak)         __v__
#define kHJpropertyStrong(__v__)       @property (nonatomic, strong)       __v__

/*==================设备型号==================*/
#define __isIPHONE_3 (CGSizeEqualToSize(kMainScreenSize, CGSizeMake(320, 480))) && ([UIScreen mainScreen].scale == 1.0)
#define __isIPHONE_4S (CGSizeEqualToSize(kMainScreenSize, CGSizeMake(320, 480))) && ([UIScreen mainScreen].scale == 2.0)
#define __isIPHONE_5 CGSizeEqualToSize(kMainScreenSize, CGSizeMake(320, 568))
#define __isIPHONE_6 CGSizeEqualToSize(kMainScreenSize, CGSizeMake(375, 667))
#define __isIPHONE_6P CGSizeEqualToSize(kMainScreenSize, CGSizeMake(414, 736))

/*==================系统版本==================*/
#define __iOS_VERSION ([[UIDevice currentDevice].systemVersion floatValue])
#define __iOS_5_0 ((__iOS_VERSION) >= 5.0)
#define __iOS_6_0 ((__iOS_VERSION) >= 6.0)
#define __iOS_7_0 ((__iOS_VERSION) >= 7.0)
#define __iOS_8_0 ((__iOS_VERSION) >= 8.0)
#define __iOS_9_0 ((__iOS_VERSION) >= 9.0)

/*==================UIColor==================*/
//字符串转color
#define kColorFromString(x) ([UIColor colorFromHexString:(x)])
//清除背景色
#define kColorClear [UIColor clearColor]
//带有RGBA的颜色设置
#define kColorFromRGBA(R, G, B, A) ([UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)])
#define kColorFromRGB(R, G, B) kColorFromRGBA((R),(G),(B),1.0f)
// rgb颜色转换（0x12344->color）
#define kColorFromRGBValue(rgbValue) \
[UIColor colorFromRGBValue:(rgbValue)] \

/*==================UIFont对象==================*/
#define kFont(x) [UIFont systemFontOfSize:x]
#define kFontWeight(x,y) [UIFont systemFontOfSize:(x) weight:(y)]

/*==================UIImage对象==================*/
//imageWithContentsOfFile 不会长留内存(需要不在Assets中),适合大图片,一次性使用图片
#define kImageFile(A) \
[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(A) ofType:nil]] \

//会在内存中,适合小图片经常使用的图片
#define kImage(A) [UIImage imageNamed:(A)]

/*==================WEAK,定义weakSelf==================*/
#define kWeakSelf(weakSelf)  __weak __typeof(&*self)(weakSelf) = self

/*========================NSLog=======================*/
#ifdef DEBUG
#define XHJLog(FORMAT, ...) NSLog(@"%@:%d行   \n%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:FORMAT, ##__VA_ARGS__])
#else
#define XHJLog(FORMAT, ...) nil
#endif

//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d　\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif

/*================单例的宏定义=================*/
/**
 *  使用方法
 *
 *  1，在.h里调用 singleton_for_header(类名)
 *  2，在.m里调用 singleton_for_class(类名)
 */
// .h 调用
#define singleton_for_header(className) \
\
+ (className *)shared##className;


// .m 调用
#define singleton_for_class(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#endif
#endif /* HJCommonDefine_h */
